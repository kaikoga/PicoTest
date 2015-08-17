package picotest.use;

import haxe.macro.Context;
import picotest.macros.PicoTestMacros;

#if (macro || macro_doc_gen)

class LimeFlashSpawner extends TestSpawner {

	public function new() {
		super('flash_lime');
	}

	override public function execute(reportFile:String):Void {
		CommandHelper.command('lime', ['run', 'flash']);
		CommandHelper.command('cp', [flashLog(), reportFile]);
	}

	public static function toSpawn():LimeFlashSpawner {
		var spawner:LimeFlashSpawner = new LimeFlashSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
