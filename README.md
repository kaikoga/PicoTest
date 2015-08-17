PicoTest, based on [NanoTest](https://github.com/shohei909/NanoTest),
is a (to-be) very versatile unit testing framework for Haxe.
It attempts to be customizable to fit various use cases, without meddling.

PicoTest can run tests and display failures as compiler warnings.

#Installing PicoTest

You can install PicoTest from haxelib.

```
haxelib git picotest https://github.com/kaikoga/PicoTest.git master src
haxelib install hamcrest
```

PicoTest is developed using Haxe 3.2.

#Running tests

Running PicoTest without using macro will output result to ```haxe.Log.trace```.

The application is supposed to exit once running tests are done. 

#Running tests through macro

Write test classes and run with 

```
cd samples
haxe swf.hxml
```

Adding ```--macro picotest.PicoTest.warn()``` is supposed to work without customizations.
(only tested in Mac for now)

Currently supported targets are:

- Flash (test runs with standalone Flash Player Debugger)
- Neko
- JavaScript (test runs with Node.js)
- PHP
- C++
- Java (hamcrest not working)
- C# (test runs with Mono (or native on Windows), hamcrest not working)

Python target is currently not working.

Currently supported systems are:
- Mac

Windows, Linux, and BSD are not tested but maybe work.

##Running using IntelliJ IDEA

Supposed to work, as long as you set the $PATH of IDEA to point the executables
of ```neko```, ```node```, ```java```, ```mono```, etc.

Launching IDEA from Terminal with ```open -a "IntelliJ IDEA 14"``` will be the easiest way to try PicoTest in Mac.

#Assertions

Basic assertions are defined in ```picotest.PicoAssert```.
PicoTest assertion failure will continue running the test
and tries to output as much failures as possible, as NanoTest does. 

To have complex assertions, PicoTest has Hamcrest support. 
```picotest.PicoAssert.assertThat()``` actually doesn't throw any errors,
so you can have more assertion failures just as basic assertions of PicoTest.

Note: ```picotest.PicoAssert.assertThat()``` conflicts with ```org.hamcrest.Matchers.assertThat()```.
To use PicoTest version of ```assertThat()```, ```import picotest.PicoAssert.*;``` should be later.
(see ```HamcrestSampleTestCase``` for example)

#Async Supports

Async supports are defined in ```picotest.PicoTestAsync```.

```assertLater<T>(func:Void->Void, delayMs:Int)``` will simply test passed assertions after passed delay.

```createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void```
could be used to make sure some callback is executed before timeout,
and make additional checks when callback is called or the timeout has come. 

##Variation of Async Supports

Due to nature of variance in implementing event loops among some platforms,
async testing will have some inconsistency you must take care of.

### Async using platform event loop

Granted async testing support is available for flash / js / java targets.
In these targets ```PicoTestAsync``` will use ```haxe.Timer.delay()``` for delayed calls.

Virtually all Flash / JS apps use their granted async with callbacks,
so as long as you stick in either target this won't be a problem in most cases.

### Async using PicoTest's own event loop

PicoTest internal async testing support is available for sys targets.
In these targets ```PicoTestAsync``` will use ```Sys.sleep()``` for delayed calls,
and block the main thread without handling any event loops.

Note that any timer-based async callbacks (like Flash or JS) aren't expected to happen,
so you have to trigger them inside your test methods manually using ```PicoTestAsync.assertLater()```, et al.

### Async using outer event loop

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

#Compiler Defines

##Cross

```-D picotest_nodep``` Removes hamcrest support
```-D picotest_thread``` Tries to use multithread version of PicoTestAsync in sys platforms

##Flash

```-D picotest_fp``` Path to executable of Flash Player (default per OS)  
```-D picotest_flog``` Path to flashlog.txt (default per OS)
```-D picotest_report=json``` output report file (used internally by ```PicoTest.warn()```)  
```-D picotest_report_dir``` Path to output test report file (default ```bin/report```)  

#Planned Features

- Async testing ... doing!
- Support basic assertions standalone
- "throw" testing
- Options to run Flash/js in browser 
- Setting path to executables of ```neko```, ```node```, ```java```, ```mono```, etc... 
- Support more platforms! 

#License

The MIT License
