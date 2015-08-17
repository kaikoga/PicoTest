package picotest.use;

import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;
import haxe.macro.Context;

#if (macro || macro_doc_gen)

class FlashStandaloneSpawner extends TestSpawner {

	public function new() {
		super("flash_sa");
	}

	override public function execute(reportFile:String):Void {
		var fp:String = null;
		var flog:String = null;
		if (Context.defined(PicoTestMacros.PICOTEST_FP)) fp = Context.definedValue(PicoTestMacros.PICOTEST_FP);
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) flog = Context.definedValue(PicoTestMacros.PICOTEST_FLOG);
		var bin:String = Compiler.getOutput();

		switch (systemName()) {
			case "Windows":
				if (fp == null) fp = '"C:/Program Files (x86)/FlashPlayerDebugger.exe"';
				if (flog == null) flog = '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
				this.command(fp, [bin]);
			case "Linux":
				if (fp == null) fp = 'flashplayer';
				if (flog == null) flog = '~/Macromedia/Flash_Player/Logs/flashlog.txt';
				this.command(fp, [bin]);
			case "Mac":
				if (fp == null) fp = '"Flash Player Debugger"';
				if (flog == null) flog = '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
				this.command('open', ['-nWa', fp, bin]);
			default:
				throw 'Flash warning in platform ${systemName()} not supported';
		}
		flog = flog.split("~").join(Sys.getEnv("HOME"));
		this.command('cp', [flog, reportFile]);
	}

	public static function toSpawn():FlashStandaloneSpawner {
		var spawner:FlashStandaloneSpawner = new FlashStandaloneSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
