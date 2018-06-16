package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.macros.PicoTestMacros;
import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.PicoTestExternalCommandHelper;
import picotest.spawners.common.TestSpawner;

class JavaSpawner extends TestSpawner {

	public function new():Void {
		super('java');
	}

	override public function execute():Void {
		var realBin:String = PicoTestExternalCommandHelper.globOne('${bin()}/*-debug.jar', mainClass());
		PicoTestMacros.println('Executable path: ${realBin}');
		new PicoTestExternalCommand('java', ['-jar', realBin], reportFile()).execute();
	}
}

#end
