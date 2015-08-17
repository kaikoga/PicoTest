package picotest.thread;

#if python

@:noDoc typedef PythonThread = python.lib.threading.Thread;

@:noDoc
abstract PicoTestPythonThread(PythonThread) {

	private function new(native:PythonThread) {
		this = native;
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestPythonThread {
		return new PicoTestPythonThread(Type.createInstance(PythonThread, [null, callb]));
	}

	public function kill():Void {
		throw "PicoTestThread not implemented in this platform";
	}

	@:allow(picotest.PicoTestRunner)
	private var isHalted(get, never):Bool;
	private function get_isHalted():Bool return false;

	public static var available(get, never):Bool;
	private static function get_available():Bool return true;
}

#end
