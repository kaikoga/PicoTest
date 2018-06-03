package picotest.spawners.http;

typedef PicoHttpServerSetting = {
	port:String,
	?files:Map<String, String>,
	?docRoot:String
}

