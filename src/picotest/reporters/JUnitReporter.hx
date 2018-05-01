package picotest.reporters;

import picotest.formats.PicoTestJUnitResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResult;

class JUnitReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(results:Array<PicoTestResult>):Void {
		this.stdout.output(PicoTestJUnitResultFormat.serialize(results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
