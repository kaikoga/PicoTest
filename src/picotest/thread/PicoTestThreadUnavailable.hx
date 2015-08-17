package picotest.thread;

class PicoTestThreadUnavailable {

	private function new () {

	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		throw "PicoTestThread not implemented in this platform";
	}

	public function kill():Void {
		throw "PicoTestThread not implemented in this platform";
	}

	public static var available(get, never):Bool;
	private static function get_available():Bool return false;
}
