package picotest.reporters;

class TraceReporter implements IPicoTestReporter {

	public function new():Void {

	}

	public function report(results:Array<PicoTestResult>):Void {
		PicoTest.stdout("\nreport:\n");
		var map:Map<String, Array<PicoTestResult>> = new Map();
		for (result in results) {
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
						case PicoTestAssertResult.Failure(message, callInfo):
							resultText.push('${callInfo.print()}: ${message}');
						case PicoTestAssertResult.Error(message, callInfo):
							resultText.push('${callInfo.print()}: [Error] ${message}');
						case PicoTestAssertResult.Trace(message, callInfo):
							for (line in message.split("\n")) {
								resultText.push('${callInfo.print()}: [Trace] ${line}');
							}
						case PicoTestAssertResult.Ignore(message, callInfo):
							resultText.push('${callInfo.print()}: [Ignore] ${message}');
						case PicoTestAssertResult.Invalid(message, callInfo):
							resultText.push('${callInfo.print()}: [Invalid] ${message}');
					}
				}
				switch (result.mark()) {
					case PicoTestResultMark.Empty:
						row += "0";
						resultText.push('${callInfo.print()}: [Empty] Test is empty');
					case PicoTestResultMark.Success:
						row += ".";
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
			PicoTest.stdout(row + "\n");
			if (text.length > 0) for(row in text) PicoTest.stdout(row + "\n");
			PicoTest.stdout("\n\n");
		}
		PicoTest.stdout(new PicoTestResultSummary().read(results).summarize());
	}


}
