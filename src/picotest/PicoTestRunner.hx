package picotest;

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

class PicoTestRunner {

	public var readers:Array<IPicoTestReader>;
	public var printers:Array<IPicoTestPrinter>;
	public var reporters:Array<IPicoTestReporter>;
	public var complete:Bool = false;

	private var tasks:Array<IPicoTestTask>;
	private var waitingTasks:Array<IPicoTestTask>;
	private var results:Array<PicoTestResult>;

	private var currentTask:IPicoTestTask;
	public var currentTaskResult(get, never):PicoTestResult;
	private function get_currentTaskResult():PicoTestResult {
		return switch (this.currentTask.result) {
			case Some(result): result;
			case None: throw "PicoTestRunner not running";
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

	public function add(task:IPicoTestTask):Void {
		this.tasks.push(task);
	}

	public function append(task:IPicoTestTask):Void {
		this.tasks.push(task);
	}

	public function prepend(task:IPicoTestTask):Void {
		this.tasks.unshift(task);
	}

	public function addResult(result:PicoTestResult):Void {
		this.results.push(result);
	}

	public function load(testCaseClass:Class<Dynamic>):Void {
		for (reader in this.readers) reader.load(this, testCaseClass);
	}

	public function addMainLoop(mainLoop:PicoTestThreadContext->Void):Void {
		if (!PicoTestThread.available) {
			throw "PicoTestRunner.addMainLoop() not supported in platform";
		}
		this.mainLoopThreads.push(PicoTestThread.create(mainLoop));
	}

	public function run():Void {
		#if js
		// TODO enable source map support
		#end
		this.resume();
	}

	private function resume():Void {
		while (true) {
			if (this.tasks.length > 0) {
				this.runTask(this.tasks.shift());
			}
			if (this.tasks.length == 0) {
				if (this.waitingTasks.length > 0) {
					this.tasks = this.waitingTasks;
					this.waitingTasks = [];
					#if (!sys)
					Timer.delay(this.resume, 10);
					return;
					#end
				} else {
					for (reporter in this.reporters) reporter.report(this.results);

					#if (flash && picotest_report)
					System.exit(0);
					#end
					for (thread in this.mainLoopThreads) {
						thread.kill();
					}
					return;
				}
			}
			#if sys
			Sys.sleep(0.01);
			#end
		}
	}

	private function runTask(task:IPicoTestTask):Void {
		PicoTest.currentRunner = this;
		this.currentTask = task;
		switch (this.currentTask.resume(this)) {
			case PicoTestTaskStatus.Continue:
				this.waitingTasks.push(task);
			case PicoTestTaskStatus.Complete(result):
				for (printer in this.printers) printer.print(result);
				this.results.push(result);
			case PicoTestTaskStatus.Done:
		}
		this.currentTask = null;
		PicoTest.currentRunner = null;
	}

	public function success(assertResult:PicoTestAssertResult = null):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Success;
		for (printer in this.printers) printer.printAssertResult(assertResult);
	}

	public function failure(message:String = null, p:PosInfos):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Failure(message, PicoTestCallInfo.fromPosInfos(p));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(assertResult);
	}

	public function error(d:Dynamic):Void {
		var message:String = Std.string(d);
		var callStack:Array<StackItem> =
		#if flash
		if (Std.is(d, Error)) {
			this.buildFlashCallStack(cast (d, Error).getStackTrace());
		} else {
			CallStack.exceptionStack();
		}
		#else
		CallStack.exceptionStack();
		#end
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Error(message, PicoTestCallInfo.fromCallStack(callStack));
		currentTaskResult.assertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(assertResult);
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
