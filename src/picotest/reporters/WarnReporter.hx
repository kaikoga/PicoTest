package picotest.reporters;

import picotest.PicoTestCallInfo.PicoTestCallPosition;
import haxe.macro.Context;
import haxe.macro.Expr.Position;

#if macro
import sys.io.File;
import sys.FileSystem;
#end

class WarnReporter implements IPicoTestReporter {

	public function new():Void {

	}

	public function report(results:Array<PicoTestResult>):Void {
		for (result in results) {
			for (assertResult in result.assertResults) {
				switch (assertResult) {
					case PicoTestAssertResult.Success:
					case PicoTestAssertResult.Failure(message,callInfo):
						warn(message, callInfo);
					case PicoTestAssertResult.Error(message,callInfo):
						warn(message, callInfo);
					case PicoTestAssertResult.Trace(message,callInfo):
				}
			}
		}
	}

	private function warn(message:String, callInfo:PicoTestCallInfo):Void {
		#if macro
		Context.warning('${callInfo.printCallTarget()}${callInfo.printCallType()}: ${message.split("\n").join("\n "+callInfo.printCallTarget())}', callPositionToPosition(callInfo.position));
		#else
		PicoTest.stdout('${callInfo.print()}: $message\n');
		#end
	}

	private function filePosition(file:String, line:Int):{min:Int, max:Int} {
		var min = 0;
		var max = 0;
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
		return {min:min, max:max};
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
					Context.warning('(File [$fileName] not found in classpaths ${Context.getClassPath()})', Context.makePosition({ file : fileName, min : 0, max : 0 }));
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
				PicoTest.stdout('$fileName: file not found in classpaths ${Context.getClassPath()}');
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
