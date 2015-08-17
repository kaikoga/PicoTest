package picotest;

import picotest.PicoTestAssertResult;

/**
	Test method result of PicoTest.
**/
class PicoTestResult {

	public var className(default, null):String;
	public var methodName(default, null):String;
	public var assertResults:Array<PicoTestAssertResult>;

	public function new(className:String, methodName:String, assertResults:Array<PicoTestAssertResult> = null) {
		this.className = className;
		this.methodName = methodName;
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
