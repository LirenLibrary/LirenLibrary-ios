#!/bin/bash
# Script to compile and run unit tests from the command line

# The scheme and target name of the main app
MAIN_APP_TARGET=$1

# The scheme and target name of the unit tests
UNIT_TEST_TARGET=$2

# The path to libXcodeTest.a, if not in current directory
PATH_TO_XCODE_TEST_LIB=$3

# Output variable defaults to current directory of not specified
LINK_TO_XCODE_TEST_LIB=""
if [[ "${PATH_TO_XCODE_TEST_LIB}" != "" ]]; then
  XCODE_TEST_ABS_LIB_PATH=`pwd`/${PATH_TO_XCODE_TEST_LIB}
  LINK_TO_XCODE_TEST_LIB="-lXcodeTest -L \"${XCODE_TEST_ABS_LIB_PATH}\""
else
  CURRENT_PATH=`pwd`
  LINK_TO_XCODE_TEST_LIB="-lXcodeTest -L\"${CURRENT_PATH}\""
fi

# Calculate the variables to feed into the build
OUTPUT_DIR=/tmp/xcodetest/${MAIN_APP_TARGET}

echo "===> remove output dir..."
rm -rf ${OUTPUT_DIR}
XCODE_TEST_PATH=${OUTPUT_DIR}/${UNIT_TEST_TARGET}.octest/${UNIT_TEST_TARGET}
XCODE_TEST_LDFLAGS="-all_load -ObjC -framework SenTestingKit ${LINK_TO_XCODE_TEST_LIB} -F \"$\(SDKROOT\)/Developer/Library/Frameworks\""


echo "===> tell app iPhone Simulator to reset..."
osascript ./scripts/reset-simulator

echo "===> tell app iPhone Simulator to quit..."
osascript -e 'tell app "iPhone Simulator" to quit'

echo "===> xcodebuild ARCHS=i386 ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator -scheme ${UNIT_TEST_TARGET} build CONFIGURATION_BUILD_DIR=\"${OUTPUT_DIR}\""
# Build the unit tests bundle, so it can be fed into waxsim
xcodebuild ARCHS=i386 ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator -scheme ${UNIT_TEST_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}"
if [[ $? != 0 ]]; then
  echo "Failed to build unit tests!"
  exit $?
fi

# Build the main app, with libXcodeTest.a linked in
echo "===> xcodebuild -sdk iphonesimulator -scheme ${MAIN_APP_TARGET} build CONFIGURATION_BUILD_DIR=\"${OUTPUT_DIR}\" XCODE_TEST_LDFLAGS=\"${XCODE_TEST_LDFLAGS}\""
xcodebuild ARCHS=i386 ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator -scheme ${MAIN_APP_TARGET} build CONFIGURATION_BUILD_DIR="${OUTPUT_DIR}" XCODE_TEST_LDFLAGS="${XCODE_TEST_LDFLAGS}"
if [[ $? != 0 ]]; then
  echo "Failed to build app!"
  exit $?
fi

# Check that waxsim is installed, used to run the app in the simulator
export PATH=.:./scripts:$PATH
which waxsim
if [[ $? != 0 ]]; then
  echo "Could not find 'waxsim', make sure it is installed and try again"
  exit $?
fi

# Warn users that it wont run the tests unless you tweak the linker settings
echo "================="
echo "If tests do not run, make sure you have included XCODE_TEST_LDFLAGS in your linker flags:"
echo "    In xcconfigs: OTHER_LDFLAGS = \$(inherited) \$(XCODE_TEST_LDFLAGS)"
echo "    In Xcode: set Other Linker Flags to include \$(XCODE_TEST_LDFLAGS)"
echo "================="

# Run the app in the simulator, will automatically load and run unit tests
echo "===> Starting to run app in the simulator with waxsim"
OUT_FILE=${OUTPUT_DIR}/waxsim.out

XCODE_TEST_PATH=${XCODE_TEST_PATH} waxsim ${OUTPUT_DIR}/${MAIN_APP_TARGET}.app -SenTest All > ${OUT_FILE} 2>&1
cat ${OUT_FILE}
echo "===> Starting to convert output to junit format report"
#ruby ../scripts/Third_Party/ocunit2junit.rb $OUT_FILE
#osascript -e 'tell app "iPhone Simulator" to quit'

# if there was a failure, show what waxsim was hiding and crucially return with a non-zero exit code
grep -q ": error:" $OUT_FILE
success=`exec grep -c ": error:" $OUT_FILE`

if [[ $success != 0 ]]; then
    echo "================="
    echo "Unit Tests Failed"
    echo "================="
    exit 1
else
    echo "================="
    echo "Unit Tests Passed"
    echo "================="
fi
