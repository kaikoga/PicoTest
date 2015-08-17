package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.TestSpawner;
import haxe.macro.Compiler;
import picotest.macros.PicoTestMacros;

class LimeJsBrowserSpawner extends TestSpawner {

	private var limeTarget:String;

	public function new(limeTarget:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
	}

	override public function execute():Void {
		// we have to run our tests through http so we runInAnotherNeko() instead of simple
		// CommandHelper.command('lime', ['run', this.limeTarget], reportFile);

		this.runInAnotherNeko('bin/report/bin/run_lime_html5.n', 'picotest.use.main.LimeJsBrowserSpawnerMain', {
			httpServerSetting: {
				port: remotePort(),
				files: [
					"/" => "Export/html5/bin/index.html",
					"/lib/soundjs.min.js" => "Export/html5/bin/lib/soundjs.min.js",
					"/OpenflTest.js" => "Export/html5/bin/OpenflTest.js"
				],
				docRoot: "Export/html5/bin"
			},
			reportFile: reportFile()
		});

	}

	public static function toSpawn(limeTarget:String):LimeJsBrowserSpawner {
		var spawner:LimeJsBrowserSpawner = new LimeJsBrowserSpawner(limeTarget); 
		PicoTestMacros.spawner = spawner;
		Compiler.define(PicoTestMacros.PICOTEST_REPORT_REMOTE, "1");
		return spawner;
	}
}

#end
