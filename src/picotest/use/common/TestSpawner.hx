package picotest.use.common;

#if (macro || macro_doc_gen)

import sys.FileSystem;
import sys.io.File;
import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;
import haxe.macro.Context;

class TestSpawner implements ITestExecuter {

	public var name(default, null):String;

	public var forceRemote(default, null):Bool;

	private function new(name:String):Void {
		this.name = name;
	}

	public function execute():Void {

	}

	public function reportDir():String {
		if (Context.defined(PicoTestMacros.PICOTEST_REPORT_DIR)) return Context.definedValue(PicoTestMacros.PICOTEST_REPORT_DIR);
		return "bin/report";
	}

	public function reportFile():String {
		FileSystem.createDirectory(reportDir());
		return '${reportDir()}/${name}.json';
	}

	public function reportData():String {
		var report:String = File.read(reportFile()).readAll().toString();
		if (report == null || report == "") throw '${reportFile()}: report file not found or empty';
		return report;
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

		switch (PicoTestExternalCommand.systemName()) {
			case "Windows":
				return '"C:/Program Files (x86)/FlashPlayerDebugger.exe"';
			case "Linux":
				return 'flashplayer';
			case "Mac":
				return '"Flash Player Debugger"';
			default:
				throw 'Flash warning in platform ${PicoTestExternalCommand.systemName()} not supported';
		}
	}

	private function flashLog():String {
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) return Context.definedValue(PicoTestMacros.PICOTEST_FLOG);

		switch (PicoTestExternalCommand.systemName()) {
			case "Windows":
				return '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
			case "Linux":
				return '~/Macromedia/Flash_Player/Logs/flashlog.txt';
			case "Mac":
				return '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
			default:
				throw 'Flash warning in platform ${PicoTestExternalCommand.systemName()} not supported';
		}
	}

	private function selectBrowser(kind:String = null):String {
		// TODO support more kind
		if (kind == null) kind = "";
		switch (kind.toLowerCase()) {
			case "firefox":
				switch (PicoTestExternalCommand.systemName()) {
					case "Windows":
						return 'firefox';
					case "Linux":
						return 'firefox';
					case "Mac":
						return 'Firefox';
					default:
						throw 'Running as browser in platform ${PicoTestExternalCommand.systemName()} not supported';
				}
			case "", "chrome":
				switch (PicoTestExternalCommand.systemName()) {
					case "Windows":
						return 'chrome';
					case "Linux":
						return 'chrome';
					case "Mac":
						return '"Google Chrome"';
					default:
						throw 'Running as browser in platform ${PicoTestExternalCommand.systemName()} not supported';
				}
			case _:
				return kind;
		}
	}

	private function browser():String {
		if (Context.defined(PicoTestMacros.PICOTEST_BROWSER)) return selectBrowser(Context.definedValue(PicoTestMacros.PICOTEST_BROWSER));
		return selectBrowser(null);
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
		args.push('${PicoTestExternalCommandHelper.PICOTEST_ANOTHER_NEKO_ARGS}=${PicoTestExternalCommandHelper.serializeBase64(anotherNekoArgs)}');

		Sys.command("haxe", args);
		Sys.command("neko", [out]);
	}
}

#end
