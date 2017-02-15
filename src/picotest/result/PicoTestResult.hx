package picotest.result;

import picotest.tasks.IPicoTestTask;

/**
	Test method result of PicoTest.
**/
class PicoTestResult {

	public var className(default, null):String;
	public var methodName(default, null):String;
	public var parameters:Array<String>;
	public var assertResults(default, null):Array<PicoTestAssertResult>;
	private var tasks:Array<IPicoTestTask>;
	private var _setup:Void->Void;
	private var _tearDown:Void->Void;

	public function setupIfNeeded():Void {
		if (this._setup != null) this._setup();
		this._setup = null;
	}

	public function tearDownIfNeeded():Void {
		if (this._tearDown != null) this._tearDown();
		this._tearDown = null;
	}

	public function new(className:String, methodName:String, parameters:Array<Dynamic> = null, assertResults:Array<PicoTestAssertResult> = null, setup:Void->Void = null, tearDown:Void->Void = null) {
		this.className = className;
		this.methodName = methodName;
		this.parameters = if (parameters != null) parameters.map(function(d:Dynamic) return Std.string(d)); else null;
		this.assertResults = if (assertResults != null) assertResults; else [];
		this._setup = setup;
		this._tearDown = tearDown;
		this.tasks = [];
	}

	public function mark():PicoTestResultMark {
		var mark:PicoTestResultMark = PicoTestResultMark.Empty;
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Success:
					switch (mark) {
						case
						PicoTestResultMark.Empty:
							mark = PicoTestResultMark.Success;
						case _:
					}
				case PicoTestAssertResult.Failure(message,callInfo):
					switch (mark) {
						case
						PicoTestResultMark.Empty,
						PicoTestResultMark.Success:
							mark = PicoTestResultMark.Failure;
						case _:
					}
				case PicoTestAssertResult.Error(message,callInfo):
					switch (mark) {
						case
						PicoTestResultMark.Empty,
						PicoTestResultMark.Success,
						PicoTestResultMark.Failure:
							mark = PicoTestResultMark.Error;
						case _:
					}
				case PicoTestAssertResult.Trace(message,callInfo):
				case PicoTestAssertResult.Ignore(message,callInfo):
					mark = PicoTestResultMark.Ignore;
				case PicoTestAssertResult.Invalid(message,callInfo):
					mark = PicoTestResultMark.Invalid;
			}
		}
		return mark;
	}

	public function isError():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Error(_,_): return true;
				default:
			}
		}
		return false;
	}

	public function isIgnore():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Ignore(_,_): return true;
				default:
			}
		}
		return false;
	}

	public function isInvalid():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Ignore(_,_): return true;
				default:
			}
		}
		return false;
	}

	public function startTask(task:IPicoTestTask):Void {
		this.tasks.push(task);
	}

	public function completeTask(task:IPicoTestTask):Bool {
		this.tasks.remove(task);
		return this.tasks.length == 0;
	}

	public function printParameters():String {
		if (parameters == null || parameters.length == 0) {
			return '';
		}
		return '[${parameters.join(', ').split("\n").join("\\n")}]';
	}
}
