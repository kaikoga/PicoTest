package picotest.out.impl;

#if js

import picotest.out.buffer.PicoTestOutputLineBuffer;

class PicoTestJsOutput extends PicoTestTextOutputBase implements IPicoTestOutput {

	private var buffer:PicoTestOutputLineBuffer;

	private function println(line:String):Void untyped js.Boot.__trace(cast line, null);

	public function new() {
		super();
		this.buffer = new PicoTestOutputLineBuffer(println);
	}

	public function output(value:String):Void {
		try {
			// try node
			untyped process.stdout.write(value);
		} catch (e:Dynamic) {
			// fallback to haxe std trace
			this.buffer.output(value);
			this.buffer.emit();
		}
	}

	public function close():Void {
		this.buffer.close();
	}
}

#end

