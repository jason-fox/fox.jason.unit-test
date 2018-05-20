
Usage
=====

Invoking the unit tests from the Command line
---------------------------------------------

A series of test suites can be found within the plug-in at `PATH_TO_DITA_OT/plugins/fox.jason.unit-test/sample`

### Obtaining a unit test report

To run, use the `unit-test` transform.

```console
PATH_TO_DITA_OT/bin/dita -f unit-test  -o out -i PATH_TO_UNIT_TESTS
```

Once the command has run, a test report file is created. 
Additionally, if any error occurs, the command will fail.

**Sample Test Report**
This is the test report from the example tests found within the plug-in `sample` directory. Nine tests are run over two test suites (PDF and HTML processing) - a third test suite has been disabled.
![enter image description here](https://jason-fox.github.io/fox.jason.unit-test/results.png)

* If the `-i` input directory is a test suite, all tests within the suite will be run.
* If the `-i` input directory is not a test suite, all test suites directly beneath that directory will be run.


### Obtaining coverage information

Each test suite should contain a `coverage.xml` file which holds a series of tokens representing all potential output values. To obtain coverage information, use the `test-coverage` transform.

```console
PATH_TO_DITA_OT/bin/dita -f test-coverage -i PATH_TO_UNIT_TESTS
```

Once the command has run,  a coverage report is created
 
 **Sample Test Report**
This is the test report from the example tests found within the plug-in `sample` directory. 

* Coverage for the Spell-checker is looking to ensure that all rules have been run. Uncovered rules are highlighted in RED.
* Coverage for HTML processing is looking for the presence of `<codeph>`,  `<codeblock>` and `<p>` tags being rendered in the tests. 

![enter image description here](https://jason-fox.github.io/fox.jason.unit-test/coverage.png)

* If the `-i` input directory is a test suite, coverage for that test suite will be reported.
* If the `-i` input directory is not a test suite, coverage for all test suites directly beneath that directory will be reported.


### Obtaining ANT script profile information

**Antro** is a hierarchical and line-level profiler for Ant build scripts. It can be run to check which ANT scripts have been invoked and how long they took.

To obtain profile information, use the `antro` transform and supply an additional test transtype

```console
PATH_TO_DITA_OT/bin/dita -f antro --test.transform=TRANSFORM_TO_PROFILE -i document.ditamap
```
A profiler JSON file will be generated.

### Viewing profiler information

To run the UI for the  Antro profiler, use the `antro-ui` transform. The `-i` parameter is mandatory for all DITA-OT plug-ins, and should point to a real file, but is not used for this transform.

```console
PATH_TO_DITA_OT/bin/dita -f antro-ui -i document.ditamap
```
The Antro UI  is the displayed, load the profiler json file from to display a bar graph showing how long each ANT target took:

**Sample Antro Display**
The Profiler was run against the `pdf` transform, FOP processing took 16s
![](https://jason-fox.github.io/fox.jason.unit-test/profiler-bar.png)


You can drill down to an individual line to see if it has been invoked and how long it took:
![](https://jason-fox.github.io/fox.jason.unit-test/profiler.png)

### Parameter Reference

- `test.colorize` - When set, successes and failures are output highlighted using ANSI color codes
- `test.copy` - Specifies whether regenerated expecations should be copied. Default is `false`
- `test.transtype` - The real transtype to run the antro profiler against
- `test.propertyfile` - A properties file to use when running the unit tests or antro profiler


Integration with Travis CI
--------------------------

**Travis CI** is a hosted, distributed continuous integration service used to build and test software projects hosted at GitHub. More information about how to set up travis integration can be found on the [travis website](https://docs.travis-ci.com/).

For automated testing of DITA-OT plug-ins, place your tests under a `test` directory under the root
of the repository along with the `.travis.yml` in the root itself.


For example to test against DITA-OT 3.0.3 and DITA-OT 2.5.4, use the following `.travis.yml`:

```yml
language: java
jdk:
  - oraclejdk8
env:
  - DITA_OT=3.0.3
  - DITA_OT=2.5.4
before_script:
  - zip -r PLUGIN-NAME.zip . -x *.zip* *.git/* *temp/* *out/*
  - curl -LO https://github.com/dita-ot/dita-ot/releases/download/$DITA_OT/dita-ot-$DITA_OT.zip
  - unzip -q dita-ot-$DITA_OT.zip
  - mv dita-ot*/ dita-ot/
  - chmod +x dita-ot/bin/dita
  - dita-ot/bin/dita --install https://github.com/jason-fox/fox.jason.unit-test/archive/master.zip
  - dita-ot/bin/dita --install PLUGIN-NAME.zip 
script:
  - dita-ot/bin/dita --input dita-ot/plugins/PLUGIN-NAME -f unit-test -v
```

This will do the following:

* Zip up the files in the plugin under test
* install the specified DITA-OT version
* install the unit-testing framework (repeat this for other dependencies)
* install the plugin under test
* Run the tests

Unit tests will be run whenever a commit occurs.

The output will appear within the log as follows:

```console
[UNIT002I][INFO] Running tests for 'PLUGIN-NAME'
  [antunit] Build File: /tmp/temp20180420185923919/unit-test/fixtures/PLUGIN-NAME/fixture.xml
  [antunit] Tests run: 3, Failures: 0, Errors: 0, Time elapsed: 31.063 sec
  [antunit] Target: test:    Expect that ...  took 7.202 sec
  [antunit] Target: test:    Expect that ...  took 17.596 sec
...etc

[SUCCESS] All tests have passed
dita2unit-test:
clean-temp:
The command "dita-ot/bin/dita --input dita-ot/plugins/PLUGIN-NAME -f unit-test -v" exited with 0.
```
