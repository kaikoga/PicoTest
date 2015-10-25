package picotest.readers;

import picotest.tasks.PicoTestIgnoreTestTask;
import picotest.tasks.PicoTestTestTask;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Array<Dynamic>> = null):Void {
		var className:String = Type.getClassName(testCaseClass);
		var allMeta:Dynamic<Dynamic<Array<Dynamic>>> = haxe.rtti.Meta.getFields(testCaseClass);

		var tests:Array<TestType> = [];
		var hasSetup:Bool = false;
		var hasTearDown:Bool = false;
		var setupParameters:ParameterProvider = [[]];

		for (field in Type.getInstanceFields(testCaseClass)) {
			var meta:Dynamic<Array<Dynamic>>;
			if (Reflect.hasField(allMeta, field)) {
				meta = Reflect.field(allMeta, field);
			} else {
				meta = {};
			}

			var parameters:ParameterProvider = null;
			if (Reflect.hasField(meta, "Parameter")) {
				var metaParameter:Array<Dynamic> = Reflect.field(meta, "Parameter");
				if (metaParameter == null) {
					// default parameter
					parameters = defaultParameters;
				} else {
					var parameterProviderName:String = Std.string(metaParameter[0]);
					parameters = bind(createInstance(testCaseClass), parameterProviderName, [])();
					if (parameters == null) parameters = defaultParameters;
					if (parameters == null || !parameters.iterator().hasNext()) parameters = [[]];
				}
			} else {
				parameters = [[]];
			}

			var testType:TestType;
			switch (field) {
				case "setup":
					hasSetup = true;
					setupParameters = parameters;
				case "tearDown":
					hasTearDown = true;
				default:
					if (Reflect.hasField(meta, "Ignore")) {
						var message:String = null;
						var metaIgnore:Array<Dynamic> = Reflect.field(meta, "Ignore");
						if (metaIgnore != null) {
							message = metaIgnore.map(function(v:Dynamic):String return Std.string(v)).join("\n");
						}
						if (message == null) message = "";
						tests.push(TestType.Ignore(field, message));
					} else if (field.indexOf("test") == 0) {
						tests.push(TestType.Test(field, parameters));
					} else if (Reflect.hasField(meta, "Test")) {
						tests.push(TestType.Test(field, parameters));
					}
			}
		}

		for (test in tests) {
			switch (test) {
				case TestType.Test(field, parameters):
					for (setupArguments in setupParameters) {
						for (arguments in parameters) {
						var testCase:Dynamic = createInstance(testCaseClass);
						var func:Void->Void = bind(testCase, field, arguments);
						var setup:Void->Void = hasSetup ? bind(testCase, "setup", setupArguments) : null;
						var tearDown:Void->Void = hasTearDown ? bind(testCase, "tearDown", []) : null;
						var task = new PicoTestTestTask(new PicoTestResult(className, field, null, setup, tearDown), func);
						runner.add(task);
					}
					}
				case TestType.Ignore(field, message):
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
	Test(field:String, parameters:Iterable<Array<Dynamic>>);
	Ignore(field:String, message:String);
}

private typedef ParameterProvider = Iterable<Array<Dynamic>>;
