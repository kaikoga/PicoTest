package picotest.printers;

import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;
import picotest.result.PicoTestResultSummary;

interface IPicoTestPrinter {

	function printTestCase(result:PicoTestResult, firstTime:Bool, progress:Float, completed:Int, total:Int):Void;
	function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void;
	function printTestResult(result:PicoTestResult):Void;
	function printComplete(summary:PicoTestResultSummary):Void;
	function close():Void;
}
