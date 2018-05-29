package picotest.out.impl;

#if macro

import picotest.macros.PicoTestMacros;
import picotest.out.buffer.PicoTestOutputLineBuffer;

class PicoTestMacroOutput implements IPicoTestOutput {

	private var buffer:PicoTestOutputLineBuffer;

	private function println(line:String):Void PicoTestMacros.println(line);

	public function new() this.buffer = new PicoTestOutputLineBuffer(println);

	public function output(value:String):Void {
		this.buffer.output(value);
		this.buffer.emit();
	}

	public function close():Void {
		this.buffer.close();
	}
}

#end
