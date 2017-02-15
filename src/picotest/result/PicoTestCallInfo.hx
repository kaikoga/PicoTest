package picotest.result;

import haxe.CallStack.StackItem;
import haxe.PosInfos;

class PicoTestCallInfo {

	public var target:PicoTestCallTarget = PicoTestCallTarget.Local;
	public var position:PicoTestCallPosition = PicoTestCallPosition.Unavailable;
	public var callType:PicoTestCallType = PicoTestCallType.Unknown;
	public var from:Null<PicoTestCallInfo> = null;

	public function new() {
	}

	public static function fromCallStack(callStack:Array<StackItem>):PicoTestCallInfo {
		return new PicoTestCallInfo().readCallStack(callStack);
	}
	public function readCallStack(callStack:Array<StackItem>):PicoTestCallInfo {
		this.position = PicoTestCallPosition.Unavailable;
		this.callType = PicoTestCallType.Unknown;
		this.from = null;

		if (callStack.length == 0) return this;

		var stackItem:StackItem = callStack[0];
		while (stackItem != null) {
			switch (stackItem) {
				case StackItem.FilePos(s, fileName, lineNumber):
					#if neko
					var filePath:Array<String> = fileName.split("::")[0].split(".");
					filePath.remove("hx");
					this.position = PicoTestCallPosition.ClassPath(filePath.join("/") + ".hx", lineNumber);
					#else
					this.position = PicoTestCallPosition.Absolute(fileName, lineNumber);
					#end
					stackItem = if (s != null) s; else StackItem.CFunction;
				case StackItem.CFunction:
					this.callType = PicoTestCallType.CFunction;
					stackItem = null;
				case StackItem.LocalFunction(index):
					this.callType = PicoTestCallType.LocalFunction(index);
					stackItem = null;
				case StackItem.Method(className, methodName):
					this.callType = PicoTestCallType.Method(className.split("/").join("."), methodName);
					stackItem = null;
				case StackItem.Module(moduleName):
					this.callType = PicoTestCallType.Module(moduleName);
					stackItem = null;
			}
		}

		if (callStack.length > 1) {
			this.from = fromCallStack(callStack.slice(1));
		} else {
			this.from = null;
		}
		return this;
	}

	public static function fromPosInfos(posInfos:PosInfos):PicoTestCallInfo {
		return new PicoTestCallInfo().readPosInfos(posInfos);
	}

	public function readPosInfos(posInfos:PosInfos) {
		var filePath:String = posInfos.className.split(".").join("/").split(posInfos.fileName.split(".")[0])[0] + posInfos.fileName;
		this.position = PicoTestCallPosition.ClassPath(filePath, posInfos.lineNumber);
		this.callType = PicoTestCallType.Method(posInfos.className, posInfos.methodName);
		this.from = null;
		return this;
	}

	public static function fromReflect(className:String, methodName:String):PicoTestCallInfo {
		return new PicoTestCallInfo().reflect(className, methodName);
	}
	public function reflect(className:String, methodName:String) {
		var filePath:String = className.split(".").join("/") + ".hx";
		this.position = PicoTestCallPosition.ClassPath(filePath, 1);
		this.callType = PicoTestCallType.Method(className, methodName);
		this.from = null;
		return this;
	}

	public function isMethod(className:String, methodName:String):Bool {
		switch (this.callType) {
			case PicoTestCallType.Method(c, m):
				return className == c && methodName == m;
			case _:
				return false;
		}
	}

	public function printCallTarget():String {
		return switch (this.target) {
			case PicoTestCallTarget.Local: return "";
			case PicoTestCallTarget.Remote(t): return '($t) ';
		}
	}
	public function printPosition():String {
		return switch (this.position) {
			case PicoTestCallPosition.Unavailable:
				"(file pos unavailable):";
			case PicoTestCallPosition.Absolute(fileName, lineNumber):
				'$fileName:$lineNumber:';
			case PicoTestCallPosition.ClassPath(fileName, lineNumber):
				'$fileName:$lineNumber:';
		};
	}
	public function printCallType():String {
		return switch (this.callType) {
			case PicoTestCallType.Unknown:
				"<Unknown>";
			case PicoTestCallType.CFunction:
				"<C function>";
			case PicoTestCallType.Module(moduleName):
				'$moduleName';
			case PicoTestCallType.Method(className,methodName):
				'$className.$methodName()';
			case PicoTestCallType.LocalFunction(index):
				'Local function #$index';
		};
	}
	public function print():String {
		return '${this.printCallTarget()} ${this.printPosition()} ${this.printCallType()}';
	}
}

enum PicoTestCallTarget {
	Local;
	Remote(header:String);
}

enum PicoTestCallPosition {
	Unavailable;
	ClassPath(className:String, lineNumber:Int);
	Absolute(fileName:String, lineNumber:Int);
}

enum PicoTestCallType {
	Unknown;
	CFunction;
	Module(moduleName:String);
	Method(className:String, methodName:String);
	LocalFunction(?index:Int);
}
