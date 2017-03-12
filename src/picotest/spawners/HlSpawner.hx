package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class HlSpawner extends TestSpawner {

	public function new():Void {
		super('hl');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('hl', [bin()], reportFile()).execute();
	}
}

#end
