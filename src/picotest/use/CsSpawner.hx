package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class CsSpawner extends TestSpawner {

	public function new():Void {
		super('cs');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('./${bin()}/bin/${mainClass()}-Debug.exe', [], reportFile()).execute();
	}
}

#end
