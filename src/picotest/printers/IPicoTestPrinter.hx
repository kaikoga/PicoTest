package picotest.printers;

import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;

interface IPicoTestPrinter {

	function printTestCase(result:PicoTestResult, firstTime:Bool):Void;
	function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void;
	function printTestResult(result:PicoTestResult):Void;
	function close():Void;
}
