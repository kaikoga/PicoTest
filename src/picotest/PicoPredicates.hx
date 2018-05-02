package picotest;

/**
	Static class containing predicates for assertions of PicoTest.
**/
import picotest.matcher.predicates.HexPredicate;

class PicoPredicates {
	public static function hex(value:Int):HexPredicate return new HexPredicate(value);
}
