package picotest.spawners.http;

typedef PicoHttpServerSetting = {
	port:Int,
	?files:Map<String, String>,
	?docRoot:String
}

