package picotest.printers;

class VerboseTracePrinter implements IPicoTestPrinter {

	public function new():Void {

	}

	public function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void {
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
		PicoTest.stdout('\n${result.className}.${result.methodName}${result.printParameters()}\n');
	}
}
