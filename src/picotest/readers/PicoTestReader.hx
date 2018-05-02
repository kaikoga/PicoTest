package picotest.readers;

import picotest.macros.PicoTestFilter;
import haxe.Constraints.Function;
import picotest.tasks.IPicoTestTask;
import picotest.tasks.PicoTestIgnoreTestTask;
import picotest.tasks.PicoTestInvalidTestTask;
import picotest.tasks.PicoTestTestTask;
import picotest.result.PicoTestResult;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Array<Dynamic>> = null):Void {
		var className:String = Type.getClassName(testCaseClass);
		if (!PicoTestFilter.filter(className)) return;

		var allMeta:Dynamic<Dynamic<Array<Dynamic>>> = haxe.rtti.Meta.getFields(testCaseClass);

		var tests:Array<TestType> = [];
		var hasSetup:Bool = false;
		var hasTearDown:Bool = false;
		var setupParameters:ParameterProvider = [[]];

		var task:IPicoTestTask;

		var fields:Array<String> = Type.getInstanceFields(testCaseClass);
		fields.sort(Reflect.compare);
		for (field in fields) {
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
					try {
						parameters = bind(createInstance(testCaseClass), parameterProviderName, [])();
					} catch (message:String) {
						task = new PicoTestInvalidTestTask(new PicoTestResult(className, field), message);
						runner.add(task);
						continue;
					}
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
							var resultArguments:Array<Dynamic> = setupArguments.concat(arguments);
							try {
								var testCase:Dynamic = createInstance(testCaseClass);
								var func:Void->Void = bind(testCase, field, arguments);
								var setup:Void->Void = hasSetup ? bind(testCase, "setup", setupArguments) : null;
								var tearDown:Void->Void = hasTearDown ? bind(testCase, "tearDown", []) : null;
								task = new PicoTestTestTask(new PicoTestResult(className, field, resultArguments, null, setup, tearDown), func);
								runner.add(task);
							} catch (message:String) {
								task = new PicoTestInvalidTestTask(new PicoTestResult(className, field, resultArguments), message);
								runner.add(task);
							}
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
		var func:Function;
		try {
			func = Reflect.field(d, field);
		} catch (d:Dynamic) {
			func = null;
		}
		if (func == null) throw ("Picotest: function " + field + " not found in " + Std.string(d));
		return function():Dynamic {
			return Reflect.callMethod(d, func, args);
		};
	}
}

private enum TestType {
	Test(field:String, parameters:Iterable<Array<Dynamic>>);
	Ignore(field:String, message:String);
}

private typedef ParameterProvider = Iterable<Array<Dynamic>>;
