package picotest.thread;

import picotest.thread.threadImpl.PicoTestCsThread;
import picotest.thread.threadImpl.PicoTestHaxeThread;
import picotest.thread.threadImpl.PicoTestJavaThread;
import picotest.thread.threadImpl.PicoTestPythonThread;
import picotest.thread.threadImpl.PicoTestThreadUnavailable;

#if doc_gen
extern class PicoTestThread {
	public var context(default, null):PicoTestThreadContext;

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread;

	public function kill():Void;

	@:allow(picotest.PicoTestRunner)
	private var isHalted(get, never):Bool;
	private function get_isHalted():Bool;

	public static var available(get, never):Bool;
}
#elseif (cpp || neko)
typedef PicoTestThread = PicoTestHaxeThread;
#elseif python
typedef PicoTestThread = PicoTestPythonThread;
#elseif java
typedef PicoTestThread = PicoTestJavaThread;
#elseif cs
typedef PicoTestThread = PicoTestCsThread;
#else
typedef PicoTestThread = PicoTestThreadUnavailable;
#end
