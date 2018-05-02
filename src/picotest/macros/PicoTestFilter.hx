package picotest.macros;

class PicoTestFilter {

	private var classNamePattern:EReg;

	public function new(pattern:String) {
		this.classNamePattern = new EReg(pattern, "");
	}

	public function match(className:String):Bool {
		return this.classNamePattern.match(className);
	}

	private static var filters:Array<PicoTestFilter>;

	#if macro
	private static var patterns:Array<String> = [];

	inline public static function addPattern(pattern:String):Void patterns.push(pattern);

	public static function readFromFile(fileName:String):Void {
		for (line in ~/[\r\n]/g.split(sys.io.File.getContent(fileName))) {
			var l:String = StringTools.trim(line);
			if (l != "" && line.charAt(0) != "#") addPattern(line);
		}
	}

	inline private static function loadPatterns():Array<String> return patterns;
	#else
	inline private static function loadPatterns():Array<String> return macroLoadPatterns();
	#end

	macro private static function macroLoadPatterns() return macro $v{patterns};

	private static function getFilters():Array<PicoTestFilter> {
		if (filters == null) filters = loadPatterns().map(function(pattern) return new PicoTestFilter(pattern));
		return filters;
	}

	public static function filter(className:String):Bool {
		var filters:Array<PicoTestFilter> = getFilters();
		if (filters.length == 0) return true;
		for (filter in filters) {
			if (filter.match(className)) return true;
		}
		return false;
	}
}
