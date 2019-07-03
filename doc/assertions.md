# Assertions

Basic assertions are defined in ```picotest.PicoAssert```.
PicoTest assertion failure will continue running the test and tries to output as much failures as possible. 

```haxe
public function test() {
    assertTrue(false);
    assertTrue(false);
}
```

This test method emits 1 test failure and 2 assertion failures. 


## Structure Based Matching Support 

```picotest.PicoAssert.assertMatch(expected, actual, ?message, ?matcher, ?p)```
triggers structure based matching.

When ```matcher``` is not provided, all elements of arrays and anonymous structures are recursively matched,
and any mismatch is reported in the failure output.
When you need to define your own matching rules,
you can also create your own ```PicoMatcher``` and pass it as ```matcher``` argument.

For example,

```haxe
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


## Predicates

Structure based matching patterns accepts predicate objects, which alters matching conditions or result outputs.
Predicates should be provided as the ```expected``` of ```picotest.PicoAssert.assertMatch()```.

See ```PicoMatcherPredicateSampleTestCase``` for more examples.


## Hamcrest Support

DEPRECATED: Hamcrest support is deprecated and could be removed in future versions of PicoTest.

To have complex assertions, PicoTest and structured based matching has Hamcrest support. 
```picotest.PicoAssert.assertThat()``` actually doesn't throw any errors,
so you can have more assertion failures just as basic assertions of PicoTest.

Note: ```picotest.PicoAssert.assertThat()``` conflicts with ```org.hamcrest.Matchers.assertThat()```.
To use PicoTest version of ```assertThat()```, ```import picotest.PicoAssert.*;``` should be later.
(see ```HamcrestSampleTestCase``` for example)

You can also provide Hamcrest matchers in structure based matching.
Reverse is impossible; Hamcrest matchers cannot recognize structure based matchings or predicates.

See ```PicoMatcherHamcrestSampleTestCase``` for more examples.

```-D picotest_nodep``` will remove hamcrest supports.
