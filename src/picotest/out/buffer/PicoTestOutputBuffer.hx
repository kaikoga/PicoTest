package picotest.out.buffer;

class PicoTestOutputBuffer {

	private var buffer:String = "";

	public function new() return;

	public function output(value:String):Void {
		this.buffer += value;
	}

	public function emit():Void {
		// override me
	}

	public function close():Void {
		// do nothing
	}
}
