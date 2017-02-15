package picotest.result;

class PicoTestResultSummary {

	private var testsEmpty:Int = 0;
	private var testsSuccess:Int = 0;
	private var testsFailure:Int = 0;
	private var testsError:Int = 0;
	private var testsIgnore:Int = 0;
	private var testsInvalid:Int = 0;

	private var assertsSuccess:Int = 0;
	private var assertsFailure:Int = 0;
	private var assertsError:Int = 0;

	public function new() {
	}

	public function read(results:Array<PicoTestResult>):PicoTestResultSummary {
		for (result in results) {
			for (assertResult in result.assertResults) {
				switch (assertResult) {
					case PicoTestAssertResult.Success:
						this.assertsSuccess++;
					case PicoTestAssertResult.Failure(message,callInfo):
						this.assertsFailure++;
					case PicoTestAssertResult.Error(message,callInfo):
						this.assertsError++;
					case PicoTestAssertResult.Trace(message,callInfo):
					case PicoTestAssertResult.Ignore(message,callInfo):
					case PicoTestAssertResult.Invalid(message,callInfo):
				}
			}
			switch (result.mark()) {
				case PicoTestResultMark.Empty:
					this.testsEmpty++;
				case PicoTestResultMark.Success:
					this.testsSuccess++;
				case PicoTestResultMark.Failure:
					this.testsFailure++;
				case PicoTestResultMark.Error:
					this.testsError++;
				case PicoTestResultMark.Ignore:
					this.testsIgnore++;
				case PicoTestResultMark.Invalid:
					this.testsInvalid++;
			}
		}
		return this;
	}

	public function summarize():String {
		var tests:Array<String> = [];
		var asserts:Array<String> = [];
		if (testsSuccess > 0) tests.push('Success: $testsSuccess');
		if (testsFailure > 0) tests.push('Failure: $testsFailure');
		if (testsError > 0) tests.push('Error: $testsError');
		if (testsIgnore > 0) tests.push('Ignore: $testsIgnore');
		if (testsEmpty > 0) tests.push('Empty: $testsEmpty');
		if (testsInvalid > 0) tests.push('Invalid: $testsInvalid');
		if (assertsSuccess > 0) asserts.push('success: $assertsSuccess');
		if (assertsFailure > 0) asserts.push('failure: $assertsFailure');
		if (assertsError > 0) asserts.push('error: $assertsError');

		var s:Array<String> = [];
		s.push('----------------------------------------');
		if (tests.length > 0) s.push('Tests: ${tests.join(', ')}');
		if (asserts.length > 0) s.push('asserts: ${asserts.join(', ')}');
		s.push('----------------------------------------\n');
		return s.join('\n');
	}
}
