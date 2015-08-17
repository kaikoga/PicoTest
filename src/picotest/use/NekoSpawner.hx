package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class NekoSpawner extends TestSpawner {

	public function new():Void {
		super('neko');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('neko', [bin()], reportFile()).execute();
	}
}

#end
