package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class CsMonoSpawner extends TestSpawner {

	public function new():Void {
		super('cs_mono');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('mono', ['./${bin()}/bin/${mainClass()}-Debug.exe'], reportFile()).execute();
	}
}

#end
