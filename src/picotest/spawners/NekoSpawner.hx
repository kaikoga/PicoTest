package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class NekoSpawner extends TestSpawner {

	public function new():Void {
		super('neko');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('neko', [bin()], reportFile()).execute();
	}
}

#end
