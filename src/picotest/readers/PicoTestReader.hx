package picotest.readers;

import picotest.tasks.PicoTestSimpleTask;

class PicoTestReader implements IPicoTestReader {

	public function new():Void {

	}

	public function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>):Void {
		var className:String = Type.getClassName(testCaseClass);
		var testCase:Dynamic = Type.createEmptyInstance(testCaseClass);
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
				var task = new PicoTestSimpleTask(className, field, Reflect.field(testCase, field));
				runner.add(task);
			}
		}

	}
}
