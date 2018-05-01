package picotest.reporters;

import picotest.formats.PicoTestJsonTraceResultFormat;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestResult;

class JsonTraceReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(results:Array<PicoTestResult>):Void {
		this.stdout.output(PicoTestJsonTraceResultFormat.serialize(results));
	}

	public function close():Void {
		this.stdout.close();
	}
}
