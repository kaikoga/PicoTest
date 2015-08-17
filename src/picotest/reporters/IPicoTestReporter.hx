package picotest.reporters;

interface IPicoTestReporter {
	function report(results:Array<PicoTestResult>):Void;
}
