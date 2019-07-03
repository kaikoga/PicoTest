# Writing tests

Plain Haxe class could be provided as a test class.

Any instance method of a test class whose name starts with ```test``` or marked by ```@Test``` metadata would be test methods.

```haxe
package ;

import picotest.PicoAssert.*;

class SampleTestCase {
    public function testAssertTrue() {
        assertTrue(true);
    }

    @Test
    public function anotherTest() {
        assertTrue(true); // This is another way to define a test method 
    }
}
```

Note: You will also have to define a test runner to run these tests.


## Setup and teardown

```setup()``` is called before every test method invocation.
```tearDown()``` is called after every test method invocation.

```haxe
package ;

class ExampleSetupAndTearDown {
    public function test() {
    }
    public function otherTest() {
    }
    public function setup() {
        // This method is called before test() and otherTest() invocation 
    }
    public function tearDown() {
        // This method is called after test() and otherTest() invocation 
    }
}
```


## Parametrized Tests

Test methods could be parametrized.
Parametrized tests are invoked per parameter, therefore executed multiple times. 

```@Parameter("parameterProviderMethodName")``` (literal String) will take test parameter from given function.
```@Parameter``` will take the default parameter, which can be passed through second argument of ```PicoTestRunner.load()```. 

```setup()``` also could be parametrized.
All test methods would be invoked multiple times, with each parameters passed to ```setup()```.

```haxe
package ;

class SampleTestCase {
    @Parameter("ParameterProvider")
    public function test(a:String) {
        // This method is called with "foo", then "bar"
    }
    public function parameterProvider() {
        return [["foo"], ["bar"]];
    }

    @Parameter
    public function otherTest(i:Int) {
        // Parameter is provided from test runner 
    }
}
```


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

Async in flash / js / java targets are nonblocking.


#### Async using PicoTest's own event loop

PicoTest internal async testing support is available for sys targets.
In these targets ```PicoTestAsync``` will use ```Sys.sleep()``` for delayed calls.

Async in sys targets blocks the main thread without handling any event loops.


#### Async using provided event loop

```PicoTestRunner.resume()``` could be called repetitively instead of ```PicoTestRunner.run()```
when you have your own event loop and you want to run tests without multithreading.
```PicoTestRunner.resume()``` returns ```true``` until all tests complete.

In particular, OpenFL on cpp will need this solution
(where OpenFL has its own ```haxe.Timer.delay()``` implementation and some async APIs).


### Async using multithreading

Technically async testing could be done with multithreading.
You can either run PicoTest in its own thread and wait for callback,
or use ```PicoTestRunner.addMainLoop``` to run your main loop until PicoTest has completed.
The difficult part is that threading itself in Haxe is not cross-platform.

Warning: running PicoTest using threads is not officially tested and may contain bugs!

