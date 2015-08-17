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

		}
	}

	public function print(result:PicoTestResult):Void {
		// PicoTest.stdout("\n");
	}
}
