package picotest.use;

import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;
import haxe.macro.Context;

#if (macro || macro_doc_gen)

class TestSpawner {

	public var name(default, null):String;

	private function new(name:String):Void {
		this.name = name;
	}

	public function execute(reportFile:String):Void {

	}

	private function bin():String {
		return Compiler.getOutput();
	}

	private function mainClass():String {
		var args:Array<String> = Sys.args();
		var main:String = args[args.indexOf("-main") + 1];
		return main.split(".").pop();
	}

	private function flashPlayer():String {
		if (Context.defined(PicoTestMacros.PICOTEST_FP)) return Context.definedValue(PicoTestMacros.PICOTEST_FP);

		switch (CommandHelper.systemName()) {
			case "Windows":
				return '"C:/Program Files (x86)/FlashPlayerDebugger.exe"';
			case "Linux":
				return 'flashplayer';
			case "Mac":
				return '"Flash Player Debugger"';
			default:
				throw 'Flash warning in platform ${CommandHelper.systemName()} not supported';
		}
	}

	private function flashLog():String {
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) return Context.definedValue(PicoTestMacros.PICOTEST_FLOG);

		switch (CommandHelper.systemName()) {
			case "Windows":
				return '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
			case "Linux":
				return '~/Macromedia/Flash_Player/Logs/flashlog.txt';
			case "Mac":
				return '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
			default:
				throw 'Flash warning in platform ${CommandHelper.systemName()} not supported';
		}
	}

	private function remotePort():Int {
		if (Context.defined(PicoTestMacros.PICOTEST_REPORT_REMOTE_PORT)) return Std.parseInt(Context.definedValue(PicoTestMacros.PICOTEST_REPORT_REMOTE_PORT));
		return 8001;
	}

	private function runInAnotherNeko(out:String, main:String, anotherNekoArgs:Dynamic):Void {
		var args = ["-main", main, "-neko", out];

		// we also need path to picotest, so copy classpath
		var cp:Array<String> = Context.getClassPath();
		for (path in cp) {
			if (path.indexOf("/haxe/std/") >= 0) continue;
			if (path.indexOf("/haxe/extraLibs/") >= 0) continue;
			if (path == "") continue;
			args.push("-cp");
			args.push(path);
		}

		args.push("-D");
		args.push('${CommandHelper.PICOTEST_ANOTHER_NEKO_ARGS}=${CommandHelper.serializeBase64(anotherNekoArgs)}');
		
		Sys.command("haxe", args);
		Sys.command("neko", [out]);
	}
}

#end
