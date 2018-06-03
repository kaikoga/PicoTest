package picotest.out.impl.display;

#if js

import picotest.result.PicoTestResultMark;
import js.html.DivElement;
import js.html.Window;
import js.html.HTMLDocument;
import js.Browser;

class PicoTestJsDisplayOutput implements IPicoTestOutput {

	private var parent:IPicoTestOutput;
	private var document:HTMLDocument = null;
	private var window:Window = null;
	private var header:DivElement = null;
	private var status:DivElement = null;
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
.gray { background: #ccc; color: #999; }
.green { background: #3c3; color: #303; }
.yellow { background: #cc3; color: #003; }
.red { background: #c33; color: #fff; }
.darkred { background: #903; color: #300; }
.container {
	height:100%;
	display: flex;
	flex-direction: column;
}
.header {
	flex:none;
}
.status {
	font-size: 10px;
	margin-bottom:1em;
}
.main {
	flex:1;
	overflow-y:scroll;
}
.log {
	font-family: sans;
	font-size: 12px;
	overflow-wrap:break-word;
	word-wrap:break-word;
	white-space:pre-wrap;
}
</style>
<body>
<div class="container">
	<div id="header" class="header">
		<h1>PicoTest result</h1>
		<div id="status" class="status"></div>
	</div>
	<div id="main" class="main">
		<div id="log" class="log"></div>
		<div id="logline" class="log"></div>
	</div>
</div>
</body>
</html>
');
			this.header = cast this.document.getElementById("header");
			this.status = cast this.document.getElementById("status");
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

	public function progress(rate:Float, completed:Int, total:Int):Void {
		this.status.textContent = '${untyped (rate * 100).toFixed(2)}% ($completed/$total)';
		this.parent.progress(rate, completed, total);
		return;
	}

	public function complete(status:PicoTestResultMark):Void {
		switch (status) {
			case PicoTestResultMark.Error | PicoTestResultMark.Invalid:
				this.header.classList.add("darkred");
			case PicoTestResultMark.Failure:
				this.header.classList.add("red");
			case PicoTestResultMark.Skip | PicoTestResultMark.Ignore:
				this.header.classList.add("yellow");
			case PicoTestResultMark.Success:
				this.header.classList.add("green");
			case _:
				this.header.classList.add("gray");
		}
		this.parent.complete(status);
		return;
	}

	public function close():Void this.parent.close();
}

#end
