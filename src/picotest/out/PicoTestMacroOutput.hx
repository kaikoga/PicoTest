package picotest.out;

import picotest.macros.PicoTestMacros;

class PicoTestMacroOutput implements IPicoTestOutput {

	private static var _currentLine:String = "";

	public function new() {
	}

	public function stdout(value:String):Void {
		PicoTestOutputUtils.cachedOutput(value, function(line:String) PicoTestMacros.println(line));
	}

	public function close():Void {
		// do nothing
	}
}
