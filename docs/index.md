<h1>Unit Test Framework Plug-in for DITA-OT</h1>

This is a Unit Testing framework for the DITA Open Toolkit. This plug-in consists of seven DITA-OT transforms and an ANT library:

* Unit Testing
    - The `unit-test` transform allows a user to runs a sequence of `dita` commands and checks that the documents created match the expected output. This is useful for regresssion testing, and confirming that any custom plug-ins do not conflict when upgrading the base DITA-OT engine.
    - The `resource/antlib.xml` library offers a series of convenience methods for creating DITA-OT unit tests.
* Code Coverage
    - The `token-report` transform checks to see if a series of tokens representing all potential output values are covered by unit tests
    - The `xsl-instrument` transform annotates an DITA-OT plug-in to enable code coverage reporting
    - The `xsl-deinstrument` transform removes the instrumentation annotation from a specified plugin
    - The `xsl-report` transform displays which templates have been invoked whilst running unit tests
* ANT Profiling
    - The `antro` transform runs an ANT script profiler against a specified transform and outputs a profiler JSON file
    - The `antro.ui` transform starts up the UI for the ANT script profiler, allowing a user to load a JSON file and interpret the results.