package picotest.readers;

import haxe.Json;
import picotest.reporters.JsonReporter;
import picotest.result.PicoTestResult;

class PicoTestResultReader {

	public function new():Void {

	}

	public function read(runner:PicoTestRunner, report:String, header:String):Void {
		var PICOTEST_RESULT_HEADER = JsonReporter.PICOTEST_RESULT_HEADER;
		var json:Array<HashedResult> = Json.parse(report.substr(report.indexOf(PICOTEST_RESULT_HEADER) + PICOTEST_RESULT_HEADER.length));
		for (hashedResult in json) {
			var result:PicoTestResult = JsonReporter.unhashResult(hashedResult, header);
			runner.addResult(result);
		}

	}
}
