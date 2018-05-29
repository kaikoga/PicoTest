package picotest.out.buffer;

class PicoTestOutputLineBuffer extends PicoTestOutputBuffer {

	dynamic private function println(message:String):Void return;

	public function new(println:String->Void) {
		super();
		this.println = println;
	}

	override public function emit():Void {
		var lines:Array<String> = this.buffer.split("\n");
		this.buffer = lines.pop();
		for (line in lines) this.println(line);
	}

	override public function close():Void {
		this.println(this.buffer);
		this.buffer = "";
	}
}
