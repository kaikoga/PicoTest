package picotest.use;

import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;

#if (macro || macro_doc_gen)

class FlashStandaloneSpawner extends TestSpawner {

	public function new() {
		super("flash_sa");
	}

	override public function execute(reportFile:String):Void {
		var bin:String = Compiler.getOutput();
		switch (systemName()) {
			case "Windows", "Linux":
				this.command(flashPlayer(), [bin]);
			case "Mac":
				this.command('open', ['-nWa', flashPlayer(), bin]);
			default:
				throw 'Flash warning in platform ${systemName()} not supported';
		}
		this.command('cp', [flashLog(), reportFile]);
	}

	public static function toSpawn():FlashStandaloneSpawner {
		var spawner:FlashStandaloneSpawner = new FlashStandaloneSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
