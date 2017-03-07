package picotest.thread.threadImpl;

@:noDoc
class PicoTestThreadUnavailable {

	public var context(default, null):PicoTestThreadContext;

	private function new () {

	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThreadUnavailable {
		throw "PicoTestThread not implemented in this platform";
	}

	public function kill():Void {
		throw "PicoTestThread not implemented in this platform";
	}

	@:allow(picotest.PicoTestRunner)
	private var isHalted(get, never):Bool;
	private function get_isHalted():Bool return false;

	public static var available(get, never):Bool;
	private static function get_available():Bool return false;
}
