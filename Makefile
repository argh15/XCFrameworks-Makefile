#!/usr/bin/xcrun make -f
## START CONFIGURABLES

PROJECT=iThermonitorFramework.xcodeproj
TARGET=iThermonitorFramework

## END CONFIGURABLES

clear:
	rm -rf build/
	rm -rf tmp/

clean:
	xcodebuild -project $(PROJECT) -target $(TARGET)

archive:
	xcodebuild -project $(PROJECT) archive -scheme $(TARGET) -archivePath tmp/archives/ios-sim -sdk iphonesimulator SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES EXCLUDED_ARCHS="arm64" ONLY_ACTIVE_ARCH=YES
	xcodebuild -project $(PROJECT) archive -scheme $(TARGET) -archivePath tmp/archives/ios -sdk iphoneos SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

xcframework: | clear clean archive
	xcodebuild -create-xcframework \
		-framework tmp/archives/ios.xcarchive/Products/Library/Frameworks/$(TARGET).framework \
		-framework tmp/archives/ios-sim.xcarchive/Products/Library/Frameworks/$(TARGET).framework \
		-output build/xcframework/$(TARGET).xcframework
	echo "***XCFRAMEWORK SUCCEEDED***"
	open build/xcframework/
