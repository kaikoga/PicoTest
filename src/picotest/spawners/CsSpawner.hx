package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.macros.PicoTestMacros;
import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.PicoTestExternalCommandHelper;
import picotest.spawners.common.TestSpawner;

class CsSpawner extends TestSpawner {

	public function new():Void {
		super('cs');
	}

	override public function execute():Void {
		var realBin:String = PicoTestExternalCommandHelper.globOne('${bin()}/bin/*-Debug.exe', mainClass());
		PicoTestMacros.println('Executable path: ${realBin}');
		new PicoTestExternalCommand(realBin, [], reportFile()).execute();
	}
}

#end
