
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

```bash
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
