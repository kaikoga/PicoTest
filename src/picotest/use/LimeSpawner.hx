package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;
import haxe.macro.Context;
import picotest.macros.PicoTestMacros;

class LimeSpawner extends TestSpawner {

	private var limeTarget:String;
	public function new(limeTarget:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
	}

	override public function execute():Void {
		CommandHelper.command('lime', ['run', this.limeTarget], reportFile());
	}

	public static function toSpawn(limeTarget:String):LimeSpawner {
		var spawner:LimeSpawner = new LimeSpawner(limeTarget); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
