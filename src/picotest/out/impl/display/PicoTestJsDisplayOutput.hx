package picotest.out.impl.display;

//#if js

import js.html.Window;
import js.html.HTMLDocument;
import js.Browser;

class PicoTestJsDisplayOutput implements IPicoTestOutput {

	private var parent:IPicoTestOutput;
	private var document:HTMLDocument = null;
	private var window:Window = null;


	public function new(parent:IPicoTestOutput) {
		this.parent = parent;

		try {
			this.document = Browser.document;
			this.window = Browser.window;
		} catch (e:Dynamic) {
			// do nothing
		}
	}

	public function output(value:String):Void {
		this.parent.output(value);
		if (this.document != null) this.document.write(StringTools.htmlEscape(value));
		if (this.window != null) this.window.scrollTo(0, Browser.window.scrollMaxY);
	}

	public function close():Void this.parent.close();
}

//#end
