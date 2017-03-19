package picotest.matcher;

enum PicoMatchResult {
	Unknown;
	Match;
	Mismatch(expected:String, actual:String);
	MismatchDesc(expected:String, description:String);
	Complex(array:Array<PicoMatchComponent>);
}

enum PicoMatchComponent {
	MismatchAt(path:String, expected:String, actual:String);
	MismatchDescAt(path:String, expected:String, description:String);
	ComplexAt(path:String, array:Array<PicoMatchComponent>);
}
