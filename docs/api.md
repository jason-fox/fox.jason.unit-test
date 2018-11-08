
<h1>Unit Testing ANT Tasks</h1>


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
