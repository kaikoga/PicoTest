package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class JavaSpawner extends TestSpawner {

	public function new():Void {
		super('java');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('java', ['-jar', './${bin()}/${mainClass()}-debug.jar'], reportFile()).execute();
	}
}

#end
