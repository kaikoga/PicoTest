package picotest.readers;

import picotest.tasks.PicoTestIgnoreTestTask;
import picotest.tasks.PicoTestTestTask;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Array<Dynamic>> = null):Void {
		var className:String = Type.getClassName(testCaseClass);
		var allMeta:Dynamic<Dynamic<Array<Dynamic>>> = haxe.rtti.Meta.getFields(testCaseClass);

		var hasSetup:Bool = false;
		var hasTearDown:Bool = false;
		for (field in Type.getInstanceFields(testCaseClass)) {
			switch (field) {
				case "setup": hasSetup = true;
				case "tearDown": hasTearDown = true;
			}
		}

		for (field in Type.getInstanceFields(testCaseClass)) {
			var testType:TestType = TestType.None;
			var parameterProviders:Array<String> = [];
			if (field.indexOf("test") == 0) {
				testType = TestType.Test;
			}

			if (Reflect.hasField(allMeta, field)) {
				var meta:Dynamic<Array<Dynamic>> = Reflect.field(allMeta, field);
				if (Reflect.hasField(meta, "Test")) {
					testType = TestType.Test;
				}
				if (Reflect.hasField(meta, "Ignore")) {
					var message:String = null;
					var messages:Array<Dynamic> = Reflect.field(meta, "Ignore");
					if (messages != null) {
						message = messages.map(function(v:Dynamic):String return Std.string(v)).join("\n");
					}
					if (message == null) message = "";
					testType = TestType.Ignore(message);
				}
				if (Reflect.hasField(meta, "Parameter")) {
					var parameterProviderNames:Array<Dynamic> = Reflect.field(meta, "Parameter");
					if (parameterProviderNames != null) {
						parameterProviders = parameterProviderNames.map(function(v:Dynamic):String return Std.string(v));
					}
				}
			}
			switch (testType) {
				case TestType.None:
				case TestType.Test:
					var parameters:Iterable<Array<Dynamic>> = null;
					if (parameterProviders.length > 0) {
						parameters = bind(createInstance(testCaseClass), parameterProviders[0], [])();
					}
					if (parameters == null) parameters = defaultParameters;
					if (parameters == null || !parameters.iterator().hasNext()) parameters = [[]];
					for (arguments in parameters) {
						var testCase:Dynamic = createInstance(testCaseClass);
						var func:Void->Void = bind(testCase, field, arguments);
						var setup:Void->Void = hasSetup ? bind(testCase, "setup", []) : null;
						var tearDown:Void->Void = hasTearDown ? bind(testCase, "tearDown", []) : null;
						var task = new PicoTestTestTask(new PicoTestResult(className, field, null, setup, tearDown), func);
						runner.add(task);
					}
				case TestType.Ignore(message):
					var task = new PicoTestIgnoreTestTask(new PicoTestResult(className, field), message);
					runner.add(task);
			}
		}
	}

	private function createInstance<T>(instanceClass:Class<T>):T {
		var instance:T;
		try {
			instance = Type.createInstance(instanceClass, []);
		} catch (d:Dynamic) {
			instance = Type.createEmptyInstance(instanceClass);
		}
		return instance;
	}

	private function bind(d:Dynamic, field:String, args:Array<Dynamic>):Void->Dynamic {
		return function():Dynamic {
			return Reflect.callMethod(d, Reflect.field(d, field), args);
		};
	}
}

private enum TestType {
	None;
	Test;
	Ignore(message:String);
}
