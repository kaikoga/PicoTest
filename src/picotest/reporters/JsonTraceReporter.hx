package picotest.reporters;

import picotest.formats.PicoTestJsonTraceResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResultSummary;

class JsonTraceReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(summary:PicoTestResultSummary):Void {
		this.stdout.output(PicoTestJsonTraceResultFormat.serialize(summary.results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
