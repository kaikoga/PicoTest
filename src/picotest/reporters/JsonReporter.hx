package picotest.reporters;

import picotest.formats.PicoTestJsonResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResult;

class JsonReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function JsonReporter(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(results:Array<PicoTestResult>):Void {
		this.stdout.output(PicoTestJsonResultFormat.serialize(results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
