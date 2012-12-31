#!/bin/sh

frank build
rm -rf functional-test-reports
RETVAL=$?
osascript -e 'tell app "iPhone Simulator" to quit'
cd Frank
cucumber -f junit -o ../functional-test-reports/

cd ..
osascript -e 'tell app "iPhone Simulator" to quit'
exit $RETVAL
