package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;

class JsNodeSpawner extends TestSpawner {

	public function new():Void {
		super('js_node');
	}

	override public function execute():Void {
		CommandHelper.command('node', [bin()], reportFile());
	}
}

#end
