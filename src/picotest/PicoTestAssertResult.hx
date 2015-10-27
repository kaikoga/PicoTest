package picotest;

/**
	Assertion result of PicoTest.
**/
enum PicoTestAssertResult {
	Success;
	Failure(message:String, callInfo:PicoTestCallInfo);
	Error(message:String, callInfo:PicoTestCallInfo);
	Trace(message:String, callInfo:PicoTestCallInfo);
	Ignore(message:String, callInfo:PicoTestCallInfo);
	Invalid(message:String, callInfo:PicoTestCallInfo);
}
