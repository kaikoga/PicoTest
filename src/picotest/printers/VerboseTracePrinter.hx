package picotest.printers;

import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;

class VerboseTracePrinter implements IPicoTestPrinter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function printTestCase(result:PicoTestResult, firstTime:Bool):Void {
		this.stdout.output('\n${result.className}.${result.methodName}${result.printParameters()}${firstTime ? ":\n" : " (async):\n  "}');
	}

	public function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void {
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				this.stdout.output(".");
			case PicoTestAssertResult.Skip:
				this.stdout.output("S");
			case PicoTestAssertResult.Failure(_,_):
				this.stdout.output("F");
			case PicoTestAssertResult.Error(_,_):
				this.stdout.output("E");
			case PicoTestAssertResult.Trace(m,_):
				this.stdout.output(m);
			case PicoTestAssertResult.Ignore(_,_):
				this.stdout.output("I");
			case PicoTestAssertResult.Invalid(_,_):
				this.stdout.output("X");
		}
	}

	public function printTestResult(result:PicoTestResult):Void {
		this.stdout.output('\n');
	}

	public function close():Void {
		this.stdout.close();
	}
}
