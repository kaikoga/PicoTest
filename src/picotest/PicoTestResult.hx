package picotest;

import picotest.tasks.IPicoTestTask;
import picotest.PicoTestAssertResult;

/**
	Test method result of PicoTest.
**/
class PicoTestResult {

	public var className(default, null):String;
	public var methodName(default, null):String;
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

	public function new(className:String, methodName:String, assertResults:Array<PicoTestAssertResult> = null, setup:Void->Void = null, tearDown:Void->Void = null) {
		this.className = className;
		this.methodName = methodName;
		this.assertResults = if (assertResults != null) assertResults; else [];
		this._setup = setup;
		this._tearDown = tearDown;
		this.tasks = [];
	}

	public function isFail():Bool {
		for (assertResult in assertResults) {
			switch (assertResult) {
				case PicoTestAssertResult.Failure(_,_): return true;
				default:
			}
		}
		return false;
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

	public function startTask(task:IPicoTestTask):Void {
		this.tasks.push(task);
	}

	public function completeTask(task:IPicoTestTask):Bool {
		this.tasks.remove(task);
		return this.tasks.length == 0;
	}
}
