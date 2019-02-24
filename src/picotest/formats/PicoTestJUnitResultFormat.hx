package picotest.formats;

import picotest.result.PicoTestResultSummary;
import haxe.xml.Printer;
import picotest.result.PicoTestAssertResult;
import picotest.result.PicoTestCallInfo;
import picotest.result.PicoTestResult;

class PicoTestJUnitResultFormat {

	public static function serialize(results:Array<PicoTestResult>):String {
		var doc:Xml = Xml.createDocument();
		var xml:Xml = Xml.createElement("testsuite");
		var summary:PicoTestResultSummary = new PicoTestResultSummary();
		summary.read(results);
		xml.set("name", "picotest");
		xml.set("tests", Std.string(summary.testsTotal));
		xml.set("errors", Std.string(summary.testsError));
		xml.set("failures", Std.string(summary.testsFailure));
		xml.set("time", "1");
		doc.addChild(Xml.createProcessingInstruction('xml version="1.0"'));
		doc.addChild(xml);
		for (result in results) {
			xml.addChild(convertResult(result, xml));
		}

		return Printer.print(doc, true);
	}

	public static function convertResult(result:PicoTestResult, testsuite:Xml):Xml {
		var xml:Xml = Xml.createElement("testcase");
		xml.set("classname", result.className);
		xml.set("name", '${result.methodName}${result.printExecInfo()}');

		for (assertResult in result.assertResults) {
			var assertResultXml:Xml = convertAssertResult(assertResult, testsuite);
			if (assertResultXml != null) xml.addChild(assertResultXml);
		}
		return xml;
	}

	public static function convertAssertResult(assertResult:PicoTestAssertResult, testsuite:Xml):Xml {
		var xml:Xml;
		switch (assertResult) {
			case PicoTestAssertResult.Success:
				return null;
			case PicoTestAssertResult.Skip:
				xml = Xml.createElement("skipped");
			case PicoTestAssertResult.DryRun:
				xml = Xml.createElement("skipped");
			case PicoTestAssertResult.Failure(message, callInfo):
				xml = Xml.createElement("failure");
				xml.set("type", "");
				xml.set("message", message);
				xml.addChild(Xml.createPCData(convertCallInfo(callInfo)));
			case PicoTestAssertResult.Error(message, callInfo):
				xml = Xml.createElement("error");
				xml.set("type", "");
				xml.set("message", message);
				xml.addChild(Xml.createPCData(convertCallInfo(callInfo)));
			case PicoTestAssertResult.Trace(message, callInfo):
				xml = Xml.createElement("system-out");
				xml.addChild(Xml.createCData(message));
				testsuite.addChild(xml);
				return null;
			case PicoTestAssertResult.Ignore(message, callInfo):
				xml = Xml.createElement("skipped");
			case PicoTestAssertResult.Invalid(message, callInfo):
				xml = Xml.createElement("error");
				xml.set("type", "Invalid");
				xml.set("message", message);
				xml.addChild(Xml.createPCData(convertCallInfo(callInfo)));
		}
		return xml;
	}

	public static function convertCallInfo(callInfo:PicoTestCallInfo):String {
		var result:String;
		switch (callInfo.callType) {
			case PicoTestCallType.Unknown:
				result = "at <Unknown>";
			case PicoTestCallType.CFunction:
				result = "at <CFunction>";
			case PicoTestCallType.Module(moduleName):
				result = 'at $moduleName';
			case PicoTestCallType.Method(className, methodName):
				result = 'at $className.$methodName';
			case PicoTestCallType.LocalFunction(index):
				result = 'at <LocalFunction $index>';
		}
		switch (callInfo.position) {
			case PicoTestCallPosition.Unavailable:
			case PicoTestCallPosition.Absolute(fileName, lineNumber), PicoTestCallPosition.ClassPath(fileName, lineNumber):
				result += '($fileName:$lineNumber)';
		}
		if (callInfo.from != null) result += "\n" + convertCallInfo(callInfo.from);
		return result;
	}
}
