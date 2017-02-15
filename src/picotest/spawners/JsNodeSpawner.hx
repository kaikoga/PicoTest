package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class JsNodeSpawner extends TestSpawner {

	public function new():Void {
		super('js_node');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('node', [bin()], reportFile()).execute();
	}
}

#end
