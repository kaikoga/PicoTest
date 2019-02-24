package picotest.printers;

import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestResult;
import picotest.result.PicoTestResultSummary;

class VerboseTracePrinter implements IPicoTestPrinter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function printTestCase(result:PicoTestResult, firstTime:Bool, progress:Float, completed:Int, total:Int):Void {
		this.stdout.progress(progress, completed, total);
		var p:String = '${Std.string(Math.round(progress * 100))}%';
		var testFullName:String = '${result.className}.${result.methodName}${result.printExecInfo()}';
		if (firstTime) {
			this.stdout.output('\n${testFullName}:${p}\n');
		} else {
			this.stdout.output('\n${testFullName} (async):${p}\n  ');
		}
	}

	public function printAssertResult(result:PicoTestResult, assertResult:PicoTestAssertResult):Void {
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				this.stdout.output(".");
			case PicoTestAssertResult.Skip:
				this.stdout.output("S");
			case PicoTestAssertResult.DryRun:
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

	public function printComplete(summary:PicoTestResultSummary):Void {
		this.stdout.complete(summary.mark);
	}

	public function close():Void {
		this.stdout.close();
	}
}
