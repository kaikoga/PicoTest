package picotest;

import haxe.ds.Option;
import picotest.thread.PicoTestThreadContext;
import haxe.Timer;
import picotest.tasks.PicoTestTaskStatus;
import haxe.PosInfos;
import haxe.CallStack;
import picotest.printers.IPicoTestPrinter;
import picotest.readers.PicoTestReader;
import picotest.readers.IPicoTestReader;
import picotest.reporters.IPicoTestReporter;
import picotest.tasks.IPicoTestTask;
import picotest.thread.PicoTestThread;

#if flash
import flash.system.System;
import flash.errors.Error;
#end

/**
	PicoTest runner.
**/
class PicoTestRunner {

	public var readers:Array<IPicoTestReader>;
	public var printers:Array<IPicoTestPrinter>;
	public var reporters:Array<IPicoTestReporter>;

	private var tasks:Array<IPicoTestTask>;
	private var waitingTasks:Array<IPicoTestTask>;
	private var results:Array<PicoTestResult>;
	private var completed:Bool = false;

	private var currentTask:IPicoTestTask;
	@:noDoc
	public var currentTaskResult(get, never):PicoTestResult;
	private function get_currentTaskResult():PicoTestResult {
		return switch (this.currentTask.result) {
			case Option.Some(result): result;
			case Option.None: throw "PicoTestRunner not running";
		}
	}

	private var mainLoopThreads:Array<PicoTestThread>;

	public function new() {
		this.readers = [new PicoTestReader()];
		this.printers = [];
		this.reporters = [];
		this.tasks = [];
		this.waitingTasks = [];
		this.results = [];
		this.mainLoopThreads = [];
	}

	@:noDoc
	public function add(task:IPicoTestTask):Void {
		task.start();
		this.tasks.push(task);
	}

	@:noDoc
	public function append(task:IPicoTestTask):Void {
		task.start();
		this.tasks.push(task);
	}

	@:noDoc
	public function prepend(task:IPicoTestTask):Void {
		task.start();
		this.tasks.unshift(task);
	}

	@:noDoc
	public function addResult(result:PicoTestResult):Void {
		this.results.push(result);
	}

	/**
		Load test methods from `testCaseClass`.
	**/
	public function load(testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Array<Dynamic>> = null):Void {
		for (reader in this.readers) reader.load(this, testCaseClass, defaultParameters);
	}

	/**
		Adds main loops which must be run aside PicoTest thread.
	**/
	public function addMainLoop(mainLoop:PicoTestThreadContext->Void):Void {
		if (!PicoTestThread.available) {
			throw "PicoTestRunner.addMainLoop() not supported in platform";
		}
		this.mainLoopThreads.push(PicoTestThread.create(mainLoop));
	}

	/**
		Launch tests, and `onComplete` will be called when all the tests are completed.
		Non-blocking on platforms with `haxe.Timer.delay()` (flash, js, java without `-D picotest-thread`).
	**/
	public function run(onComplete:Void->Void = null):Void {
		if (onComplete != null) this.onComplete = onComplete;
		#if js
		// TODO enable source map support
		#end
		#if (flash || js || (java && !picotest_thread))
		rerun();
		#else
		while (this.resume()) Sys.sleep(0.01);
		#end
	}

	#if (flash || js || (java && !picotest_thread))
	private function rerun():Void {
		if (this.resume()) Timer.delay(this.rerun, 10);
	}
	#end

	/**
		Executes some of the tests and returns `true` if there are uncomplete tasks, otherwise returns `false`.
	**/
	public function resume():Bool {
		if (this.completed) return false;

		if (this.tasks.length > 0) {
			this.runTask(this.tasks.shift());
		}
		if (this.tasks.length > 0) {
			return true;
		}
		if (this.waitingTasks.length > 0) {
			this.tasks = this.waitingTasks;
			this.waitingTasks = [];
			return true;
		}

		for (reporter in this.reporters) reporter.report(this.results);

		for (thread in this.mainLoopThreads) thread.kill();
		while (this.mainLoopThreads.length > 0) {
			this.mainLoopThreads = this.mainLoopThreads.filter(function(v:PicoTestThread):Bool { return !v.isHalted; } );
		}

		this.onComplete();
		this.completed = true;
		return false;
	}

	public dynamic function onComplete():Void {
		#if (flash && picotest_report)
		try { System.exit(0); } catch (d:Dynamic) {}
		#elseif (sys && !macro)
		Sys.exit(0);
		#end
	}

	private function runTask(task:IPicoTestTask):Void {
		PicoTest.currentRunner = this;
		this.currentTask = task;
		var oldTrace:Dynamic->?PosInfos->Void = haxe.Log.trace;
		haxe.Log.trace = function(v:Dynamic, ?p:PosInfos):Void { this.trace(v, p); };
		switch (this.currentTask.resume(this)) {
			case PicoTestTaskStatus.Continue:
				this.waitingTasks.push(task);
			case PicoTestTaskStatus.Complete(result):
				if (result.completeTask(task)) {
					result.tearDownIfNeeded();
					for (printer in this.printers) printer.print(result);
					this.results.push(result);
				}
			case PicoTestTaskStatus.Done:
		}
		haxe.Log.trace = oldTrace;
		this.currentTask = null;
		PicoTest.currentRunner = null;
	}

	@:noDoc
	public function success():Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Success;
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	@:noDoc
	public function failure(message:String = null, ?p:PosInfos):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Failure(message, PicoTestCallInfo.fromPosInfos(p));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	@:noDoc
	public function error(d:Dynamic):Void {
		var message:String = Std.string(d);
		// d is null on cs stack overflow
		var callStack:Array<StackItem> = if (d == null) [] else
			#if flash
			if (Std.is(d, Error)) {
				this.buildFlashCallStack(cast (d, Error).getStackTrace());
			} else {
				CallStack.exceptionStack();
			}
			#else
			CallStack.exceptionStack();
			#end
		var LIMIT_CALLSTACK:Int = 16; // must limit, maybe macro will stack overflow on parsing jsonized java call stack info (which is HUGE)
		if (callStack.length > LIMIT_CALLSTACK * 2) {
			callStack = callStack.slice(0, LIMIT_CALLSTACK).concat(callStack.slice(callStack.length - LIMIT_CALLSTACK));
			callStack.insert(LIMIT_CALLSTACK, StackItem.Module("<stack info truncated>"));
		}
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Error(message, PicoTestCallInfo.fromCallStack(callStack));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	@:noDoc
	public function trace(v:Dynamic = null, ?p:PosInfos):Void {
		var message:String = Std.string(v);
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Trace(message, PicoTestCallInfo.fromPosInfos(p));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	@:noDoc
	public function ignore(message:String, className:String, methodName:String):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Ignore(message, PicoTestCallInfo.fromReflect(className, methodName));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	@:noDoc
	public function invalid(message:String, className:String, methodName:String):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Invalid(message, PicoTestCallInfo.fromReflect(className, methodName));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(currentTaskResult, assertResult);
	}

	#if flash
	private function buildFlashCallStack(stackTrace:String):Array<StackItem> {
		var callStack:Array<StackItem> = [];
		var a:Array<String> = stackTrace.split("\n\tat ");
		a.shift();
		for (line in a) {
			var stackItem:StackItem;
			var ereg:EReg = ~/(.+)\(\)\[(.+)\]/;
			if (!ereg.match(line)) continue;
			var funcName:String = ereg.matched(1);
			var fileLine:String = ereg.matched(2);
			var methodReg:EReg = ~/(.+)\/(.+)/;
			if (methodReg.match(funcName)) {
				stackItem = StackItem.Method(methodReg.matched(1).split("::").join("/"), methodReg.matched(2));
			} else {
				stackItem = StackItem.Module(funcName.split("::").join("/"));
			}
			var fileReg:EReg = ~/(.+):([0-9]+)/;
			if (fileReg.match(fileLine)) {
				stackItem = StackItem.FilePos(stackItem, fileReg.matched(1), Std.parseInt(fileReg.matched(2)));
			}
			callStack.push(stackItem);
		}
		return callStack;
	}
	#end

}
