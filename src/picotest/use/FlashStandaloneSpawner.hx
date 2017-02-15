package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class FlashStandaloneSpawner extends TestSpawner {

	public function new() {
		super("flash_sa");
	}

	override public function execute():Void {
		PicoTestExternalCommand.open(flashPlayer(), bin(), true).execute();
		new PicoTestExternalCommand('cp', [flashLog(), reportFile()]).execute();
	}
}

#end
