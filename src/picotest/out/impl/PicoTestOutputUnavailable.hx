package picotest.out.impl;

class PicoTestOutputUnavailable extends PicoTestTextOutputBase implements IPicoTestOutput {

	public function new() super();

	public function output(value:String):Void {
		throw "unavailable";
	}

	public function close():Void {
		// do nothing
	}
}
