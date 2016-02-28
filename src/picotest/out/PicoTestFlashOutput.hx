package picotest.out;

import flash.Lib;

class PicoTestFlashOutput implements IPicoTestOutput {

	private static var _currentLine:String = "";

	public function new() {
	}

	public function stdout(value:String):Void {
		var lines:Array<String> = (_currentLine + value).split("\n");
		_currentLine = lines.pop();
		for (line in lines) Lib.trace(line);
	}

	public function close():Void {
		// do nothing
	}
}
