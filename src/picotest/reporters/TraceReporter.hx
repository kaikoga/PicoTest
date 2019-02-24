package picotest.reporters;

import picotest.macros.PicoTestConfig;
import picotest.out.IPicoTestOutput;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestCallInfo;
import picotest.result.PicoTestResult;
import picotest.result.PicoTestResultMark;
import picotest.result.PicoTestResultSummary;

class TraceReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(summary:PicoTestResultSummary):Void {
		this.stdout.output("\nreport:\n");
		var map:Map<String, Array<PicoTestResult>> = new Map();
		for (result in summary.results) {
			if (!map.exists(result.className)) map[result.className] = [];
			var a:Array<PicoTestResult> = map[result.className];
			a.push(result);
		}

		for (className in map.keys()) {
			var row:String = '$className: ';
			var text:Array<String> = [];
			for (result in map[className]) {
				var resultText:Array<String> = ["", '${result.className}:${result.methodName}():'];
				for (assertResult in result.assertResults) {
					switch (assertResult) {
						case PicoTestAssertResult.Success:
						case PicoTestAssertResult.Skip:
						case PicoTestAssertResult.DryRun:
						case PicoTestAssertResult.Failure(message, callInfo):
							resultText.push('${callInfo.print()}${result.printExecInfo()}: ${message}');
						case PicoTestAssertResult.Error(message, callInfo):
							resultText.push('${callInfo.print()}${result.printExecInfo()}: [Error] ${message}');
						case PicoTestAssertResult.Trace(message, callInfo):
							if (PicoTestConfig.showTrace) {
								for (line in message.split("\n")) {
									resultText.push('${callInfo.print()}${result.printExecInfo()}: [Trace] ${line}');
								}
							}
						case PicoTestAssertResult.Ignore(message, callInfo):
							if (PicoTestConfig.showIgnore) {
								resultText.push('${callInfo.print()}${result.printExecInfo()}: [Ignore] ${message}');
							}
						case PicoTestAssertResult.Invalid(message, callInfo):
							resultText.push('${callInfo.print()}${result.printExecInfo()}: [Invalid] ${message}');
					}
				}
				switch (result.mark()) {
					case PicoTestResultMark.Empty:
						row += "0";
						var callInfo:PicoTestCallInfo = PicoTestCallInfo.fromReflect(result.className, result.methodName);
						resultText.push('${callInfo.print()}${result.printExecInfo()}: [Empty] Test is empty');
					case PicoTestResultMark.DryRun:
						row += "N";
						var callInfo:PicoTestCallInfo = PicoTestCallInfo.fromReflect(result.className, result.methodName);
						resultText.push('${callInfo.print()}${result.printExecInfo()}: [DryRun] Test is to be run');
					case PicoTestResultMark.Success:
						row += ".";
					case PicoTestResultMark.Skip:
						row += "S";
					case PicoTestResultMark.Failure:
						row += "F";
					case PicoTestResultMark.Error:
						row += "E";
					case PicoTestResultMark.Ignore:
						row += "I";
					case PicoTestResultMark.Invalid:
						row += "X";
				}
				if (resultText.length > 2) text = text.concat(resultText);
			}
			this.stdout.output(row + "\n");
			if (text.length > 0) for(row in text) this.stdout.output(row + "\n");
			this.stdout.output("\n\n");
		}
		this.stdout.output(summary.summarize());
	}

	public function close():Void {
		this.stdout.close();
	}
}
