package picotest.matcher.patterns.standard;

import picotest.matcher.PicoMatchResult.PicoMatchComponent;

class PicoMatchArray implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, Array) && Std.is(actual, Array)) {
			var e:Array<Dynamic> = cast expected;
			var a:Array<Dynamic> = cast actual;
			var mismatches:Array<PicoMatchComponent> = [];
			if (e.length != a.length) mismatches.push(PicoMatchComponent.MismatchAt('[]', '[${e.length}]', '[${a.length}]'));
			var c:Int = e.length > a.length ? e.length : a.length;
			for (i in 0...c) {
				switch (context.match(e[i], a[i])) {
					case PicoMatchResult.Unknown, PicoMatchResult.Match:
					case PicoMatchResult.Mismatch(e, a): mismatches.push(PicoMatchComponent.MismatchAt('[$i]', e, a));
					case PicoMatchResult.MismatchDesc(e, d): mismatches.push(PicoMatchComponent.MismatchDescAt('[$i]', e, d));
					case PicoMatchResult.Complex(a): mismatches.push(PicoMatchComponent.ComplexAt('[$i]', a));
				}
			}
			return mismatches.length == 0 ? PicoMatchResult.Match : PicoMatchResult.Complex(mismatches);
		}
		return PicoMatchResult.Unknown;
	}
}
