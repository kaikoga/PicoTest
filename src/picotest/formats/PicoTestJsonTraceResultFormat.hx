package picotest.formats;

import picotest.formats.PicoTestJsonResultFormat;
import picotest.result.PicoTestResult;

class PicoTestJsonTraceResultFormat {

	inline public static var PICOTEST_RESULT_HEADER:String = "__picotest_result__:";

	public static function serialize(results:Array<PicoTestResult>):String {
		return '\n${PICOTEST_RESULT_HEADER}${PicoTestJsonResultFormat.serialize(results)}\n';
	}

	public static function deserialize(report:String, header:String):Array<PicoTestResult> {
		return PicoTestJsonResultFormat.deserialize(report.substr(report.indexOf(PICOTEST_RESULT_HEADER) + PICOTEST_RESULT_HEADER.length), header);
	}
}
