package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class JavaSpawner extends TestSpawner {

	public function new():Void {
		super('java');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('java', ['-jar', './${bin()}/${mainClass()}-debug.jar'], reportFile()).execute();
	}
}

#end
