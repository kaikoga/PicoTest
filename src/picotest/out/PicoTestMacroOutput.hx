package picotest.out;

import picotest.macros.PicoTestMacros;

class PicoTestMacroOutput implements IPicoTestOutput {

	private static var _currentLine:String = "";

	public function new() {
	}

	public function stdout(value:String):Void {
		var lines:Array<String> = (_currentLine + value).split("\n");
		_currentLine = lines.pop();
		for (line in lines) PicoTestMacros.println(line);
	}

	public function close():Void {
		// do nothing
	}
}
