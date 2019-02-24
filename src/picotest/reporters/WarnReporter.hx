package picotest.reporters;

import haxe.macro.Context;
import haxe.macro.Expr.Position;
import picotest.out.IPicoTestOutput;
import picotest.macros.PicoTestConfig;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestCallInfo;
import picotest.result.PicoTestCallInfo.PicoTestCallPosition;
import picotest.result.PicoTestResult;
import picotest.result.PicoTestResultMark;
import picotest.result.PicoTestResultSummary;

#if macro
import sys.io.File;
import sys.FileSystem;
#end

class WarnReporter implements IPicoTestReporter {

	private var stdout:IPicoTestOutput;
	private var isError:Bool;
	private var isFailed:Bool;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	private function showHeader(result:PicoTestResult):Bool {
		return true;
	}

	public function report(summary:PicoTestResultSummary):Void {
		for (result in summary.results) {
			for (assertResult in result.assertResults) {
				switch (assertResult) {
					case PicoTestAssertResult.Success:
					case PicoTestAssertResult.Skip:
					case PicoTestAssertResult.DryRun:
					case PicoTestAssertResult.Failure(message,callInfo):
						warn(message, result, callInfo, true);
						isFailed = true;
					case PicoTestAssertResult.Error(message,callInfo):
						warn('[Error] ${message}', result, callInfo, true);
						isError = true;
					case PicoTestAssertResult.Trace(message,callInfo):
						if (PicoTestConfig.showTrace) {
							warn('[Trace] ${message}', result, callInfo);
						}
					case PicoTestAssertResult.Ignore(message,callInfo):
						if (PicoTestConfig.showIgnore) {
							warn('[Ignore] ${message}', result, callInfo);
						}
					case PicoTestAssertResult.Invalid(message,callInfo):
						warn('[Invalid] ${message}', result, callInfo);
						isError = true;
				}
			}
			switch (result.mark()) {
				case PicoTestResultMark.Empty:
					warn('[Empty] Test is empty', result, PicoTestCallInfo.fromReflect(result.className, result.methodName));
				case PicoTestResultMark.DryRun:
					warn('[DryRun] Test is to be run', result, PicoTestCallInfo.fromReflect(result.className, result.methodName));
				case _:
			}
		}
		this.stdout.output(summary.summarize());
	}

	private function warn(message:String, result:PicoTestResult, callInfo:PicoTestCallInfo, printOrigin:Bool = false):Void {
		printWarn(message, result, callInfo);
		switch (callInfo.callType) {
			case PicoTestCallType.Method(className, methodName)
			if (className == result.className && methodName == result.methodName):
				return;
			case _:
		}

		var stack:PicoTestCallInfo = callInfo.from;
		while (stack != null) {
			switch (stack.callType) {
				case PicoTestCallType.Method(className, methodName)
				if (className == result.className && methodName == result.methodName):
					printWarn('(from this test case)', result, stack);
					return;
				case _:
					if (PicoTestConfig.showStack) {
						printWarn('(from here)', result, stack);
					}
			}
			stack = stack.from;
		}

		var imaginaryRoot:PicoTestCallInfo = PicoTestCallInfo.fromReflect(result.className, result.methodName);
		printWarn('(from this test case)', result, imaginaryRoot);
	}

	private function printWarn(message:String, result:PicoTestResult, callInfo:PicoTestCallInfo):Void {
		var p:String = if (result == null) '' else result.printExecInfo();
		#if macro
		Context.warning('${callInfo.printCallTarget()}${callInfo.printCallType()}$p: ${message.split("\n").join("\n "+callInfo.printCallTarget())}', callPositionToPosition(callInfo.position));
		#else
		this.stdout.output('${callInfo.print()}$p: $message\n');
		#end
	}

	private var cachedFilePositions:Map<String, {min:Int, max:Int}> = new Map();

	private function filePosition(file:String, line:Int):{min:Int, max:Int} {
		var BULK_LINES:Int = 512;
		var cacheKey:String = '$file:$line';

		if (cachedFilePositions.exists(cacheKey)) return cachedFilePositions.get(cacheKey);

		var min = 0;
		var max = 0;
		#if macro
		var text:String = File.read(file).readAll().toString();

		line -= 1;
		while (line > 0) {
			var bulk = line;
			if (bulk > BULK_LINES) bulk = BULK_LINES;
			line -= bulk;
			var minEReg:EReg = new EReg('(.*(\\r\\n|\\r|\\n)){${bulk}}', "");
			if (minEReg.matchSub(text, min)) {
				var pos = minEReg.matchedPos();
				min = pos.pos + pos.len;
			} else {
				min = 0;
				break;
			}
		}

		var maxEReg:EReg = ~/\r|\n|\r\n/;
		if (maxEReg.matchSub(text, min)) {
			max = maxEReg.matchedPos().pos;
		} else {
			max = text.length;
		}
		#end

		var result = {min:min, max:max};
		cachedFilePositions.set(cacheKey, result);
		return result;
	}

	private var notFoundFileNames:Array<String> = [];
	private function fileNotFoundWarning(fileName:String):Void {
		if (notFoundFileNames.indexOf(fileName) >= 0) return;
		notFoundFileNames.push(fileName);
		if (notFoundFileNames.length == 0) {
			this.stdout.output('($fileName: file not found in classpaths ${Context.getClassPath()})\n');
		} else {
			this.stdout.output('($fileName: file not found in classpaths)\n');
		}
	}

	private function callPositionToPosition(callPos:PicoTestCallPosition):Position {
		#if macro
		var file:String = "";
		var min:Int = 0;
		var max:Int = 0;

		switch (callPos) {
			case PicoTestCallPosition.Unavailable:
			case PicoTestCallPosition.ClassPath(fileName, lineNumber):
				try {
					file = Context.resolvePath(fileName);
					var pos = filePosition(file, lineNumber);
					min = pos.min;
					max = pos.max;
					callPos = PicoTestCallPosition.Absolute(file, lineNumber);
				} catch (d:Dynamic) {
					file = "";
				}
			case PicoTestCallPosition.Absolute(fileName, lineNumber):
				file = fileName;
				var pos = filePosition(file, lineNumber);
				min = pos.min;
				max = pos.max;
		}

		switch (callPos) {
			case PicoTestCallPosition.Unavailable:
				return Context.makePosition({ file : "_", min : 0, max : 0 });
			case PicoTestCallPosition.ClassPath(fileName, lineNumber):
				fileNotFoundWarning(fileName);
				return Context.makePosition({ file : fileName, min : 0, max : 0 });
			case PicoTestCallPosition.Absolute(fileName, lineNumber):
				return Context.makePosition({
					file : FileSystem.fullPath(file),
					min : min,
					max : max
				});
		}

		#else
		switch (callPos) {
			case PicoTestCallPosition.Unavailable:
				return { file : "_", min : 0, max : 0 };
			case PicoTestCallPosition.Absolute(fileName, lineNumber), PicoTestCallPosition.ClassPath(fileName, lineNumber):
				return { file : fileName, min : 0, max : 0 };
		}
		#end
	}

	public function close():Void {
		this.stdout.close();
		if (this.isError) Sys.exit(1);
		if (this.isFailed) Sys.exit(2);
	}
}
