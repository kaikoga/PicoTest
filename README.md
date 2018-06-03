PicoTest, based on [NanoTest](https://github.com/shohei909/NanoTest),
is a very versatile unit testing framework for Haxe.
It attempts to be customizable to fit various use cases, without meddling.

PicoTest can run tests and display failures as compiler warnings.


# Installing PicoTest

You can install PicoTest from haxelib.

```
haxelib git picotest https://github.com/kaikoga/PicoTest.git develop src
haxelib install hamcrest
```

PicoTest is developed using Haxe 4.0.0-preview.3, but is supposed to run with Haxe 3.4.0 or over. 


# Writing tests

Any simple Haxe class could be test cases.

Any method whose name starts with ```test``` or marked by ```@Test``` metadata would be test methods.


## Setup and teardown

Any method whose name is ```setup()``` is called before every test method invocation.
Any method whose name is ```tearDown()``` is called after every test method invocation.


## Assertions

Basic assertions are defined in ```picotest.PicoAssert```.
PicoTest assertion failure will continue running the test
and tries to output as much failures as possible, as NanoTest does. 

```
public function test() {
    assertTrue(false);
    assertTrue(false);
}
```

This test method emits 1 test failure, 2 assertion failures. 


### Hamcrest Support

To have complex assertions, PicoTest has Hamcrest support. 
```picotest.PicoAssert.assertThat()``` actually doesn't throw any errors,
so you can have more assertion failures just as basic assertions of PicoTest.

Note: ```picotest.PicoAssert.assertThat()``` conflicts with ```org.hamcrest.Matchers.assertThat()```.
To use PicoTest version of ```assertThat()```, ```import picotest.PicoAssert.*;``` should be later.
(see ```HamcrestSampleTestCase``` for example)

```-D picotest_nodep``` will remove hamcrest supports.


### Structure Based Matching Support 

```picotest.PicoAssert.assertMatch(expected, actual, ?message, ?matcher, ?p)```
is a shortcut to do matching with complex structures.

When ```matcher``` is not provided, all elements of arrays and anonymous structures are recursively matched,
and any mismatch is reported in the failure output.
When you need to define your own matching rules,
you can also create your own ```PicoMatcher``` and pass it as ```matcher``` argument.

When hamcrest support is enabled, hamcrest ```Matcher```s in ```expected``` are also taken into account.

For example,

```
assertMatch([1, 2], [3, 4, 5]);
```

will fail like: 

```
Structure mismatch:
  - *[] expected [2] but was [3]
  - *[0] expected 1 but was 3
  - *[1] expected 2 but was 4
  - *[2] expected null but was 5
```

Refer ```PicoMatcherSampleTestCase``` and ```PicoMatcherHamcrestSampleTestCase``` for more examples.


## Parametrized Tests

```@Parameter("parameterProviderMethodName")``` (note the String) will take test parameter from given function.
```@Parameter``` will take the default parameter, which can be passed through second argument of PicoTestRunner.load(). 

Test methods and ```setup()``` could be parametrized.

Refer ```ParametrizedSampleTestCase``` for examples.


## Async Supports

Async supports are defined in ```picotest.PicoTestAsync```.

```assertLater<T>(func:Void->Void, delayMs:Int)``` will simply execute ```func``` after ```delayMs```.

```createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void```
could be used to make sure some callback is executed before timeout,
and make additional checks when callback is called or the timeout has come. 


### Variation of Async Supports

Due to nature of variance in implementing event loops among some platforms,
async testing will have some inconsistency you must take care of.


#### Async using platform event loop

Granted async testing support is available for flash / js / java targets.
In these targets ```PicoTestAsync``` will use ```haxe.Timer.delay()``` for delayed calls.

Virtually all Flash / JS apps use their granted async with callbacks,
so as long as you stick in either target this won't be a problem in most cases.


#### Async using PicoTest's own event loop

PicoTest internal async testing support is available for sys targets.
In these targets ```PicoTestAsync``` will use ```Sys.sleep()``` for delayed calls,
and block the main thread without handling any event loops.

Note that any timer-based async callbacks (like Flash or JS) aren't expected to happen,
so you have to trigger them inside your test methods manually using ```PicoTestAsync.assertLater()```, et al.


#### Async using outer event loop

```PicoTestRunner.resume()``` could be called repetitively instead of ```PicoTestRunner.run()```
when you have your own event loop and you want to run tests without multithreading.
```PicoTestRunner.resume()``` returns ```true``` until all tests complete.

In particular, OpenFL on cpp will need this solution
(where OpenFL has its own ```haxe.Timer.delay()``` implementation and some async APIs).


### Async using multithread event loop

Technically async testing could be done with multithreading.
You can either run PicoTest in its own thread and wait for callback,
or use ```PicoTestRunner.addMainLoop``` to run your main loop until PicoTest has completed.
The difficult part is that threading itself in Haxe is not cross-platform.

Warning: running PicoTest using threads is not officially tested and may contain bugs!


# Running tests

Create a ```PicoTestRunner``` instance through ```PicoTest.runner()``` to have basic setup for running unit tests.
Call ```PicoTestRunner.load()``` to add test cases, and ```PicoTestRunner.run()``` to start them. 

PicoTest could be used without macro setup.
When started from application code (without using macros), default setup would be done such as:

- The test result would be output to ```haxe.Log.trace```.
- The application is supposed to exit once running tests are done.


# Running tests through macro

With macro setup, PicoTest could run unit tests on compile timing, and output test results as compilation warnings. 

Adding ```--macro picotest.PicoTest.warn()``` is supposed to work without customizations.
(only tested in Mac for now)

Currently supported targets are:

- Flash (test runs with standalone Flash Player Debugger)
- Neko
- JavaScript (test runs with Node.js, or with web browsers)
- PHP ( ```-D php7``` is supported )
- Python
- Lua
- C++
- Java (hamcrest not working)
- C# (test runs with Mono (or native on Windows), hamcrest not working)

Currently supported systems are:
- Mac

Windows, Linux, and BSD are not tested but maybe work.


## Running using IntelliJ IDEA

Supposed to work, as long as executables such as ```neko```, ```node```, ```java```, ```mono```, etc. are accessible from IDEA. 


## Test Class Filters

- ```--macro "picotest.PicoTest.filter('package.TestCaseClass')"``` will only run specified test class.
  - Test class name pattern accepts regex.
  - Multiple patterns could be provided. All test classes matching any of the provided patterns are selected.
- ```--macro "picotest.PicoTest.filterFile('picofilter.txt')"``` reads class name patterns from ```picofilter.txt```. 
  - ```"picofilter.txt"``` is default argument, so could be omitted.

# Compiler Defines

## Cross

- ```-D picotest_dryrun``` mark every test method as "skipped"
- ```-D picotest_safe_mode``` treats test target objects "dangerous",
and avoid calling methods of test object (like ```toString()```) to prevent infinite loops (Yes, they will happen! see [https://github.com/HaxeFoundation/haxe/issues/4398](https://github.com/HaxeFoundation/haxe/issues/4398)).
As a downside, test output will likely lose some readablility.
- ```-D picotest_show_stack``` Prints more call stack info. Will be truncated if too long
- ```-D picotest_show_ignore``` Also prints ignored tests.
- ```-D picotest_show_trace``` Also prints trace() calls.
- ```-D picotest_nodep``` Remove hamcrest supports
- ```-D picotest_thread``` Tries to use multithread version of PicoTestAsync in sys platforms
- ```-D picotest_report_dir``` Path to output test report file (default ```bin/report```)
- ```-D picotest_junit``` Path to output JUnit XML file


## Internal

- ```-D picotest_remote``` marked when is test results is retrieved through HTTP (otherwise through stdout) 
- ```-D picotest_report_json``` output report file (used internally by ```PicoTest.warn()```)


## Flash

- ```-D picotest_fp``` Path to executable of Flash Player (default per OS)
- ```-D picotest_flog``` Path to flashlog.txt (default per OS)


## JavaScript

- ```-D picotest_browser``` Specify browser to run tests in (TODO)
- ```-D picotest_remote_port``` Local port range to receive test result from browser (default ```49152-61000```)


# Planned Features

- Find out the standards of Flash Player executable path (well, I'll stop using "Flash Player Debugger" before 1.0...)
- Setting path to executables of ```neko```, ```node```, ```java```, ```mono```, etc... 
- Options to run Flash in browser
- Support more platforms! 
- More async testing.


# Release Notes

- Version 0.9.0
  - improved progress output for browsers 
- Version 0.8.0
  - breaking changes to macro API
  - breaking changes to PicoMatcher API
  - breaking changes to progress output: test method name is now printed BEFORE invocation and resumes  
  - rewritten many components
  - made even faster
  - output JUnit XML
- Version 0.7.7
  - made a lot faster
- Version 0.7.6
  - suppress file not found warnings
- Version 0.7.5
  - introducing ```-D picotest_show_trace```
- Version 0.7.4
  - ```-D picotest_``` flags are properly snake_cased
  - small bugfixes
- Version 0.7.3
  - introducing ```-D picotest_safe_mode```
  - handling when ```toString()``` throws
- Version 0.7.2
  - introducing ```assertNull() and assertNotNull()```
  - prints more call stack info if ```-D picotest_show_stack```
- Version 0.7.1
  - introducing ```-D picotest_safe_mode```
- Version 0.7.0
  - Show output progress
  - output progress format changed
- Version 0.6.1
  - Fixed issue with large report output on cpp
- Version 0.6.0
  - Improved WarnReporter position reporting, will output both failure position and test method name also on test failures  
  - Fixed ```assertMatch()``` which cause stack overflow on cpp when matching class instances   
- Version 0.5.2
  - Small fixes
- Version 0.5.1
  - Print test parameters
- Version 0.5.0
  - Try to output test method name which caused an error
  - Output test summary
  - Report empty tests
  - Report invalid tests
- Version 0.4.0
  - Parametrized test support
- Version 0.3.1
  - NaN now matches with NaN on ```assertMatch()``` (matching with NaN always failed on 0.3.0).
- Version 0.3.0
  - OpenFL support
  - JavaScript testing on browsers support
- Version 0.2.0
  - "throw" testing (```assertThrows()```)
  - structure based matching (```assertMatch()```)
  - enum equality is taken into account
  - ```setup()``` and ```tearDown()``` is supported (global ones are not)
  - minor bug fixes
- Version 0.1.0
  - Basic async support 
  - @Ignore support
  - Include trace outputs in assert results
  - Refined documentation
- Version 0.0.0
  - Initial release


# License

The MIT License
