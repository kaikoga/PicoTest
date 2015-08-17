package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;

class PhpSpawner extends TestSpawner {

	public function new():Void {
		super('php');
	}

	override public function execute():Void {
		CommandHelper.command('php', ['${bin()}/index.php'], reportFile());
	}
}

#end
