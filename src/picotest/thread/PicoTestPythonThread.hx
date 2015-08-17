package picotest.thread;

import picotest.thread.PicoTestPythonThread;
typedef Thread = python.lib.threading.Thread;

abstract PicoTestPythonThread(Thread) {

	private function new(native:Thread) {
		this = native;
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		return new PicoTestPythonThread(Type.createInstance(Thread, [null, callb]));
	}

	public function kill():Void {
		throw "PicoTestThread not implemented in this platform";
	}

	public static var available(get, never):Bool;
	private static function get_available():Bool return true;
}
