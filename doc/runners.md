# Running tests

A test suite in PicoTest is simply a test runner that runs provided tests.
Create a ```PicoTestRunner``` instance through ```PicoTest.runner()``` to have basic setup for running tests.
Call ```PicoTestRunner.load()``` to add test cases, followed by ```PicoTestRunner.run()``` to execute them. 

```haxe
package ;

import picotest.PicoTest;
import picotest.PicoTestRunner;

class SampleTest {

	public function new() {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.load(SampleTestCase);
		runner.run();
	}

	public static function main():Void {
		new SampleTest();
	}
}
```

Test runner could be executed with or without macro setup.
We recommend to prepare a bunch of HXML files to run tests through various setups and targets.


## Running tests through macro

With macro setup, PicoTest could run unit tests on compile timing, and output test results as compilation warnings. 

For targets built with `haxe` command, ```--macro picotest.PicoTest.warn()``` is supposed to work in most targets without customizations.
Some frameworks consisting toolchains (like OpenFL) requires alternate setup.
Refer `/samples` directory for examples. 


## Running tests without macro

PicoTest could be used without macro setup, which may be launched as an ordinary executable.
When started from application code (without using macros), ```PicoTest.runner()``` would function as below:

- Browser targets (swf, JS without node):
  - The test result would be displayed on screen.
  - The application (Flash Player or Browser) would be kept open.
- Sys targets:
  - The test result would be output through ```haxe.Log.trace```.
  - The application is supposed to exit once running tests are done.


## Test Class Filters

You can restrict which test class would be executed with test class filters.
Test class filters are treated as EReg.
Multiple filters could be provided. All test classes matching any of the provided patterns are selected.

There are some ways to provide test class filters:

- ```--macro "picotest.PicoTest.filter('package.TestCaseClass')"``` provides single filter.
- ```--macro "picotest.PicoTest.filterFile('picofilter.txt')"``` reads test class filters from ```picofilter.txt``` per line. 
  ```"picofilter.txt"``` is default argument, so could be omitted like ```--macro "picotest.PicoTest.filterFile()"```
- You could also provide filters like ```-D picotest_filter=package.TestCaseClass,anotherPack.AnotherTestCaseClass```. 

For example, ```--macro "picotest.PicoTest.filter('package.TestCaseClass')"``` will mostly only run test methods in ```package.TestCaseClass```.
