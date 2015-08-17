package picotest;

import picotest.tasks.IPicoTestTask;
import picotest.PicoTestAssertResult;

/**
	Test method result of PicoTest.
**/
class PicoTestResult {

	public var className(default, null):String;
	public var methodName(default, null):String;
	public var assertResults(default, null):Array<PicoTestAssertResult>;
	public var tasks(default, null):Array<IPicoTestTask>;

	public function new(className:String, methodName:String, assertResults:Array<PicoTestAssertResult> = null) {
		this.className = className;
		this.methodName = methodName;
		this.assertResults = if (assertResults != null) assertResults; else [];
		this.tasks = [];
	}

	public function isFail():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Failure(_,_): return true;
				default:
			}
		}
		return false;
	}

	public function isError():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Error(_,_): return true;
				default:
			}
		}
		return false;
	}

	public function startTask(task:IPicoTestTask):Void {
		this.tasks.push(task);
	}

	public function completeTask(task:IPicoTestTask):Bool {
		this.tasks.remove(task);
		return this.tasks.length == 0;
	}
}
