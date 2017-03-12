package picotest.out.impl;

#if flash

import flash.Lib;

class PicoTestFlashOutput implements IPicoTestOutput {

	private var buffer:PicoTestOutputBuffer;

	public function new() {
		this.buffer = new PicoTestOutputBuffer();
	}

	public function output(value:String):Void {
		this.buffer.output(value, function(line:String) Lib.trace(line));
	}

	public function close():Void {
		// do nothing
	}
}

#end

