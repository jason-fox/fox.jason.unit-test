Unit Test Framework for DITA-OT
===============================

[![DITA-OT 3,0](https://img.shields.io/badge/DITA--OT-3.0-blue.svg)](http://www.dita-ot.org/3.0/)
[![DITA-OT 2.5](https://img.shields.io/badge/DITA--OT-2.5-green.svg)](http://www.dita-ot.org/2.5/)
[![Build Status](https://travis-ci.org/jason-fox/fox.jason.unit-test.svg?branch=master)](https://travis-ci.org/jason-fox/fox.jason.unit-test)
[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

This is a Unit Testing framework for the DITA Open Toolkit. This plug-in consists of four DITA-OT transforms and an ANT library:
- The `unit-test` transform allows a user to runs a sequence of `dita` commands and checks that the documents created match the expected output. This is useful for regresssion testing, and confirming that any custom plug-ins do not conflict when upgrading the base DITA-OT engine.
- The `test-coverage` transform checks to see if a series of tokens representing all potential output values are covered by unit tests
- The `antro` transform runs an ANT script profiler against a specified transform and outputs a profiler JSON file 
- The `antro.ui` transform starts up the UI for the ANT script profiler, allowing a user to load a JSON file and interpret the results. 
- The `resource/antlib.xml` library offers a series of convenience methods for creating DITA-OT unit tests.