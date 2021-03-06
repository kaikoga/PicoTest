package picotest.out;

#if (sys || macro)

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Output;
import haxe.io.Bytes;

class PicoTestFileOutput extends PicoTestTextOutputBase implements IPicoTestOutput {

	private var _out:Output;

	public function new(path:String) {
		super();
		FileSystem.createDirectory(new Path(path).dir);
		_out = File.write(path, false);
	}

	public function output(value:String):Void {
		_out.write(Bytes.ofString(value));
		_out.flush();
	}

	public function close():Void {
		_out.close();
	}
}

#end
