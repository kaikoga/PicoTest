package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;
import haxe.macro.Context;
import picotest.macros.PicoTestMacros;

class LimeFlashSpawner extends TestSpawner {

	public function new() {
		super('flash_lime');
	}

	override public function execute():Void {
		CommandHelper.command('lime', ['run', 'flash']);
		CommandHelper.command('cp', [flashLog(), reportFile()]);
	}

	public static function toSpawn():LimeFlashSpawner {
		var spawner:LimeFlashSpawner = new LimeFlashSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
