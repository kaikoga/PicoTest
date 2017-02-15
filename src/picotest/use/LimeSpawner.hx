package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.TestSpawner;

class LimeSpawner extends TestSpawner {

	private var limeTarget:String;
	public function new(limeTarget:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
	}

	override public function execute():Void {
		new PicoTestExternalCommand('lime', ['run', this.limeTarget], reportFile()).execute();
	}
}

#end
