# Compiler Defines

## Cross

- ```-D picotest_dryrun``` marks every test method as "dry run" and log which tests were to be run.
- ```-D picotest_safe_mode``` treats test target objects "dangerous",
and avoid calling methods of test object (like ```toString()```) to prevent infinite loops (Yes, they will happen! see [HaxeFoundation/haxe#4398](https://github.com/HaxeFoundation/haxe/issues/4398)).
As a downside, test output will likely lose some readablility.
- ```-D picotest_show_stack``` Prints more call stack info. Will be truncated if too long.
- ```-D picotest_show_ignore``` Also prints ignored tests.
- ```-D picotest_show_trace``` ```trace()``` calls are suppressed by default. Also prints ```trace()``` calls when enabled.
- ```-D picotest_nodep``` Remove hamcrest supports.
- ```-D picotest_thread``` Tries to use multithread version of PicoTestAsync in sys platforms.
- ```-D picotest_report_dir``` Path to output test report file (default ```bin/report```)
- ```-D picotest_junit``` Path to output JUnit XML file
- ```-D picotest_tag``` Identifier to distinguish multiple invocations of PicoTest, especially useful with JUnit output
- ```-D picotest_filter``` Adds test class filter, separated by commas.


## Internal

- ```-D picotest_remote``` marked when is test results is retrieved through HTTP (otherwise through stdout) 
- ```-D picotest_report_json``` output report file (used internally by ```PicoTest.warn()```)


## Flash

- ```-D picotest_fp``` Path to executable of Flash Player (default per OS)
- ```-D picotest_flog``` Path to flashlog.txt (default per OS)


## JavaScript

- ```-D picotest_browser``` Specify browser to run tests in (TODO)
- ```-D picotest_remote_port``` Local port range to receive test result from browser (default ```49152-61000```)


