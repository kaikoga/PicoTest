package picotest.out;

class PicoTestJsOutput implements IPicoTestOutput {

	private static var _currentLine:String = "";

	public function new() {
	}

	public function stdout(value:String):Void {
		try {
			// try node
			untyped process.stdout.write(value);
		} catch (e:Dynamic) {
			// fallback to haxe std trace
			untyped js.Boot.__trace(cast line, null);
		}

	}

	public function close():Void {
		// do nothing
	}
}
