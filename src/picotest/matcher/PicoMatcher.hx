package picotest.matcher;

import picotest.matcher.patterns.PicoMatchCustom;
import picotest.matcher.patterns.PicoMatchMany;
import picotest.matcher.patterns.PicoMatchStandard;
import picotest.matcher.PicoMatchResult.PicoMatchComponent;

/**
	Does structure based matching.
**/
class PicoMatcher implements IPicoMatcherComponent {

	private var matcher:PicoMatchMany;

	public function new():Void {
		this.matcher = new PicoMatchMany();
	}

	/**
		Adds a matching rule to this `PicoMatcher`.
	**/
	public function prepend(matcher:IPicoMatcherComponent):Void {
		this.matcher.prepend(matcher);
	}

	/**
		Adds a matching rule to this `PicoMatcher`.
	**/
	public function append(matcher:IPicoMatcherComponent):Void {
		this.matcher.append(matcher);
	}

	/**
		Adds a matching rule to this `PicoMatcher`.
	**/
	public function prependMatcher(matcher:PicoMatcherContext->Dynamic->Dynamic->PicoMatchResult):Void {
		this.matcher.prepend(new PicoMatchCustom(matcher));
	}

	/**
		Adds a matching rule to this `PicoMatcher`.
	**/
	public function appendMatcher(matcher:PicoMatcherContext->Dynamic->Dynamic->PicoMatchResult):Void {
		this.matcher.append(new PicoMatchCustom(matcher));
	}

	/**
		Executes structure based matching using this `PicoMatcher`. Result is guaranteed to be not Unknown.
	**/
	public function match(expected:Dynamic, actual:Dynamic):PicoMatchResult {
		return new PicoMatcherContext(this).match(expected, actual);
	}

	/**
		Attempts structure based matching using this `PicoMatcher`.
	**/
	@:noDoc
	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		return this.matcher.tryMatch(context, expected, actual);
	}

	/**
		Print a `MatchResult` as String.
	**/
	public static function printMatchResult(result:PicoMatchResult):String {
		switch (result) {
			case PicoMatchResult.Unknown, PicoMatchResult.Match:
				return null;
			case PicoMatchResult.Mismatch(e, a):
				return '  - expected ${e} but was ${a}';
			case PicoMatchResult.MismatchDesc(e, d):
				return '  - expected ${e} but ${d}';
			case PicoMatchResult.Complex(a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, "*"));
				return m.join('\n');
		}
	}

	/**
		Print a `MatchComponent` which is at given `path` as String.
	**/
	private static function printMatchComponent(comp:PicoMatchComponent, path:String = ""):String {
		switch (comp) {
			case PicoMatchComponent.MismatchAt(p, e, a):
				return '  - ${path + p} expected ${e} but was ${a}';
			case PicoMatchComponent.MismatchDescAt(p, e, d):
				return '  - ${path + p} expected ${e} but ${d}';
			case PicoMatchComponent.ComplexAt(p, a):
				var m:Array<String> = [];
				for (comp in a) m.push(printMatchComponent(comp, '${path + p}'));
				return m.join('\n');
		}
	}

	/**
		Constructs a `PicoMatcher` instance with standard matching rules.
	**/
	public static function standard():PicoMatcher {
		var result:PicoMatcher = new PicoMatcher();
		result.matcher.append(new PicoMatchStandard());
		return result;
	}
}

