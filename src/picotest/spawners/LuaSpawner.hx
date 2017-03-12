package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class LuaSpawner extends TestSpawner {

	public function new():Void {
		super('lua');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('lua', [bin()], reportFile()).execute();
	}
}

#end
