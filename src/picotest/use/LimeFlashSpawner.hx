package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;
import picotest.macros.PicoTestMacros;

class LimeFlashSpawner extends TestSpawner {

	public function new() {
		super('flash_lime');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('lime', ['run', 'flash']).execute();
		new PicoTestExternalCommand('cp', [flashLog(), reportFile()]).execute();
	}

	public static function toSpawn():LimeFlashSpawner {
		var spawner:LimeFlashSpawner = new LimeFlashSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
