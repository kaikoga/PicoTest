package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.TestSpawner;
import picotest.use.common.CommandHelper;

class CppSpawner extends TestSpawner {

	public function new():Void {
		super('cpp_${CommandHelper.systemName().toLowerCase()}');
	}

	override public function execute():Void {
		CommandHelper.command('./${bin()}/${mainClass()}-debug', [], reportFile());
	}
}

#end
