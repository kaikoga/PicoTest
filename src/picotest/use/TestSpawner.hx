package picotest.use;

import picotest.macros.PicoTestMacros;
import haxe.macro.Context;
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

	private function flashPlayer():String {
		if (Context.defined(PicoTestMacros.PICOTEST_FP)) return Context.definedValue(PicoTestMacros.PICOTEST_FP);

		switch (systemName()) {
			case "Windows":
				return '"C:/Program Files (x86)/FlashPlayerDebugger.exe"';
			case "Linux":
				return 'flashplayer';
			case "Mac":
				return '"Flash Player Debugger"';
			default:
				throw 'Flash warning in platform ${systemName()} not supported';
		}
	}

	private function flashLog():String {
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) return Context.definedValue(PicoTestMacros.PICOTEST_FLOG);

		switch (systemName()) {
			case "Windows":
				return '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
			case "Linux":
				return '~/Macromedia/Flash_Player/Logs/flashlog.txt';
			case "Mac":
				return '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
			default:
				throw 'Flash warning in platform ${systemName()} not supported';
		}

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
