package picotest.thread;

typedef Thread = java.lang.Thread;

class PicoTestJavaThread extends Thread {

	private var func:PicoTestThreadContext->Void;
	private var context:PicoTestThreadContext;

	private function new(func:PicoTestThreadContext->Void) {
		super();
		this.context = new PicoTestThreadContext();
		this.func = func;
		this.start();
	}

	@:overload
	override public function run():Void {
		this.func(this.context);
		this.context.halted();
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		return new PicoTestJavaThread(callb);
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
