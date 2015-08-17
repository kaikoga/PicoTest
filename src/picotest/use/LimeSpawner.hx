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
		CommandHelper.command('lime', ['run', this.limeTarget], reportFile);
	}

	public static function toSpawn(limeTarget:String):LimeSpawner {
		var spawner:LimeSpawner = new LimeSpawner(limeTarget); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
