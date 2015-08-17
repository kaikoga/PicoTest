package picotest;

/**
	Does structure based matching.
**/
class PicoMatcher {

	private var matchers:Array<PicoMatcher->Dynamic->Dynamic->MatchResult>;

	public function new():Void {
		this.matchers = [];
	}

	public function addMatcher(matcher:PicoMatcher->Dynamic->Dynamic->MatchResult):Void {
		this.matchers.push(matcher);
	}

	public function match(expected:Dynamic, actual:Dynamic):MatchResult {
		for (matcher in this.matchers) {
			var match:MatchResult = matcher(this, expected, actual); 
			switch (match) {
				case MatchResult.Unknown:
					continue;
				case MatchResult.Match, MatchResult.Mismatch(_,_), MatchResult.Complex(_):
					return match;
			}
		}
		return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
	}

	public static function matchInt(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Int) && Std.is(actual, Int)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchFloat(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Float) && Std.is(actual, Float)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchBool(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Bool) && Std.is(actual, Bool)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchString(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, String) && Std.is(actual, String)) {
			return expected == actual ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchEnum(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Reflect.isEnumValue(expected) && Reflect.isEnumValue(actual)) {
			return Type.enumEq(expected, actual) ? MatchResult.Match : MatchResult.Mismatch(Std.string(expected), Std.string(actual));
		}
		return MatchResult.Unknown;
	}

	public static function matchArray(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
		if (Std.is(expected, Array) && Std.is(actual, Array)) {
			var e:Array<Dynamic> = cast expected;
			var a:Array<Dynamic> = cast actual;
			var mismatches:Array<MatchComponent> = [];
			if (e.length != a.length) mismatches.push(MatchComponent.MismatchAt('[]', '[${e.length}]', '[${a.length}]'));
			var c:Int = e.length > a.length ? e.length : a.length;
			for (i in 0...c) {
				switch (matcher.match(e[i], a[i])) {
					case Unknown, Match:
					case Mismatch(e, a): mismatches.push(MatchComponent.MismatchAt('[$i]', e, a));
					case Complex(a): mismatches.push(MatchComponent.ComplexAt('[$i]', a));
				}
			}
			return mismatches.length == 0 ? MatchResult.Match : MatchResult.Complex(mismatches);
		}
		return MatchResult.Unknown;
	}

	public static function matchStruct(matcher:PicoMatcher, expected:Dynamic, actual:Dynamic):MatchResult {
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
			switch (matcher.match(e, a)) {
				case Unknown, Match:
				case Mismatch(e, a): mismatches.push(MatchComponent.MismatchAt('.$field', e, a));
				case Complex(a): mismatches.push(MatchComponent.ComplexAt('.$field', a));
			}
		}
		return mismatches.length == 0 ? MatchResult.Match : MatchResult.Complex(mismatches);
	}

	public static function printMatchResult(result:MatchResult):String {
		switch (result) {
			case Unknown, Match:
				return null;
			case Mismatch(e, a):
				return '  - expected ${e} but was ${a}';
			case Complex(a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, "*"));
				return m.join('\n');
		}
	}

	public static function printMatchComponent(comp:MatchComponent, path:String = ""):String {
		switch (comp) {
			case MismatchAt(p, e, a):
				return '  - ${path + p} expected ${e} but was ${a}';
			case ComplexAt(p, a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, '${path + p}'));
				return m.join('\n');
		}
	}

	public static function standard():PicoMatcher {
		var matcher:PicoMatcher = new PicoMatcher();
		matcher.addMatcher(PicoMatcher.matchInt);
		matcher.addMatcher(PicoMatcher.matchFloat);
		matcher.addMatcher(PicoMatcher.matchBool);
		matcher.addMatcher(PicoMatcher.matchString);
		matcher.addMatcher(PicoMatcher.matchEnum);
		matcher.addMatcher(PicoMatcher.matchArray);
		matcher.addMatcher(PicoMatcher.matchStruct);
		return matcher;
	}
}

enum MatchResult {
	Unknown;
	Match;
	Mismatch(expected:String, actual:String);
	Complex(array:Array<MatchComponent>);
}

enum MatchComponent {
	MismatchAt(path:String, expected:String, actual:String);
	ComplexAt(path:String, array:Array<MatchComponent>);
}
