The unit test framework plug-in has been tested against [DITA-OT 3.0.x](http://www.dita-ot.org/download). It is also compatible with DITA-OT 2.x. but it is still recommended that you upgrade to the latest version. The unit test framework plug-in relies on the use of [AntUnit](http://ant.apache.org/antlibs/antunit/) 1.3 to run tests and ANT junit to create a test report. ANT 1.9+ is recommended.

Installing DITA-OT
------------------

The DITA-OT Unit Test Framework is a plug-in for the DITA Open Toolkit.

-  Install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```bash
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

 Installing the Plug-in
-------------------------

-  Run the plug-in installation command:

```bash
dita -install https://github.com/jason-fox/fox.jason.unit-test/archive/master.zip
```

The `dita` command line tool requires no additional configuration.