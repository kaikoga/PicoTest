package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class LimeFlashSpawner extends TestSpawner {

	public function new() {
		super('flash_lime');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('lime', ['run', 'flash']).execute();
		new PicoTestExternalCommand('cp', [flashLog(), reportFile()]).execute();
	}
}

#end
