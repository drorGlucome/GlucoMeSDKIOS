#!/bin/sh
#Release



# define output folder environment variable



UNIVERSAL_OUTPUTFOLDER=${PROJECT_DIR}/Release-universal







# Step 1. Build Device and Simulator versions



xcodebuild -target GlucoMeSDK ONLY_ACTIVE_ARCH=NO -configuration Release -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"



xcodebuild -target GlucoMeSDK -configuration Release -sdk iphonesimulator -arch i386   BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"



xcodebuild -target GlucoMeSDK -configuration Release -sdk iphonesimulator -arch x86_64 BUILD_DIR="${BUILD_DIR}/64" BUILD_ROOT="${BUILD_ROOT}"











# make sure the output directory exists



mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"







# Step 2. Create universal binary file using lipo



lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/lib${PROJECT_NAME}.a" "${BUILD_DIR}/Release-iphoneos/lib${PROJECT_NAME}.a" "${BUILD_DIR}/Release-iphonesimulator/lib${PROJECT_NAME}.a" "${BUILD_DIR}/64/Release-iphonesimulator/lib${PROJECT_NAME}.a"







# Last touch. copy the header files. Just for convenience



cp -R "${BUILD_DIR}/Release-iphoneos/include" "${UNIVERSAL_OUTPUTFOLDER}/"



































#Debug







# define output folder environment variable



UNIVERSAL_OUTPUTFOLDER=${PROJECT_DIR}/Debug-universal







# Step 1. Build Device and Simulator versions



xcodebuild -target GlucoMeSDK ONLY_ACTIVE_ARCH=NO -configuration Debug -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"



xcodebuild -target GlucoMeSDK -configuration Debug -sdk iphonesimulator -arch i386   BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}"



xcodebuild -target GlucoMeSDK -configuration Debug -sdk iphonesimulator -arch x86_64 BUILD_DIR="${BUILD_DIR}/64" BUILD_ROOT="${BUILD_ROOT}"











# make sure the output directory exists



mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"







# Step 2. Create universal binary file using lipo



lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/lib${PROJECT_NAME}.a" "${BUILD_DIR}/Debug-iphoneos/lib${PROJECT_NAME}.a" "${BUILD_DIR}/Debug-iphonesimulator/lib${PROJECT_NAME}.a" "${BUILD_DIR}/64/Debug-iphonesimulator/lib${PROJECT_NAME}.a"







# Last touch. copy the header files. Just for convenience



cp -R "${BUILD_DIR}/Debug-iphoneos/include" "${UNIVERSAL_OUTPUTFOLDER}/"


