package picotest.use;

import haxe.macro.Compiler;
import picotest.macros.PicoTestMacros;

#if (macro || macro_doc_gen)

class LimeJsBrowserSpawner extends TestSpawner {

	private var limeTarget:String;
	private var browser:String;

	public function new(limeTarget:String, browser:String) {
		super('${limeTarget}_lime');
		this.limeTarget = limeTarget;
		this.browser = browser;
	}

	override public function execute(reportFile:String):Void {
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
			reportFile: reportFile
		});

	}

	public static function toSpawn(limeTarget:String, browser:String):LimeJsBrowserSpawner {
		var spawner:LimeJsBrowserSpawner = new LimeJsBrowserSpawner(limeTarget, browser); 
		PicoTestMacros.spawner = spawner;
		Compiler.define(PicoTestMacros.PICOTEST_REPORT_REMOTE, "1");
		return spawner;
	}
}

#end
