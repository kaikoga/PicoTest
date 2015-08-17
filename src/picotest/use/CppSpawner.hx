package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;
import picotest.use.common.PicoTestExternalCommandHelper;

class CppSpawner extends TestSpawner {

	public function new():Void {
		super('cpp_${PicoTestExternalCommand.systemName().toLowerCase()}');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('./${bin()}/${mainClass()}-debug', [], reportFile()).execute();
	}
}

#end
