package picotest.macros.runners;

import haxe.macro.Compiler;
import haxe.macro.Context;

#if (macro || macro_doc_gen)

class FlashStandaloneExecuter extends TestExecuter {

	public function new() {
		super();
	}

	override public function execute(reportFile:String):Void {
		var fp:String = null;
		var flog:String = null;
		if (Context.defined(PicoTestMacros.PICOTEST_FP)) fp = Context.definedValue(PicoTestMacros.PICOTEST_FP);
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) flog = Context.definedValue(PicoTestMacros.PICOTEST_FLOG);
		var bin:String = Compiler.getOutput();

		var system:String = Sys.systemName();
		switch (system) {
			case "Windows":
				if (fp == null) fp = 'C:/Program Files (x86)/FlashPlayerDebugger.exe';
				if (flog == null) flog = '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
				this.command(fp, [bin]);
			case "Linux":
				if (fp == null) fp = 'flashplayer';
				if (flog == null) flog = '~/Macromedia/Flash_Player/Logs/flashlog.txt';
				// FIXME
				fp = fp.split('"').join('').split('\\ ').join(' ');
				flog = flog.split('"').join('').split('\\ ').join(' ');
				this.command(fp, [bin]);
			case "Mac":
				if (fp == null) fp = 'Flash Player Debugger';
				if (flog == null) flog = '~/Library/Preferences/Macromedia/Flash Player/Logs/flashlog.txt';
				// FIXME
				fp = fp.split('"').join('').split('\\ ').join(' ');
				flog = flog.split('"').join('').split('\\ ').join(' ');
				this.command('open', ['-nWa', fp, bin]);
			default:
				throw 'Flash warning in platform $system not supported';
		}
		flog = flog.split("~").join(Sys.getEnv("HOME"));
		this.command('cp', [flog, reportFile]);
	}
}

#end
