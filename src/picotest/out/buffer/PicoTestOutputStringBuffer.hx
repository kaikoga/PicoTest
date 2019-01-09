package picotest.out.buffer;

class PicoTestOutputStringBuffer extends PicoTestOutputBuffer {

	public var value(default, null):String;

	dynamic private function progress(fragment:String):Void return;

	public function new(progress:String->Void) {
		super();
		this.progress = progress;
		this.value = "";
	}

	override public function emit():Void {
		this.progress(this.buffer);
		this.value += this.buffer;
		this.buffer = "";
	}

	override public function close():Void {
		this.value += this.buffer;
		this.buffer = "";
	}
}
