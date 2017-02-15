package picotest.reporters;

import haxe.macro.Context;
import haxe.macro.Expr.Position;
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

	public function new():Void {

	}

	private function showHeader(result:PicoTestResult):Bool {
		return true;
	}

	public function report(results:Array<PicoTestResult>):Void {
		for (result in results) {
			for (assertResult in result.assertResults) {
				switch (assertResult) {
					case PicoTestAssertResult.Success:
					case PicoTestAssertResult.Failure(message,callInfo):
						warn(message, result, callInfo, true);
					case PicoTestAssertResult.Error(message,callInfo):
						warn('[Error] ${message}', result, callInfo, true);
					case PicoTestAssertResult.Trace(message,callInfo):
					#if picotest_show_trace
						warn('[Trace] ${message}', result, callInfo);
					#end
					case PicoTestAssertResult.Ignore(message,callInfo):
					#if picotest_show_ignore
						warn('[Ignore] ${message}', result, callInfo);
					#end
					case PicoTestAssertResult.Invalid(message,callInfo):
						warn('[Invalid] ${message}', result, callInfo);
				}
			}
			switch (result.mark()) {
				case PicoTestResultMark.Empty:
					warn('[Empty] Test is empty', result, PicoTestCallInfo.fromReflect(result.className, result.methodName));
				case _:
			}
		}
		PicoTest.stdout(new PicoTestResultSummary().read(results).summarize());
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
					#if picotest_show_stack
					printWarn('(from here)', result, stack);
					#end
			}
			stack = stack.from;
		}

		var imaginaryRoot:PicoTestCallInfo = PicoTestCallInfo.fromReflect(result.className, result.methodName);
		printWarn('(from this test case)', result, imaginaryRoot);
	}

	private function printWarn(message:String, result:PicoTestResult, callInfo:PicoTestCallInfo):Void {
		var p:String = if (result == null) '' else result.printParameters();
		#if macro
		Context.warning('${callInfo.printCallTarget()}${callInfo.printCallType()}$p: ${message.split("\n").join("\n "+callInfo.printCallTarget())}', callPositionToPosition(callInfo.position));
		#else
		PicoTest.stdout('${callInfo.print()}$p: $message\n');
		#end
	}

	private function filePosition(file:String, line:Int):{min:Int, max:Int} {
		var min = 0;
		var max = 0;
		#if macro
		var text:String = File.read(file).readAll().toString();
		var ereg:EReg = ~/(\r\n|\r|\n)/;

		for ( i in 0...line - 1 ) {
			ereg.match( text );
			var pos = ereg.matchedPos();
			min += pos.pos + pos.len;
			text = ereg.matchedRight();
		}

		max = min +
		if( ereg.match( text ) )
			ereg.matchedPos().pos;
		else
			text.length;
		#end
		return {min:min, max:max};
	}

	private var notFoundFileNames:Array<String> = [];
	private function fileNotFoundWarning(fileName:String):Void {
		if (notFoundFileNames.indexOf(fileName) >= 0) return;
		notFoundFileNames.push(fileName);
		if (notFoundFileNames.length == 0) {
			PicoTest.stdout('($fileName: file not found in classpaths ${Context.getClassPath()})\n');
		} else {
			PicoTest.stdout('($fileName: file not found in classpaths)\n');
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
					fileNotFoundWarning(fileName);
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

}
