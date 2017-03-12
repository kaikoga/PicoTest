package picotest.out.impl;

#if macro

import picotest.macros.PicoTestMacros;

class PicoTestMacroOutput implements IPicoTestOutput {

	private var buffer:PicoTestOutputBuffer;

	public function new() {
		this.buffer = new PicoTestOutputBuffer();
	}

	public function output(value:String):Void {
		this.buffer.output(value, function(line:String) PicoTestMacros.println(line));
	}

	public function close():Void {
		// do nothing
	}
}

#end
