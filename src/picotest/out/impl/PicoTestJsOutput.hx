package picotest.out.impl;

#if js

class PicoTestJsOutput implements IPicoTestOutput {

	private var buffer:PicoTestOutputBuffer;

	public function new() {
		this.buffer = new PicoTestOutputBuffer();
	}

	public function output(value:String):Void {
		try {
			// try node
			untyped process.stdout.write(value);
		} catch (e:Dynamic) {
			// fallback to haxe std trace
			this.buffer.output(value, function(line:String) untyped js.Boot.__trace(cast line, null));
		}
	}

	public function close():Void {
		// do nothing
	}
}

#end

