Unit Test Framework for DITA-OT
===============================

[![DITA-OT 3,1](https://img.shields.io/badge/DITA--OT-3.1-blue.svg)](http://www.dita-ot.org/3.1)
[![DITA-OT 2.5](https://img.shields.io/badge/DITA--OT-2.5-green.svg)](http://www.dita-ot.org/2.5)
[![Build Status](https://travis-ci.org/jason-fox/fox.jason.unit-test.svg?branch=master)](https://travis-ci.org/jason-fox/fox.jason.unit-test)
[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

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



Table of Contents
=================

- [Install](#install)
  * [Installing DITA-OT](#installing-dita-ot)
  * [Installing the Plug-in](#installing-the-plug-in)
- [Usage](#usage)
  * [Invoking the unit tests from the Command line](#invoking-the-unit-tests-from-the-command-line)
    + [Obtaining a unit test report](#obtaining-a-unit-test-report)
    + [XSLT coverage report](#xslt-coverage-report)
    + [Token coverage report](#token-coverage-report)
    + [Obtaining ANT script profile information](#obtaining-ant-script-profile-information)
    + [Viewing profiler information](#viewing-profiler-information)
    + [Parameter Reference](#parameter-reference)
  * [Integration with Travis CI](#integration-with-travis-ci)
  * [Integration with Coveralls](#integration-with-coveralls)
- [Unit Test File Structure](#unit-test-file-structure)
  * [Test suite files](#test-suite-files)
    + [`bootstrap.xml` file](#bootstrapxml-file)
    + [`coverage.xml` file](#coveragexml-file)
    + [`disabled.txt` file](#disabledtxt-file)
    + [Overrides for `attributes.xml` `colors.xml` and `fonts.xml`](#overrides-for-attributesxml--colorsxml--and-fontsxml)
    + [Overrides for `test.properties`](#overrides-for-testproperties)
  * [Individual test files](#individual-test-files)
- [API](#api)
  * [Compare-Output](#compare-output)
  * [Contains-Text](#contains-text)
  * [Exec-HTML5](#exec-html5)
  * [Exec-PDF](#exec-pdf)
  * [Exec-SVRL](#exec-svrl)
  * [Exec-Transtype](#exec-transtype)
  * [Get-HTML-Article](#get-html-article)
  * [Get-PDF-Article](#get-pdf-article)
- [Contribute](#contribute)
- [License](#license)


Install
=======

The unit test framework plug-in has been tested against [DITA-OT 3.0.x](http://www.dita-ot.org/download). It is also compatible with DITA-OT 2.x. but it is still recommended that you upgrade to the latest version. The unit test framework plug-in relies on the use of [AntUnit](http://ant.apache.org/antlibs/antunit/) 1.3 to run tests and ANT junit to create a test report. ANT 1.9+ is recommended.

Installing DITA-OT
------------------

The DITA-OT Unit Test Framework is a plug-in for the DITA Open Toolkit.

-  Install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```console
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

 Installing the Plug-in
-------------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/fox.jason.unit-test/archive/master.zip
```

The `dita` command line tool requires no additional configuration.



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

### XSLT Coverage Report

To run a XSLT Coverage Report, each DITA-OT Plug-In must be **instrumented** - this annotates the XSLT templates within the plugin to be able to generate coverage information. A copy of each `*.xsl` file is also saved with the `*.orig` suffix.

```console
PATH_TO_DITA_OT/bin/dita -f xsl-instrument -i PATH_TO_PLUG_IN
```

To revert back to the original files just run the de-instrument transform as shown:

```console
PATH_TO_DITA_OT/bin/dita -f xsl-instrument -i PATH_TO_PLUG_IN
```

Once a Plug-In has been **instrumented** the test suite should contain a `template-coverage.xml` file which holds a list of all template decision points. To obtain coverage information, use the `unit-test` transform as stated previously:

```console
PATH_TO_DITA_OT/bin/dita -f unit-test -i PATH_TO_UNIT_TESTS
```

* If the `-i` input directory is a test suite, XSL coverage for that test suite will be reported.
* If the `-i` input directory is not a test suite, XSL coverage for all test suites directly beneath that directory will be reported.

Once the command has run, both a test report file and an XSL coverage report file are created. 
Additionally, if any error occurs, the command will fail.

It is also possible to run XSL coverage over a single test. An individual test can be run directly 
from the command line by running the default target within that test. This can be followed by
direct invocation of the coverage report

```console
ant -f PATH_TO_PLUGIN/test/TEST_NAME/build.xml
PATH_TO_DITA_OT/bin/dita -f xsl-report -i PATH_TO_PLUGIN
```

#### Sample XSL Report

The XSL coverage report will show a schematic of all template decision points, with covered lines
displayed in green, and uncovered lines displayed in red.

![](https://jason-fox.github.io/fox.jason.unit-test/xsl-coverage.png)

### Token Coverage Report

This is a quicker alternative report to XSLT instrumentation and code coverage, but it requires the
developer to create the token `coverage.xml` file manually.
Each test suite should contain a `coverage.xml` file which holds a series of tokens representing all potential output values. To obtain coverage information, use the `test-coverage` transform.

```console
PATH_TO_DITA_OT/bin/dita -f token-report -i PATH_TO_UNIT_TESTS
```

Once the command has run,  a coverage report is created
 
#### Sample Token Report

This is the token report from the example tests found within the plug-in `sample` directory. 

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


For example to test against DITA-OT 3.1 and DITA-OT 2.5.4, use the following `.travis.yml`:

```yml
language: java
jdk:
  - oraclejdk8
env:
  - DITA_OT=3.1
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


Integration with Coveralls
--------------------------

**Coveralls** is a web service to help you track your code coverage over time, and ensure that all your new code is fully covered. More information about how to set up coveralls-travis integration can be found on the [travis website](https://docs.coveralls.io/).

If a plug-in nas been instrumented (using the `xsl-instrument` transform) and unit tests are run, a cobertura style `coverage.xml` file will be created along with the test results and a coverage report.
This can be forwared to Coveralls using the standard maven plug-in as shown:

```yml
language: java
jdk:
  - oraclejdk8
env:
  - DITA_OT=3.1
  - DITA_OT=2.5.4
before_script:
  - zip -r PLUGIN-NAME.zip . -x *.zip* *.git/* *temp/* *out/*
  - curl -LO https://github.com/dita-ot/dita-ot/releases/download/$DITA_OT/dita-ot-$DITA_OT.zip
  - unzip -q dita-ot-$DITA_OT.zip
  - chmod +x dita-ot-$DITA_OT/bin/dita
  - dita-ot-$DITA_OT/bin/dita --install https://github.com/jason-fox/fox.jason.unit-test/archive/master.zip
  - dita-ot-$DITA_OT/bin/dita --install PLUGIN-NAME.zip 
  - dita-ot-$DITA_OT/bin/dita --input dita-ot-$DITA_OT/plugins/PLUGIN-NAME -f xsl-instrument
script:
  - dita-ot-$DITA_OT/bin/dita --input dita-ot-$DITA_OT/plugins/PLUGIN-NAME -f unit-test --output . -v
after_success:
  - cp dita-ot-$DITA_OT/plugins/fox.jason.unit-test/resource/pom.xml pom.xml
  - mvn clean org.eluder.coveralls:coveralls-maven-plugin:report
``` 

Unit Test File Structure
========================

The unit tests are organized in the following manner:

```
├── test-suite-A
│   └── test
│       ├── unit-test-1
│       ├── unit-test-2
│       ├── ... etc
│       ├── bootstrap.xml
│       └── coverage.xml
│ 
├── test-suite-B
│   └── test
│       ├── unit-test-1
│       ├── unit-test-2
│       ├── ... etc
│       ├── bootstrap.xml
│       └── coverage.xml

```

Each suite of tests (identified by a directory called `test`) can be found in a separate directory. Each test within the suite can be found in a separate sub-directory. A `coverage.xml` file should be added to each test suite to enable the framework to calculate coverage.

This structure means that an integration test of multiple plug-ins can be run by adding a `test` directory to each plug-in and invoking the tests as shown:

```console
PATH_TO_DITA_OT/bin/dita --input ./plugins -f unit-test
```

Test suite files
----------------

### `bootstrap.xml` file

At the root of the tests lies a `bootstrap.xml` file which references the `antlib.xml` library as shown:

```xml
<project name="bootstrap.unit-test">
  <dirname property="test.root.dir" file="${ant.file.bootstrap.unit-test}/.." />
  <property name="dita.dir" location="PATH_TO_DITA_OT"/> 
  <typedef file="${dita.dir}/plugins/fox.jason.unit-test/resource/antlib.xml"/>
</project>
```

-  The location of `test.root.dir` must be set - this allows the expecation of a single test to be updated directly from the command line independently of the test harness.
-  The location of `dita.dir` must be set - this allows a single test to be run directly from the command line independently of the test harness.
- The functions from the unit-test `antlib.xml` must be loaded using the `<typedef>` task.



### `coverage.xml` file

A coverage file consists of a list of XML elements or string literals which should be present in a test-suite's outputs. For example, PDF tests should cover all possible fop element and attributes.

```xml
<coverage>
  <text>font-family="STANDARD"</text>
  <text>font-family="STANDARD" font-weight="bold"</text>
  <text>incorrect-xxx</text>
  <element>fo:block</element>
    <element>fo:block font-weight="bold"</element>
    <element>fo:table-column</element>
    <element>fo:table-column column-width</element>
    <element>fo:table-cell</element>
</coverage>
```

### `disabled.txt` file

If a `disabled.txt` file is present within a test suite directory, none of the tests within the directory will be run.

### Overrides for `attributes.xml`  `colors.xml`  and `fonts.xml`

The `cfg` directory of the plug-in holds standard lists of fonts, colors and attributes to replace when running PDF tests - this can be overridden by individuals test or test suites if necessary by placing an equivalent override file in the test directory or test-suite directory.

### Overrides for `test.properties`

Additional test properties can be passed to DITA-OT when each test is run if a `test.properties` file is present in the test directory or test-suite directory. The name of the file to search for can also be altered.
See [Setting build parameters with `.properties` files](http://www.dita-ot.org/3.0/topics/using-dita-properties-file.html) for more details.

Individual test files
---------------------

Each unit test is organized in the following manner:

```
├── build.xml
├── document.ditamap
├── expected.html
├── test.properties (optional)
└── topics
    └── *.dita files

```

- An ANT `build.xml` file to invoke the test
- A `document.ditamap` referring to the individual `*.dita` files
- An optional `test.properties` file if passing any additional properties to DITA-OT
- A test expectation (usually called `expected.html` or `expected.fo`)
- Any further `*.dita` files or source files, graphics etc. required for the test.

The `build.xml` must consist of a single default target, and `import` the `bootstrap.xml` file as shown. The `description` is used within the test report. 

```xml
<project basedir="." default="unit-test">
  <import file="../../bootstrap.xml"/>
  <description>
    Body text should be displayed in the standard font
  </description>
  <target name="unit-test">
      <exec-html5/>
      <get-html-article from="topics/body-text.html"/>
      <compare-output suffix=".html"/>
  </target>
</project>
```

- An individual test can be run directly from the command line by running the default target.
- Adding the comment `<!-- @disabled -->` within the `build.xml` file will disable a test 


API
===

The following ANT tasks are available from the DITA-OT Unit Test Framework

Compare-Output
--------------

#### Description
Fail the test if the test output file does not match the expectation file

#### Parameters
| Attribute   | Description                                       | Required                          |
|-------------|---------------------------------------------------|-----------------------------------|
| expectation | Location of the file that the output should match | No; defaults to `expected.fo`     |
| os          | Only make the comparison if the current operating system is of a given type           | No; defaults to `any`             |
| result      | Location of the file output by the test           | No; defaults to `out/fragment.fo` |
| suffix      | File suffix used by the test expectation          | No; defaults to `.fo`             |

#### Examples

```xml
<compare-output/>
```
compares the file `out/fragment.fo` with `expected.fo` and fails if they do not match.

```xml
<compare-output suffix=".html"/>
```
compares the file `out/fragment.html` with `expected.html` and fails if they do not match.

```xml
<compare-output suffix=".svrl" expectation="expected.svrl.win" os="windows"/>
```
if running on a Windows system, compares the file `out/fragment.svrl` with `expected.svrl.win` and fails if they do not match.

if running on a UNIX system, no comparison is made.


Contains-Text
------------- 

#### Description
Fail the test if the log from the test does not contain the given string

#### Parameters
| Attribute   | Description                                       | Required                            |
|-------------|---------------------------------------------------|-------------------------------------|
| actual      | The text actually output by the test              | No; defaults to output from DITA-OT |
| expected    | The expected fragment of text                     | Yes                                 |
| os          | Only make the comparison if the current operating system is of a given type             | No; defaults to `any`             |


#### Examples

```xml
<contains-text expected="Lorem Ipsum"/>
```
compares the output of DITA-OT and fails if the text "Lorem Ipsum" cannot be found

```xml
<contains-text expected="This is running on Windows" os="windows"/>
```
if running on a Windows system, compares the output of DITA-OT and fails if the text "This is running on Windows" cannot be found

if running on a UNIX system, no comparison is made.


Exec-HTML5
----------

#### Description
Execute the HTML5 DITA-OT transform in verbose mode 
The test will fail if the result was not as expected or took too long

#### Parameters
| Attribute      | Description                                        | Required                          |
|----------------|----------------------------------------------------|-----------------------------------|
| ditamap        | The `*.ditamap` file specifying which topics and other resources to use to create a document  | No; defaults to `document.ditamap`|
| expectedresult | The expected result when invoking the transform    | No; defaults to `0` = success     |
| maxwait        | The maximum time to create a document              | No; defaults to 100 seconds       |
| propertyfile   | The name of a file holding additional properties   | No; defaults to `test.properties` |
| transtype      | The transtype to invoke when creating the document | No; this can be `html5` or any DITA-OT transform that extends `base-html`; defaults to `html5`       |


#### Examples

```xml
<exec-html5 transtype="custom-html"/>
```
runs DITA-OT using the `custom-html` HTML transtype. the output will be placed in the `/out/html` directory


Exec-PDF
--------

#### Description
Execute the PDF DITA-OT transform in verbose mode 

#### Parameters
| Attribute      | Description                                        | Required                          |
|----------------|----------------------------------------------------|-----------------------------------|
| ditamap        | The `*.ditamap` file specifying which topics and other resources to use to create a document  | No; defaults to `document.ditamap`|
| expectedresult | The expected result when invoking the transform    | No; defaults to `0` = success     |
| maxwait        | The maximum time to create a document              | No; defaults to 100 seconds       |
| propertyfile   | The name of a file holding additional properties   | No; defaults to `test.properties` |
| transtype      | The transtype to invoke when creating the document | No; this can be `pdf2` or any DITA-OT transform that extends `pdf2`; defaults to `pdf2`        |

#### Examples

```xml
<exec-pdf transtype="custom-pdf"/>
```
runs DITA-OT using the `custom-pdf` PDF transtype. `topic.fo` and `document.pdf` will be placed in the `/out` directory

Exec-SVRL
---------

#### Description
Execute the HERE Validator SVRL DITA-OT transform in verbose mode.
The test will fail if the result was not as expected or took too long.

#### Parameters
| Attribute      | Description                                        | Required                          |
|----------------|----------------------------------------------------|-----------------------------------|
| ditamap        | The `*.ditamap` file specifying which topics and other resources to use to create a document  | No; defaults to `document.ditamap`|
| expectedresult | The expected result when invoking the transform    | No; defaults to `0` = success     |
| maxwait        | The maximum time to create a document              | No; defaults to 100 seconds       |
| propertyfile   | The name of a file holding additional properties   | No; defaults to `test.properties` |
| transtype      | The transtype to invoke when creating the document | No; this can be `svrl` or any DITA-OT transform that extends `svrl`; defaults to `svrl`       |


#### Examples

```xml
<exec-svrl transtype="text-rules"/>
```
runs DITA-OT using the `text-rules` SVRL transtype

```xml
<exec-svrl transtype="svrl-echo" expectedresult="1"/>
```
runs DITA-OT using the `svrl-echo` SVRL transtype - the invocation is expected to fail with validation errors.

Exec-Transtype
--------------

#### Description
Execute an arbitrary DITA-OT transform in verbose mode.
The test will fail if the result was not as expected or took too long.

#### Parameters
| Attribute      | Description                                        | Required                          |
|----------------|----------------------------------------------------|-----------------------------------|
| ditamap        | The `*.ditamap` file specifying which topics and other resources to use to create a document  | No; defaults to `document.ditamap`|
| expectedresult | The expected result when invoking the transform    | No; defaults to `0` = success     |
| maxwait        | The maximum time to create a document              | No; defaults to 100 seconds       |
| propertyfile   | The name of a file holding additional properties   | No; defaults to `test.properties` |
| transtype      | The transtype to invoke when creating the document | No; this can be `svrl` or any DITA-OT transform that extends `svrl`; defaults to `svrl`       |

#### Examples

```xml
<exec-svrl transtype="custom"/>
```
runs DITA-OT using the `custom` transtype

```xml
<exec-svrl transtype="custom" expectedresult="1"/>
```
runs DITA-OT using the `custom` SVRL transtype - the invocation is expected to fail.


Get-HTML-Article
----------------

#### Description
Loads a given HTML file and extracts the first `<article>` element  (which corresponds to a DITA topic) for further examination.

#### Parameters
| Attribute   | Description                                            | Required                      |
|-------------|--------------------------------------------------------|-------------------------------|
| dir         | Location of the files output by the test               | No; defaults to `out/html`    |
| from        | the name of  the file to extract an HTML fragment from | Yes                           |
| to          | Location of the output file holding the fragment of HTML to test | No; defaults to `out/fragment.html`|


#### Examples

```xml
<get-html-article from="topics/body-text.html"/>
```
creates a file called `fragment.html` holding the `<article>` element from the `topics/body-text.html` file.

Get-PDF-Article
---------------

#### Description
Loads a given `topic.fo` file and extracts the last `fo.flow` element (which corresponds to a DITA topic) for further examination. Also remove colors, fonts and excess attributes

#### Parameters
| Attribute   | Description                                            | Required                       |
|-------------|--------------------------------------------------------|--------------------------------|
| from        | Location of  the file to extract an HTML fragment from | No; defaults to `out/topic.fo` |
| to          | Location of the output file holding the fragment of FOP to test | No; defaults to `out/fragment.fo`  |

#### Examples

```xml
<get-pdf-article/>
```
creates a file called `fragment.fo` holding the final `<fo.flow>` element from the `topics.fo` file.

Contribute
==========

PRs accepted.

License
=======

[Apache 2.0](LICENSE) © 2018 Jason Fox

The Program includes the following additional software components which were obtained under license:

* ant-antunit.jar - https://ant.apache.org/antlibs/antunit/ - **Apache 2.0 license**
* ant-contrib.jar - http://ant-contrib.sourceforge.net/ - **Apache 2.0 license**
* ant-junit.jar - https://ant.apache.org/ - **Apache 2.0 license**
* xmltask.jar - http://www.oopsconsultancy.com/software/xmltask/ - **Apache 1.1 license**
* antro.jar - https://github.com/jkff/antro/ - **Gnu General Public License 3**
* swingx-2008_03_09.jar - http://swingx.dev.java.net/  - **Gnu General Public License 3**
* json.jar-  http://www.json.org/  - **Gnu General Public License 3**

