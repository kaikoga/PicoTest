package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class CsSpawner extends TestSpawner {

	public function new():Void {
		super('cs');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('./${bin()}/bin/${mainClass()}-Debug.exe', [], reportFile()).execute();
	}
}

#end
