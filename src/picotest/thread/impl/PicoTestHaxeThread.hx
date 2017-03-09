package picotest.thread.impl;

#if (cpp || neko)

@:noDoc typedef Thread = #if cpp cpp.vm.Thread; #elseif neko neko.vm.Thread; #end

@:noDoc
class PicoTestHaxeThread implements IPicoTestThreadImpl {

	private var native:Thread;
	private var context:PicoTestThreadContext;

	private function new(native:Thread) {
		this.native = native;
		this.context = new PicoTestThreadContext();
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestHaxeThread {
		var thread:PicoTestHaxeThread = new PicoTestHaxeThread(null);
		var f:Void->Void = function():Void {
			callb(thread.context);
			thread.context.halted();
		}
		thread.native = Thread.create(f);
		return thread;
	}

	public function kill():Void {
		this.context.haltRequested();
	}

	public var isHalted(get, never):Bool;
	private function get_isHalted():Bool return this.context.isHalted;
}

#end
