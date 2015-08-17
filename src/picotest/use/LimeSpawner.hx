package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;
import picotest.macros.PicoTestMacros;

class LimeSpawner extends TestSpawner {

	private var limeTarget:String;
	public function new(limeTarget:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
	}

	override public function execute():Void {
		new PicoTestExternalCommand('lime', ['run', this.limeTarget], reportFile()).execute();
	}

	public static function toSpawn(limeTarget:String):LimeSpawner {
		var spawner:LimeSpawner = new LimeSpawner(limeTarget); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
