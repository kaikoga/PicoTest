package picotest.printers;

interface IPicoTestPrinter {

	function printAssertResult(result:PicoTestAssertResult):Void;
	function print(result:PicoTestResult):Void;

}
