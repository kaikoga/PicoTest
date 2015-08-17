package picotest.macros.runners;

import sys.io.File;
import sys.io.Process;

#if (macro || macro_doc_gen)

class TestExecuter {
	
	private function new():Void {
		
	}

	public function execute(reportFile:String):Void {
		
	}

	private function command(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		if (args == null) args = [];
		var process:Process = new Process(cmd, args);
		var err:Int = process.exitCode();
		if (err != 0) {
			throw '$cmd ${args.join(" ")}:$err: ${process.stdout.readAll()}';
		}
		if (outFile != null) {
			var out = File.write(outFile);
			out.write(process.stdout.readAll());
			out.close();
		}
	}
}

#end
