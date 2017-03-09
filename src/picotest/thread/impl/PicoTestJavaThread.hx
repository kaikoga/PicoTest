package picotest.thread.impl;

#if java

@:noDoc typedef JavaThread = java.lang.Thread;

@:noDoc
class PicoTestJavaThread extends JavaThread implements IPicoTestThreadImpl {

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

	public static function create(callb:PicoTestThreadContext->Void):PicoTestJavaThread {
		return new PicoTestJavaThread(callb);
	}

	public function kill():Void {
		this.context.haltRequested();
	}

	public var isHalted(get, never):Bool;
	private function get_isHalted():Bool return this.context.isHalted;
}

#end
