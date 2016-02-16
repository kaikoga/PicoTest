package picotest;

#if !picotest_nodep
import org.hamcrest.Matcher;
import org.hamcrest.StringDescription;
#end

/**
	Does structure based matching.
**/
class PicoMatcher {

	private var matchers:Array<PicoMatcher->Array<Dynamic>->Dynamic->Dynamic->MatchResult>;

	public function new():Void {
		this.matchers = [];
	}

	/**
		Adds a matching rule to this `PicoMatcher`.
	**/
	public function addMatcher(matcher:PicoMatcher->Array<Dynamic>->Dynamic->Dynamic->MatchResult):Void {
		this.matchers.push(matcher);
	}

	/**
		Executes structure based matching using this `PicoMatcher`.
	**/
	public function match(expected:Dynamic, actual:Dynamic):MatchResult {
		return matchInternal([], expected, actual);
	}

	private function matchInternal(matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		for (matcher in this.matchers) {
			var match:MatchResult = matcher(this, matched, expected, actual);
			switch (match) {
				case MatchResult.Unknown:
					continue;
				case MatchResult.Match, MatchResult.Mismatch(_,_), MatchResult.MismatchDesc(_,_), MatchResult.Complex(_):
					return match;
			}
		}
		return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
	}

	public static function matchNull(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (expected == null || actual == null) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchInt(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Int) && Std.is(actual, Int)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchFloat(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Float) && Std.is(actual, Float)) {
			return (expected == actual || (Math.isNaN(expected) && Math.isNaN(actual))) ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchBool(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Bool) && Std.is(actual, Bool)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchString(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, String) && Std.is(actual, String)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchEnum(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Reflect.isEnumValue(expected) && Reflect.isEnumValue(actual)) {
			return Type.enumEq(expected, actual) ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchCircular(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		for (ea in matched) {
			var e:Dynamic = ea[0];
			var a:Dynamic = ea[1];
			if (expected == e && actual == a) {
				return MatchResult.Match;
			} else if (expected == e || actual == a) {
				return MatchResult.Mismatch(Std.string(expected), Std.string(actual));
			}
		}
		matched.push([expected, actual]);
		return MatchResult.Unknown;
	}

	public static function matchArray(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Array) && Std.is(actual, Array)) {
			var e:Array<Dynamic> = cast expected;
			var a:Array<Dynamic> = cast actual;
			var mismatches:Array<MatchComponent> = [];
			if (e.length != a.length) mismatches.push(MatchComponent.MismatchAt('[]', '[${e.length}]', '[${a.length}]'));
			var c:Int = e.length > a.length ? e.length : a.length;
			for (i in 0...c) {
				switch (matcher.matchInternal(matched, e[i], a[i])) {
					case MatchResult.Unknown, MatchResult.Match:
					case MatchResult.Mismatch(e, a): mismatches.push(MatchComponent.MismatchAt('[$i]', e, a));
					case MatchResult.MismatchDesc(e, d): mismatches.push(MatchComponent.MismatchDescAt('[$i]', e, d));
					case MatchResult.Complex(a): mismatches.push(MatchComponent.ComplexAt('[$i]', a));
				}
			}
			return mismatches.length == 0 ? MatchResult.Match : MatchResult.Complex(mismatches);
		}
		return MatchResult.Unknown;
	}

	public static function matchStruct(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		var eFields:Array<String> = Reflect.fields(expected);
		var aFields:Array<String> = Reflect.fields(actual);
		eFields.sort(function(a, b) return Reflect.compare(a, b));
		aFields.sort(function(a, b) return Reflect.compare(a, b));
		var mismatches:Array<MatchComponent> = [];
		var eJoin:String = eFields.join(",");
		var aJoin:String = aFields.join(",");
		if (eJoin != aJoin) mismatches.push(MatchComponent.MismatchAt('[]', '{${eJoin}}', '{${aJoin}}'));
		for (field in eFields) {
			var e:Dynamic = Reflect.field(expected, field);
			var a:Dynamic = Reflect.field(actual, field);
			switch (matcher.matchInternal(matched, e, a)) {
				case MatchResult.Unknown, MatchResult.Match:
				case MatchResult.Mismatch(e, a): mismatches.push(MatchComponent.MismatchAt('.$field', e, a));
				case MatchResult.MismatchDesc(e, d): mismatches.push(MatchComponent.MismatchDescAt('.$field', e, d));
				case MatchResult.Complex(a): mismatches.push(MatchComponent.ComplexAt('.$field', a));
			}
		}
		return mismatches.length == 0 ? MatchResult.Match : MatchResult.Complex(mismatches);
	}

	#if !picotest_nodep
	public static function matchMatcher<T>(matcher:PicoMatcher, matched:Array<Dynamic>, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Matcher))  {
			var matcher:Matcher<T> = expected;
			if (!matcher.matches(actual))
			{
				var e:StringDescription = new StringDescription();
				e.appendDescriptionOf(matcher);
				var a:StringDescription = new StringDescription();
				matcher.describeMismatch(actual, a);
				return MatchResult.MismatchDesc(e.toString(), a.toString());
			}
			return MatchResult.Match;
		}
		return MatchResult.Unknown;
	}
	#end

	/**
		Print a `MatchResult` as String.
	**/
	public static function printMatchResult(result:MatchResult):String {
		switch (result) {
			case MatchResult.Unknown, MatchResult.Match:
				return null;
			case MatchResult.Mismatch(e, a):
				return '  - expected ${e} but was ${a}';
			case MatchResult.MismatchDesc(e, d):
				return '  - expected ${e} but ${d}';
			case MatchResult.Complex(a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, "*"));
				return m.join('\n');
		}
	}

	/**
		Print a `MatchComponent` which is at given `path` as String.
	**/
	public static function printMatchComponent(comp:MatchComponent, path:String = ""):String {
		switch (comp) {
			case MatchComponent.MismatchAt(p, e, a):
				return '  - ${path + p} expected ${e} but was ${a}';
			case MatchComponent.MismatchDescAt(p, e, d):
				return '  - ${path + p} expected ${e} but ${d}';
			case MatchComponent.ComplexAt(p, a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, '${path + p}'));
				return m.join('\n');
		}
	}

	/**
		Populate this `PicoMatcher` instance with standard matching rules.
		Note that any matching rules added after call to this method is ignored.
	**/
	public function withStandard():PicoMatcher {
		#if !picotest_nodep
		this.addMatcher(PicoMatcher.matchMatcher);
		#end
		this.addMatcher(PicoMatcher.matchNull);
		this.addMatcher(PicoMatcher.matchInt);
		this.addMatcher(PicoMatcher.matchFloat);
		this.addMatcher(PicoMatcher.matchBool);
		this.addMatcher(PicoMatcher.matchString);
		this.addMatcher(PicoMatcher.matchEnum);
		this.addMatcher(PicoMatcher.matchCircular);
		this.addMatcher(PicoMatcher.matchArray);
		this.addMatcher(PicoMatcher.matchStruct);
		return this;
	}

	/**
		Constructs a `PicoMatcher` instance with standard matching rules.
	**/
	public static function standard():PicoMatcher {
		return new PicoMatcher().withStandard();
	}
}

enum MatchResult {
	Unknown;
	Match;
	Mismatch(expected:String, actual:String);
	MismatchDesc(expected:String, description:String);
	Complex(array:Array<MatchComponent>);
}

enum MatchComponent {
	MismatchAt(path:String, expected:String, actual:String);
	MismatchDescAt(path:String, expected:String, description:String);
	ComplexAt(path:String, array:Array<MatchComponent>);
}
