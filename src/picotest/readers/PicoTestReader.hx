package picotest.readers;

import picotest.tasks.PicoTestSimpleTestTask;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>):Void {
		var className:String = Type.getClassName(testCaseClass);
		var allMeta:Dynamic<Dynamic<Array<Dynamic>>> = haxe.rtti.Meta.getFields(testCaseClass);

		for (field in Type.getInstanceFields(testCaseClass)) {
			var isTest:Bool = false;
			if (field.indexOf("test") == 0) {
				isTest = true;
			}

			if (Reflect.hasField(allMeta, field)) {
				var meta:Dynamic<Array<Dynamic>> = Reflect.field(allMeta, field);
				if (Reflect.hasField(meta, "Test")) {
					isTest = true;
				}
			}
			if (isTest) {
				var testCase:Dynamic;
				try {
					testCase = Type.createInstance(testCaseClass, []);
				} catch (d:Dynamic) {
					testCase = Type.createEmptyInstance(testCaseClass);
				}
				var task = new PicoTestSimpleTestTask(className, field, bind(testCase, field));
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
