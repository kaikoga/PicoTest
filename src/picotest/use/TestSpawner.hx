package picotest.use;

import haxe.io.Bytes;
import sys.io.File;
import sys.io.Process;

#if (macro || macro_doc_gen)

class TestSpawner {

	public var name(default, null):String;

	private function new(name:String):Void {
		this.name = name;
	}

	public function execute(reportFile:String):Void {

	}

	private function systemName():String {
		return Sys.systemName();
	}

	private function command(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		if (args == null) args = [];
		var process:Process;
		if (systemName() == "Windows") {
			// assume Windows is great
			process = new Process(cmd, args);
		} else {
			process = new Process("sh", []);
			process.stdin.writeString('$cmd ${args.join(" ")}');
			process.stdin.close();
		}
		var err:Int = process.exitCode();
		var stdout:Bytes = try { process.stdout.readAll(); } catch (d:Dynamic) { err = -1; null; }
		if (err != 0) {
			throw 'Command $cmd ${args.join(" ")} returned $err: ${stdout}';
		}
		if (outFile != null) {
			var out = File.write(outFile);
			out.write(stdout);
			out.close();
		}
	}
}

#end
