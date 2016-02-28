package picotest.out;

#if macro
typedef PicoTestOutput = PicoTestMacroOutput;
#elseif (sys && picotest_remote)
typedef PicoTestOutput = PicoTestSysRemoteOutput;
#elseif (js && picotest_remote)
typedef PicoTestOutput = PicoTestJsRemoteOutput;
#elseif flash
typedef PicoTestOutput = PicoTestFlashOutput;
#elseif js
typedef PicoTestOutput = PicoTestJsOutput;
#elseif sys
typedef PicoTestOutput = PicoTestSysOutput;
#end
