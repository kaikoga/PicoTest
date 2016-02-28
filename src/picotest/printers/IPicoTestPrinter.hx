package picotest.printers;

interface IPicoTestPrinter {

	function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void;
	function print(result:PicoTestResult):Void;

}
