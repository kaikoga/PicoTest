#if sys

package picotest.readers;

import sys.io.File;

class PicoTestFileResultReader {

	public function new():Void {

	}

	public function read(runner:PicoTestRunner, reportFile:String, header:String = null):Void {
		var report:String = File.read(reportFile).readAll().toString();
		if (report == null || report == "") throw '$reportFile: report file not found';
		new PicoTestResultReader().read(runner, report, header);
	}
}
#end

