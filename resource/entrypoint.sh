#! /bin/sh

# This file is part of the DITA-OT Unit Test Plug-in project.
# See the accompanying LICENSE file for applicable licenses.

#!/bin/bash

SETUP_SCRIPT=${SETUP_SCRIPT:-test-setup.sh}
FILE=/src/${SETUP_SCRIPT}

if [ -f "$FILE" ]; then
	"${FILE}"
fi

if [ ! -z "${PREREQUISITES}" ]; then 
	list=$(echo "$PREREQUISITES" | tr "," "\n")
	for prereq in $list
	do
		/opt/app/bin/dita install "$prereq"
	done
fi


if [ -z "${PLUGIN}"  ]; then 
	echo "No plugin to test"
else
	cp -r /src /opt/app/plugins/"${PLUGIN}"
	/opt/app/bin/dita install
	/opt/app/bin/dita --input /opt/app/plugins/"${PLUGIN}" -f xsl-instrument
	/opt/app/bin/dita --input /opt/app/plugins/"${PLUGIN}" -f unit-test "$@"
fi

