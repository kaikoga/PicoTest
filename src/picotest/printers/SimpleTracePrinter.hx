package picotest.printers;

import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;

class SimpleTracePrinter implements IPicoTestPrinter {

	public function new():Void {

	}

	public function printTestCase(result:PicoTestResult, firstTime:Bool):Void {
		// PicoTest.stdout("\n");
	}

	public function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void {
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				PicoTest.stdout(".");
			case PicoTestAssertResult.Skip:
				PicoTest.stdout("S");
			case PicoTestAssertResult.Failure(_,_):
				PicoTest.stdout("F");
			case PicoTestAssertResult.Error(_,_):
				PicoTest.stdout("E");
			case PicoTestAssertResult.Trace(_,_):
			case PicoTestAssertResult.Ignore(_,_):
				PicoTest.stdout("I");
			case PicoTestAssertResult.Invalid(_,_):
				PicoTest.stdout("X");
		}
	}

	public function printTestResult(result:PicoTestResult):Void {
		// PicoTest.stdout("\n");
	}
}
