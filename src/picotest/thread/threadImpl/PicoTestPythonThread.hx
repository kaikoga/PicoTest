package picotest.thread.threadImpl;

#if python

@:noDoc typedef PythonThread = python.lib.threading.Thread;

@:noDoc
class PicoTestPythonThread implements IPicoTestThreadImpl {

	private var native:PythonThread;

	private function new(native:PythonThread) {
		this.native = native;
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestPythonThread {
		return new PicoTestPythonThread(Type.createInstance(PythonThread, [null, callb]));
	}

	public function kill():Void {
		throw "PicoTestThread not implemented in this platform";
	}

	public var isHalted(get, never):Bool;
	private function get_isHalted():Bool return false;
}

#end
