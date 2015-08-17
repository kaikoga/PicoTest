package picotest.use;

import haxe.macro.Context;
import picotest.macros.PicoTestMacros;

#if (macro || macro_doc_gen)

class LimeFlashSpawner extends TestSpawner {

	public function new() {
		super('flash_lime');
	}

	override public function execute(reportFile:String):Void {
		this.command('lime', ['run', 'flash']);

		var flog:String = null;
		if (Context.defined(PicoTestMacros.PICOTEST_FLOG)) flog = Context.definedValue(PicoTestMacros.PICOTEST_FLOG);
		switch (systemName()) {
			case "Windows":
				if (flog == null) flog = '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt';
			case "Linux":
				if (flog == null) flog = '~/Macromedia/Flash_Player/Logs/flashlog.txt';
			case "Mac":
				if (flog == null) flog = '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
			default:
				throw 'Flash warning in platform ${systemName()} not supported';
		}
		this.command('cp', [flog, reportFile]);
	}

	public static function toSpawn():LimeFlashSpawner {
		var spawner:LimeFlashSpawner = new LimeFlashSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
