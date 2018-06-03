package picotest.reporters;

import picotest.formats.PicoTestJUnitResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResultSummary;

class JUnitReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(summary:PicoTestResultSummary):Void {
		this.stdout.output(PicoTestJUnitResultFormat.serialize(summary.results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
