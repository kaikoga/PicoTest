package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;
import picotest.spawners.common.PicoTestExternalCommandHelper;

class CppSpawner extends TestSpawner {

	public function new():Void {
		super('cpp_${PicoTestExternalCommand.systemName().toLowerCase()}');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('./${bin()}/${mainClass()}-debug', [], reportFile()).execute();
	}
}

#end
