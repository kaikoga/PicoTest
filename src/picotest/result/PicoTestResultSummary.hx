package picotest.result;

class PicoTestResultSummary {

	public var results(default, null):Array<PicoTestResult> = [];

	public var testsTotal(default, null):Int = 0;
	public var testsEmpty(default, null):Int = 0;
	public var testsDryRun(default, null):Int = 0;
	public var testsSuccess(default, null):Int = 0;
	public var testsSkip(default, null):Int = 0;
	public var testsFailure(default, null):Int = 0;
	public var testsError(default, null):Int = 0;
	public var testsIgnore(default, null):Int = 0;
	public var testsInvalid(default, null):Int = 0;

	public var assertsTotal(default, null):Int = 0;
	public var assertsSuccess(default, null):Int = 0;
	public var assertsFailure(default, null):Int = 0;
	public var assertsError(default, null):Int = 0;

	public var mark(get, never):PicoTestResultMark;
	private function get_mark():PicoTestResultMark {
		if (testsInvalid > 0) return PicoTestResultMark.Invalid;
		if (testsError > 0) return PicoTestResultMark.Error;
		if (testsFailure > 0) return PicoTestResultMark.Failure;
		if (testsIgnore > 0) return PicoTestResultMark.Ignore;
		if (testsSkip > 0) return PicoTestResultMark.Skip;
		if (testsSuccess > 0) return PicoTestResultMark.Success;
		if (testsDryRun > 0) return PicoTestResultMark.DryRun;
		return PicoTestResultMark.Empty;
	}

	public function new() {
	}

	public function read(results:Array<PicoTestResult>):PicoTestResultSummary {
		this.results = this.results.concat(results);
		for (result in results) {
			for (assertResult in result.assertResults) {
				switch (assertResult) {
					case PicoTestAssertResult.Success:
						this.assertsSuccess++;
						this.assertsTotal++;
					case PicoTestAssertResult.Skip:
					case PicoTestAssertResult.DryRun:
					case PicoTestAssertResult.Failure(message,callInfo):
						this.assertsFailure++;
						this.assertsTotal++;
					case PicoTestAssertResult.Error(message,callInfo):
						this.assertsError++;
						this.assertsTotal++;
					case PicoTestAssertResult.Trace(message,callInfo):
					case PicoTestAssertResult.Ignore(message,callInfo):
					case PicoTestAssertResult.Invalid(message,callInfo):
				}
			}
			switch (result.mark()) {
				case PicoTestResultMark.Empty:
					this.testsEmpty++;
				case PicoTestResultMark.DryRun:
					this.testsDryRun++;
				case PicoTestResultMark.Success:
					this.testsSuccess++;
				case PicoTestResultMark.Skip:
					this.testsSkip++;
				case PicoTestResultMark.Failure:
					this.testsFailure++;
				case PicoTestResultMark.Error:
					this.testsError++;
				case PicoTestResultMark.Ignore:
					this.testsIgnore++;
				case PicoTestResultMark.Invalid:
					this.testsInvalid++;
			}
			this.testsTotal++;
		}
		return this;
	}

	public function summarize():String {
		var tests:Array<String> = [];
		var asserts:Array<String> = [];
		if (testsSuccess > 0) tests.push('Success: $testsSuccess');
		if (testsSkip > 0) tests.push('Skip: $testsSkip');
		if (testsFailure > 0) tests.push('Failure: $testsFailure');
		if (testsError > 0) tests.push('Error: $testsError');
		if (testsIgnore > 0) tests.push('Ignore: $testsIgnore');
		if (testsEmpty > 0) tests.push('Empty: $testsEmpty');
		if (testsDryRun> 0) tests.push('DryRun: $testsDryRun');
		if (testsInvalid > 0) tests.push('Invalid: $testsInvalid');
		if (assertsSuccess > 0) asserts.push('success: $assertsSuccess');
		if (assertsFailure > 0) asserts.push('failure: $assertsFailure');
		if (assertsError > 0) asserts.push('error: $assertsError');

		var s:Array<String> = [];
		s.push('----------------------------------------');
		if (tests.length > 0) s.push('Tests ${testsTotal}: ${tests.join(', ')}');
		if (asserts.length > 0) s.push('asserts ${testsTotal}: ${asserts.join(', ')}');
		s.push('----------------------------------------\n');
		return s.join('\n');
	}
}
