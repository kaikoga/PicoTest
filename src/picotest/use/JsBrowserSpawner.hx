package picotest.use;

#if (macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommandHelper;
import picotest.use.common.TestSpawner;
import haxe.macro.Compiler;
import picotest.macros.PicoTestMacros;
import haxe.io.Bytes;

class JsBrowserSpawner extends TestSpawner {

	public function new():Void {
		super('js_html');
	}

	private function htmlFile():String {
		return "bin/report/run_js_html.html";
	}

	private function htmlData():Bytes {
		var path:Array<String> = bin().split("/");
		var html:String = '<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<script src="/test.js"></script>
</head>
<body></body>
</html>
';
		return Bytes.ofString(html);
	}

	override public function execute():Void {
		PicoTestExternalCommandHelper.writeFile(htmlData(), htmlFile());
		this.runInAnotherNeko('bin/report/bin/run_js_html.n', 'picotest.use.main.JsBrowserSpawnerMain', {
			httpServerSetting: {
				port: remotePort(),
				files: ["/" => htmlFile(), "/test.js" => bin()]
			},
			reportFile: reportFile()
		});
	}

	public static function toSpawn():JsBrowserSpawner {
		var spawner:JsBrowserSpawner = new JsBrowserSpawner();
		PicoTestMacros.spawner = spawner;
		Compiler.define(PicoTestMacros.PICOTEST_REPORT_REMOTE, "1");
		return spawner;
	}

}

#end

