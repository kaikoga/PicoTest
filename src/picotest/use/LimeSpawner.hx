package picotest.use;

import haxe.macro.Context;
import picotest.macros.PicoTestMacros;

#if (macro || macro_doc_gen)

class LimeSpawner extends TestSpawner {

	private var limeTarget:String;
	public function new(limeTarget:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
	}

	override public function execute(reportFile:String):Void {
		this.command('lime', ['run', this.limeTarget], reportFile);

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

	public static function toSpawn(limeTarget:String):LimeSpawner {
		var spawner:LimeSpawner = new LimeSpawner(limeTarget); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
