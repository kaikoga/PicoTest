package picotest.printers;

import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;

interface IPicoTestPrinter {

	function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void;
	function print(result:PicoTestResult):Void;

}
