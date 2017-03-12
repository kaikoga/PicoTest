package picotest.reporters;

import picotest.out.IPicoTestOutput;
import haxe.Json;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestCallInfo;
import picotest.result.PicoTestResult;

class JsonReporter implements IPicoTestReporter {

	inline public static var PICOTEST_RESULT_HEADER:String = "__picotest_result__:";

	private var stdout:IPicoTestOutput;

	public function new(stdout:IPicoTestOutput):Void {
		this.stdout = stdout;
	}

	public function report(results:Array<PicoTestResult>):Void {
		var json:Array<HashedResult> = [];
		for (result in results) {
			json.push(hashResult(result));
		}

		this.stdout.stdout('\n${PICOTEST_RESULT_HEADER}${Json.stringify(json, null, "  ")}\n');
	}

	public function close():Void {
		this.stdout.close();
	}

	public static function hashResult(result:PicoTestResult):HashedResult {
		var a:Array<HashedAssertResult> = [];
		for (assertResult in result.assertResults) {
			a.push(hashAssertResult(assertResult));
		}
		return {className:result.className, methodName:result.methodName, parameters:result.parameters, assertResults:a}
	}

	public static function unhashResult(hashed:HashedResult, header:String = null):PicoTestResult {
		var a:Array<PicoTestAssertResult> = [];
		for (hashedAssertResult in hashed.assertResults) {
			a.push(unhashAssertResult(hashedAssertResult, header));
		}
		return new PicoTestResult(hashed.className, hashed.methodName, hashed.parameters, a);

	}

	public static function hashAssertResult(assertResult:PicoTestAssertResult):HashedAssertResult {
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				return {assertResult: "."};
			case PicoTestAssertResult.Skip:
				return {assertResult: "S"};
			case PicoTestAssertResult.Failure(message, callInfo):
				return {assertResult: "F", message: message, callInfo: hashCallInfo(callInfo)};
			case PicoTestAssertResult.Error(message, callInfo):
				return {assertResult: "E", message: message, callInfo: hashCallInfo(callInfo)};
			case PicoTestAssertResult.Trace(message, callInfo):
				return {assertResult: "T", message: message, callInfo: hashCallInfo(callInfo)};
			case PicoTestAssertResult.Ignore(message, callInfo):
				return {assertResult: "I", message: message, callInfo: hashCallInfo(callInfo)};
			case PicoTestAssertResult.Invalid(message, callInfo):
				return {assertResult: "X", message: message, callInfo: hashCallInfo(callInfo)};
		}
	}

	public static function unhashAssertResult(hashed:HashedAssertResult, header:String = null):PicoTestAssertResult {
		switch (hashed.assertResult) {
			case ".":
				return PicoTestAssertResult.Success;
			case "S":
				return PicoTestAssertResult.Skip;
			case "F":
				return PicoTestAssertResult.Failure(hashed.message, unhashCallInfo(hashed.callInfo, header));
			case "E":
				return PicoTestAssertResult.Error(hashed.message, unhashCallInfo(hashed.callInfo, header));
			case "T":
				return PicoTestAssertResult.Trace(hashed.message, unhashCallInfo(hashed.callInfo, header));
			case "I":
				return PicoTestAssertResult.Ignore(hashed.message, unhashCallInfo(hashed.callInfo, header));
			case "X":
				return PicoTestAssertResult.Invalid(hashed.message, unhashCallInfo(hashed.callInfo, header));
		}
		return PicoTestAssertResult.Success;
	}

	public static function hashCallInfo(callInfo:PicoTestCallInfo):HashedCallInfo {
		var hashed:HashedCallInfo = {};
		switch (callInfo.position) {
			case PicoTestCallPosition.Unavailable:
			case PicoTestCallPosition.Absolute(fileName, lineNumber), PicoTestCallPosition.ClassPath(fileName, lineNumber):
				hashed.fileName = fileName;
				hashed.lineNumber = lineNumber;
		}
		switch (callInfo.callType) {
			case PicoTestCallType.Unknown:
			case PicoTestCallType.CFunction:
				hashed.index = -1;
			case PicoTestCallType.Module(moduleName):
				hashed.className = moduleName;
			case PicoTestCallType.Method(className, methodName):
				hashed.className = className;
				hashed.methodName = methodName;
			case PicoTestCallType.LocalFunction(index):
				hashed.index = index;
		}
		if (callInfo.from != null) hashed.from = hashCallInfo(callInfo.from);
		return hashed;
	}

	public static function unhashCallInfo(hashed:HashedCallInfo, header:String = null):PicoTestCallInfo {
		var callInfo:PicoTestCallInfo = new PicoTestCallInfo();
		if (header != null) {
			callInfo.target = PicoTestCallTarget.Remote(header);
		}
		if (hashed.fileName != null) {
			if (hashed.fileName.indexOf("/") == 0) {
				callInfo.position = PicoTestCallPosition.Absolute(hashed.fileName, hashed.lineNumber);
			} else {
				callInfo.position = PicoTestCallPosition.ClassPath(hashed.fileName, hashed.lineNumber);
			}
		}
		switch (hashed.index) {
			case null:
				if (hashed.methodName != null) {
					callInfo.callType = PicoTestCallType.Method(hashed.className, hashed.methodName);
				} else if (hashed.className != null) {
					callInfo.callType = PicoTestCallType.Module(hashed.className);
				} else {
					callInfo.callType = PicoTestCallType.Unknown;
				}
			case -1:
				callInfo.callType = PicoTestCallType.CFunction;
			case i if (i != -1):
				callInfo.callType = PicoTestCallType.LocalFunction(i);
		}
		if (hashed.from != null) callInfo.from = unhashCallInfo(hashed.from);
		return callInfo;
	}
}

typedef HashedResult = {
	className:String,
	methodName:String,
	?parameters:Array<String>,
	assertResults:Array<HashedAssertResult>
}

typedef HashedAssertResult = {
	assertResult:String,
	?message:String,
	?callInfo:HashedCallInfo
}

typedef HashedCallInfo = {
	?fileName:String,
	?lineNumber:Int,
	?className:String,
	?methodName:String,
	?index:Int,
	?from:HashedCallInfo
}
