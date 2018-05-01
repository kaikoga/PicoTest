package picotest.readers;

import picotest.formats.PicoTestJsonTraceResultFormat;

class PicoTestResultReader {

	public function new():Void {

	}

	public function read(runner:PicoTestRunner, report:String, header:String):Void {
		for (result in PicoTestJsonTraceResultFormat.deserialize(report, header)) {
			runner.addResult(result);
		}
	}
}
