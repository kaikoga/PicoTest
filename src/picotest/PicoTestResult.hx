package picotest;

import picotest.PicoTestAssertResult;
import picotest.tasks.IPicoTestTask;

class PicoTestResult {

	public var task(default, null):IPicoTestTask;
	public var assertResults:Array<PicoTestAssertResult>;

	public function new(task:IPicoTestTask, assertResults:Array<PicoTestAssertResult> = null) {
		this.task = task;
		this.assertResults = if (assertResults != null) assertResults; else [];
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
}
