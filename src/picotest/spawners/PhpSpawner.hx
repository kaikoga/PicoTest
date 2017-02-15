package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class PhpSpawner extends TestSpawner {

	public function new():Void {
		super('php');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('php', ['${bin()}/index.php'], reportFile()).execute();
	}
}

#end
