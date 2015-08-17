package picotest.thread;

#if cpp
typedef Thread = cpp.vm.Thread;
#elseif neko
typedef Thread = neko.vm.Thread;
#end

class PicoTestHaxeThread {

	private var native:Thread;
	private var context:PicoTestThreadContext;

	private function new(native:Thread) {
		this.native = native;
		this.context = new PicoTestThreadContext();
	}

	public static function create(callb:PicoTestThreadContext->Void):PicoTestThread {
		var t:PicoTestHaxeThread = new PicoTestHaxeThread(null);
		var f:Void->Void = function():Void {
			callb(t.context);
		}
		t.native = Thread.create(f);
		return t;
	}

	public function kill():Void {
		this.context.complete = true;
	}

	public static var available(get, never):Bool;
	private static function get_available():Bool return true;
}
