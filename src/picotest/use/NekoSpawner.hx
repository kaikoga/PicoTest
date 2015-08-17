package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;

class NekoSpawner extends TestSpawner {

	public function new():Void {
		super('neko');
	}

	override public function execute():Void {
		CommandHelper.command('neko', [bin()], reportFile());
	}
}

#end
