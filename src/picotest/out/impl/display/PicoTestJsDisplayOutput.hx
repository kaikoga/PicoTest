package picotest.out.impl.display;

//#if js

import js.html.Text;
import js.html.DivElement;
import js.html.Window;
import js.html.HTMLDocument;
import js.Browser;

class PicoTestJsDisplayOutput implements IPicoTestOutput {

	private var parent:IPicoTestOutput;
	private var document:HTMLDocument = null;
	private var window:Window = null;
	private var main:DivElement = null;
	private var log:DivElement = null;
	private var logline:DivElement = null;

	public function new(parent:IPicoTestOutput) {
		this.parent = parent;

		try {
			this.window = Browser.window;
			this.document = Browser.document;
			this.document.write('
<html>
<head><title>PicoTest result</title></head>
<style>
html, body { margin:0; padding:0; height:100%; }
.green { background: #0f0; }
.red { background: #f00; }
.container {
	height:100%;
	display: flex;
	flex-direction: column;
}
.header {
	flex:none;
}
.main {
	flex:1;
	overflow-y:scroll;
}
.log {
	overflow-wrap:break-word;
	word-wrap:break-word;
	white-space:pre-wrap;
}
</style>
<body>
<div class="container">
	<div class="header">
		<div>
			PicoTest result
		</div>
	</div>
	<div id="main" class="main">
		<div id="log" class="log">
		</div>
		<div id="logline" class="log">
		</div>
	</div>
</div>
</body>
</html>
');
			this.main = cast this.document.getElementById("main");
			this.log = cast this.document.getElementById("log");
			this.logline = cast this.document.getElementById("logline");
		} catch (e:Dynamic) {
			// do nothing
		}
	}

	public function output(value:String):Void {
		this.parent.output(value);
		if (this.main != null) {
			this.main.scrollTop = this.main.scrollHeight;
			value = this.logline.textContent + value;
			var a:Array<Dynamic> = value.split("\n");
			while (a.length > 1) {
				var fullLine:DivElement = this.document.createDivElement();
				fullLine.textContent = a.shift();
				this.log.appendChild(fullLine);
			}
			this.logline.textContent = a.shift();
		}
	}

	public function close():Void this.parent.close();
}

//#end
