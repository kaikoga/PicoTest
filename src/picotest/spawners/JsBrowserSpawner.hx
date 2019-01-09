package picotest.spawners;

#if (macro || macro_doc_gen)

import picotest.spawners.common.PicoTestExternalCommandHelper;
import picotest.spawners.common.TestSpawner;
import haxe.io.Bytes;

class JsBrowserSpawner extends TestSpawner {

	public function new():Void {
		super('js_html');
		this.forceRemote = true;
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
</head>
<body>
<script src="/test.js"></script>
</body>
</html>
';
		return Bytes.ofString(html);
	}

	override public function execute():Void {
		PicoTestExternalCommandHelper.writeFile(htmlData(), htmlFile());
		this.runInAnotherNeko('bin/report/bin/run_js_html.n', 'picotest.spawners.common.JsBrowserLauncher', {
			browser: browser(),
			httpServerSetting: {
				port: remotePort(),
				files: ["/" => htmlFile(), "/test.js" => bin()]
			},
			reportFile: reportFile()
		});
	}
}

#end

