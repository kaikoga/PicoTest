package picotest.out.impl;

#if sys

import haxe.io.Output;
import haxe.io.Bytes;

class PicoTestSysOutput extends PicoTestTextOutputBase implements IPicoTestOutput {

	private var _stdout:Output;

	public function new() {
		super();
		_stdout = Sys.stdout();
	}

	public function output(value:String):Void {
		_stdout.write(Bytes.ofString(value));
		_stdout.flush();
	}

	public function close():Void {
		_stdout.close();
	}
}

#end
