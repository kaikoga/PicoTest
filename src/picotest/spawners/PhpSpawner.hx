package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.TestSpawner;

class PhpSpawner extends TestSpawner {

	private var php7:Bool;

	public function new(php7:Bool = false):Void {
		super(php7 ? 'php7' : 'php');
	}

	override public function execute():Void {
		new PicoTestExternalCommand('php', ['${bin()}/index.php'], reportFile()).execute();
	}
}

#end
