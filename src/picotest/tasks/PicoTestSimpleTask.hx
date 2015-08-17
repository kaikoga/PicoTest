package picotest.tasks;

class PicoTestSimpleTask implements IPicoTestTask {

	private var func:Void->Void;

	public var className(default, null):String;
	public var methodName(default, null):String;

	public function new(className:String, methodName:String, func:Void->Void) {
		this.className = className;
		this.methodName = methodName;
		this.func = func;
	}

	public function resume():Bool {
		this.func();
		return true;
	}
}
