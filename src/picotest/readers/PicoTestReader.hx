package picotest.readers;

import picotest.tasks.PicoTestIgnoreTestTask;
import picotest.tasks.PicoTestTestTask;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>):Void {
		var className:String = Type.getClassName(testCaseClass);
		var allMeta:Dynamic<Dynamic<Array<Dynamic>>> = haxe.rtti.Meta.getFields(testCaseClass);

		for (field in Type.getInstanceFields(testCaseClass)) {
			var testType:TestType = TestType.None;
			if (field.indexOf("test") == 0) {
				testType = TestType.Test;
			}

			if (Reflect.hasField(allMeta, field)) {
				var meta:Dynamic<Array<Dynamic>> = Reflect.field(allMeta, field);
				if (Reflect.hasField(meta, "Test")) {
					testType = TestType.Test;
				}
				if (Reflect.hasField(meta, "Ignore")) {
					var message:String = Reflect.field(meta, "Ignore");
					if (message == null) message = ""; 
					testType = TestType.Ignore(message);
				}
			}
			switch (testType) {
				case TestType.None:
				case TestType.Test:
					var testCase:Dynamic;
					try {
						testCase = Type.createInstance(testCaseClass, []);
					} catch (d:Dynamic) {
						testCase = Type.createEmptyInstance(testCaseClass);
					}
					var task = new PicoTestTestTask(new PicoTestResult(className, field), bind(testCase, field));
					runner.add(task);
				case TestType.Ignore(message):
					var task = new PicoTestIgnoreTestTask(new PicoTestResult(className, field), message);
					runner.add(task);
			}
		}
	}

	private function bind(d:Dynamic, field:String):Void->Void {
		return function():Void {
			Reflect.callMethod(d, Reflect.field(d, field), []);
		};
	}
}

private enum TestType {
	None;
	Test;
	Ignore(message:String);
}
