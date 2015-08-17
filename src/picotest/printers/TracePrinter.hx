package picotest.printers;

class TracePrinter implements IPicoTestPrinter {

	public function new():Void {

	}

	public function printAssertResult(assertResult:PicoTestAssertResult):Void {
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				PicoTest.stdout(".");
			case PicoTestAssertResult.Failure(_,_):
				PicoTest.stdout("F");
			case PicoTestAssertResult.Error(_):
				PicoTest.stdout("E");
			case PicoTestAssertResult.Trace(_):
			case PicoTestAssertResult.Ignore(_):
				PicoTest.stdout("I");
		}
	}

	public function print(result:PicoTestResult):Void {
		// PicoTest.stdout("\n");
	}
}
