rm -fr ipa/
xcodebuild clean
xcodebuild -target Liren-ios -sdk iphoneos6.0
mkdir -p ipa/Payload
cp -r ./build/Release-iphoneos/Liren-ios.app ./ipa/Payload/
cd ipa/
zip -r Liren-ios.ipa *
