package picotest.reporters;

import picotest.result.PicoTestResultSummary;

interface IPicoTestReporter {
	function report(summary:PicoTestResultSummary):Void;
	function close():Void;
}
