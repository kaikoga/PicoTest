package picotest.readers;

import haxe.Json;
import picotest.reporters.JsonTraceReporter;
import picotest.result.PicoTestResult;

class PicoTestResultReader {

	public function new():Void {

	}

	public function read(runner:PicoTestRunner, report:String, header:String):Void {
		var PICOTEST_RESULT_HEADER = JsonTraceReporter.PICOTEST_RESULT_HEADER;
		var json:Array<HashedResult> = Json.parse(report.substr(report.indexOf(PICOTEST_RESULT_HEADER) + PICOTEST_RESULT_HEADER.length));
		for (hashedResult in json) {
			var result:PicoTestResult = JsonTraceReporter.unhashResult(hashedResult, header);
			runner.addResult(result);
		}

	}
}
