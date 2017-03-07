package picotest.thread.threadImpl;

#if cs

@:noDoc typedef CsThread = cs.system.threading.Thread;
@:noDoc typedef CsThreadStart = cs.system.threading.ThreadStart;

@:noDoc
class PicoTestCsThread {

	private var native:CsThread;
	private var context:PicoTestThreadContext;

	private function new(native:CsThread) {
		this.native = native;
		this.context = new PicoTestThreadContext();
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestCsThread {
		var thread:PicoTestCsThread = new PicoTestCsThread(null);
		var f:Void->Void = function():Void {
			callb(thread.context);
			thread.context.halted();
		}
		var native = new CsThread(new CsThreadStart(f));
		thread.native = native;
		native.Start();
		return thread;
	}

	public function kill():Void {
		this.context.haltRequested();
	}

	@:allow(picotest.PicoTestRunner)
	private var isHalted(get, never):Bool;
	private function get_isHalted():Bool return this.context.isHalted;

	public static var available(get, never):Bool;
	private static function get_available():Bool return true;
}

#end
