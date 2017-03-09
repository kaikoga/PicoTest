package picotest.out.impl;

class PicoTestOutputUnavailable implements IPicoTestOutput {

	public function new() {
	}

	public function stdout(value:String):Void {
		throw "unavailable";
	}

	public function close():Void {
		// do nothing
	}
}
