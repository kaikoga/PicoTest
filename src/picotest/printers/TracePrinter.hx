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
			case PicoTestAssertResult.Error(_,_):
				PicoTest.stdout("E");
			case PicoTestAssertResult.Trace(_,_):
			case PicoTestAssertResult.Ignore(_,_):
				PicoTest.stdout("I");
			case PicoTestAssertResult.Invalid(_,_):
				PicoTest.stdout("X");
		}
	}

	public function print(result:PicoTestResult):Void {
		// PicoTest.stdout("\n");
	}
}
