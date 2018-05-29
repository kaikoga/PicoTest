package picotest.out.buffer;

class PicoTestOutputStringBuffer extends PicoTestOutputBuffer {

	dynamic private function print(message:String):Void return;

	public function new(print:String->Void) {
		super();
		this.print = print;
	}

	override public function emit():Void {
		this.print(this.buffer);
		this.buffer = "";
	}

	override public function close():Void {
		this.emit();
	}
}
