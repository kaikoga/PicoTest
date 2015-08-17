package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.CommandHelper;
import picotest.use.common.TestSpawner;
import picotest.macros.PicoTestMacros;
import haxe.macro.Compiler;

class FlashStandaloneSpawner extends TestSpawner {

	public function new() {
		super("flash_sa");
	}

	override public function execute():Void {
		var bin:String = Compiler.getOutput();
		switch (CommandHelper.systemName()) {
			case "Windows", "Linux":
				CommandHelper.command(flashPlayer(), [bin]);
			case "Mac":
				CommandHelper.command('open', ['-nWa', flashPlayer(), bin]);
			default:
				throw 'Flash warning in platform ${CommandHelper.systemName()} not supported';
		}
		CommandHelper.command('cp', [flashLog(), reportFile()]);
	}

	public static function toSpawn():FlashStandaloneSpawner {
		var spawner:FlashStandaloneSpawner = new FlashStandaloneSpawner(); 
		PicoTestMacros.spawner = spawner;
		return spawner;
	}
}

#end
