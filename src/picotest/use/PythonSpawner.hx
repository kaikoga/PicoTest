package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class PythonSpawner extends TestSpawner {

	public function new():Void {
		super('python');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('python', [bin()], reportFile()).execute();
	}
}

#end
