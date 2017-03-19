package picotest.matcher.patterns.standard;

import picotest.matcher.PicoMatchResult.PicoMatchComponent;

class PicoMatchStruct implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		var eFields:Array<String> = Reflect.fields(expected);
		var aFields:Array<String> = Reflect.fields(actual);
		eFields.sort(Reflect.compare);
		aFields.sort(Reflect.compare);
		var mismatches:Array<PicoMatchComponent> = [];
		var eJoin:String = eFields.join(",");
		var aJoin:String = aFields.join(",");
		if (eJoin != aJoin) mismatches.push(PicoMatchComponent.MismatchAt('[]', '{${eJoin}}', '{${aJoin}}'));
		for (field in eFields) {
			var e:Dynamic = Reflect.field(expected, field);
			var a:Dynamic = Reflect.field(actual, field);
			switch (context.match(e, a)) {
				case PicoMatchResult.Unknown, PicoMatchResult.Match:
				case PicoMatchResult.Mismatch(e, a): mismatches.push(PicoMatchComponent.MismatchAt('.$field', e, a));
				case PicoMatchResult.MismatchDesc(e, d): mismatches.push(PicoMatchComponent.MismatchDescAt('.$field', e, d));
				case PicoMatchResult.Complex(a): mismatches.push(PicoMatchComponent.ComplexAt('.$field', a));
			}
		}
		return mismatches.length == 0 ? PicoMatchResult.Match : PicoMatchResult.Complex(mismatches);
	}
}
