package picotest.thread;

typedef Thread = cs.system.threading.Thread;
typedef ThreadStart = cs.system.threading.ThreadStart;

class PicoTestCsThread {

	private var native:Thread;
	private var context:PicoTestThreadContext;

	private function new(native:Thread) {
		this.native = native;
		this.context = new PicoTestThreadContext();
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		var thread:PicoTestThread = new PicoTestCsThread(null);
		var f:Void->Void = function():Void {
			callb(thread.context);
		}
		var native = new Thread(new ThreadStart(f));
		thread.native = native;
		native.Start();
		return thread;
	}

	public function kill():Void {
		this.context.complete = true;
	}

	public static var available(get, never):Bool;
	private static function get_available():Bool return true;
}
