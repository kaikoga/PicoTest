package picotest;

enum PicoTestAssertResult {
	Success;
	Failure(message:String, callInfo:PicoTestCallInfo);
	Error(message:String, callInfo:PicoTestCallInfo);
}
