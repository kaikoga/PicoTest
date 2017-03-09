package picotest.thread;

import picotest.thread.impl.IPicoTestThreadImpl;
import picotest.thread.impl.PicoTestCsThread;
import picotest.thread.impl.PicoTestHaxeThread;
import picotest.thread.impl.PicoTestJavaThread;
import picotest.thread.impl.PicoTestPythonThread;

class PicoTestThread implements IPicoTestThreadImpl {

	private var impl:IPicoTestThreadImpl;

	private function new(impl:IPicoTestThreadImpl) this.impl = impl;

	public function kill():Void this.impl.kill();
	public var isHalted(get, never):Bool;
	private function get_isHalted():Bool return this.impl.isHalted;

	public static var available(get, never):Bool;
	private static function get_available():Bool return selectImpl() != null;

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		var implFactory:(PicoTestThreadContext->Void)->IPicoTestThreadImpl = selectImpl();
		if (implFactory != null) return new PicoTestThread(implFactory(callb));
		throw "PicoTestThread not implemented in this platform";
	}

	private static function selectImpl():(PicoTestThreadContext->Void)->IPicoTestThreadImpl {
		#if (cpp || neko)
		return function(callb) return PicoTestHaxeThread.create(callb);
		#end

		#if python
		return function(callb) return PicoTestPythonThread.create(callb);
		#end

		#if java
		return function(callb) return PicoTestJavaThread.create(callb);
		#end

		#if cs
		return function(callb) return PicoTestCsThread.create(callb);
		#end

		return null;
	}
}
