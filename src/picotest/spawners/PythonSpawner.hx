package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class PythonSpawner extends TestSpawner {

	public function new():Void {
		super('python');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('python', [bin()], reportFile()).execute();
	}
}

#end
