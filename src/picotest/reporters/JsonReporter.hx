package picotest.reporters;

import picotest.formats.PicoTestJsonResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResultSummary;

class JsonReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function JsonReporter(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(summary:PicoTestResultSummary):Void {
		this.stdout.output(PicoTestJsonResultFormat.serialize(summary.results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
