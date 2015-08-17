package picotest.readers;

import haxe.Json;
import picotest.reporters.JsonReporter;

class PicoTestResultReader {

	public function new():Void {

	}

	public function read(runner:PicoTestRunner, report:String, header:String):Void {
		var json:Array<HashedResult> = Json.parse(report);
		for (hashedResult in json) {
			var result:PicoTestResult = JsonReporter.unhashResult(hashedResult, header);
			runner.addResult(result);
		}

	}
}
