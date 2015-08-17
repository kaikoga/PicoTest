package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class JsNodeSpawner extends TestSpawner {

	public function new():Void {
		super('js_node');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('node', [bin()], reportFile()).execute();
	}
}

#end
