package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;
import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;

class FlashStandaloneSpawner extends TestSpawner {

	public function new() {
		super("flash_sa");
	}

	override public function execute():Void {
		PicoTestExternalCommand.open(flashPlayer(), bin(), true).execute();
		new PicoTestExternalCommand('cp', [flashLog(), reportFile()]).execute();
	}

	public static function toSpawn():FlashStandaloneSpawner {
		var spawner:FlashStandaloneSpawner = new FlashStandaloneSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
