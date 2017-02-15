package picotest.reporters;

import picotest.result.PicoTestResult;

interface IPicoTestReporter {
	function report(results:Array<PicoTestResult>):Void;
}
