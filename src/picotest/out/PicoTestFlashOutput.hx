package picotest.out;

import flash.Lib;

class PicoTestFlashOutput implements IPicoTestOutput {

	private static var _currentLine:String = "";

	public function new() {
	}

	public function stdout(value:String):Void {
		PicoTestOutputUtils.cachedOutput(value, function(line:String) Lib.trace(line));
	}

	public function close():Void {
		// do nothing
	}
}
