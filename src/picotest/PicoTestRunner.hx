package picotest;

import haxe.PosInfos;
import haxe.CallStack;
import picotest.printers.IPicoTestPrinter;
import picotest.readers.PicoTestReader;
import picotest.readers.IPicoTestReader;
import picotest.reporters.IPicoTestReporter;
import picotest.tasks.IPicoTestTask;

#if flash
import flash.system.System;
import flash.errors.Error;
#end

class PicoTestRunner {

	public var readers:Array<IPicoTestReader>;
	public var printers:Array<IPicoTestPrinter>;
	public var reporters:Array<IPicoTestReporter>;
	public var display:Bool = true;

	private var completedResults:Array<PicoTestResult>;
	private var incompleteResults:Array<PicoTestResult>;
	private var currentAssertResults:Array<PicoTestAssertResult>;

	public function new() {
		this.readers = [new PicoTestReader()];
		this.printers = [];
		this.reporters = [];
		this.completedResults = [];
		this.incompleteResults = [];
	}

	public function add(task:IPicoTestTask):Void {
		this.incompleteResults.push(new PicoTestResult(task));
	}

	public function addResult(result:PicoTestResult):Void {
		this.completedResults.push(result);
	}

	public function load(testCaseClass:Class<Dynamic>):Void {
		for (reader in this.readers) reader.load(this, testCaseClass);
	}

	public function run():Void {
		#if js
		// TODO enable source map support
		#end
		if (PicoTest.currentRunner != null) throw "PicoTestRunner instance is running";
		PicoTest.currentRunner = this;
		while (incompleteResults.length > 0) {
			var result:PicoTestResult = incompleteResults.shift();
			currentAssertResults = result.assertResults;
			var isComplete:Bool = true;
			try {
				isComplete = result.task.resume();
			#if flash
			} catch (e:Error) {
				// flash must retrieve stack trace from Error object
				this.error(Std.string(e), this.buildFlashCallStack(e.getStackTrace()));
				isComplete = true;
			#end
			} catch (d:Dynamic) {
				this.error(Std.string(d), CallStack.exceptionStack());
				isComplete = true;
			}
			if (isComplete) {
				for (printer in this.printers) printer.print(result);
				completedResults.push(result);
			} else {
				incompleteResults.push(result);
			}
		}
		for (reporter in this.reporters) reporter.report(this.completedResults);
		PicoTest.currentRunner = null;


		#if (flash && picotest_report)
		System.exit(0);
		#end
	}

	public function success(assertResult:PicoTestAssertResult = null):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Success;
		for (printer in this.printers) printer.printAssertResult(assertResult);
	}

	public function failure(message:String = null, p:PosInfos):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Failure(message, PicoTestCallInfo.fromPosInfos(p));
		currentAssertResults.push(assertResult);
		for (printer in this.printers) printer.printAssertResult(assertResult);
	}

	public function error(message:String = null, callStack:Array<StackItem>):Void {
		var assertResult:PicoTestAssertResult = PicoTestAssertResult.Error(message, PicoTestCallInfo.fromCallStack(callStack));
		currentAssertResults.push(assertResult);
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
