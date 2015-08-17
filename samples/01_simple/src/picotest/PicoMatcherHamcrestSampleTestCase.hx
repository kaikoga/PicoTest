package picotest;

import org.hamcrest.Matchers.*;

import picotest.PicoAssert.*;

/**
	Example using PicoMatcher.
*/
class PicoMatcherHamcrestSampleTestCase {

	public function testHamcrestMatch() {
		assertMatch(equalTo(1), 1);
		assertMatch(equalTo(true), true);
		assertMatch(equalTo([1, 2]), [1, 2]);
		assertMatch(equalTo(TestEnum.Default), TestEnum.Default);
		assertMatch(equalTo(TestEnum.Some(1)), TestEnum.Some(1));
		assertMatch(greaterThan(1), 2);
		assertMatch([greaterThan(2), lessThan(2)], [1, 3]);
		assertMatch({a:greaterThan(2), b:lessThan(2)}, {a:1, b:3});
	}

	public function testHamcrestMatchFail() {
		assertMatch(equalTo(2), 1);
		assertMatch(equalTo(false), true);
		assertMatch(equalTo([3, 4]), [1, 2]);
		assertMatch(equalTo(TestEnum.Another), TestEnum.Default);
		assertMatch(equalTo(TestEnum.Some(2)), TestEnum.Some(1));
		assertMatch(greaterThan(2), 1);
		assertMatch([greaterThan(2), lessThan(2)], [3, 1]);
		assertMatch([greaterThan(2), greaterThan(2)], [3]);
		assertMatch([greaterThan(2)], [3]);
		assertMatch({a:greaterThan(2), b:lessThan(2)}, {a:3, b:1});
		assertMatch({a:greaterThan(2)}, cast {});
	}

}
