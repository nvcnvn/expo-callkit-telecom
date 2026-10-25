#!/bin/sh
# Builds the WebRTC stand-ins with a test harness for Mac Catalyst (iOS APIs, runs on the host Mac,
# no simulator needed) and runs it.
set -eu
cd "$(dirname "$0")"
out=$(mktemp -d)
target="$(uname -m)-apple-ios16.0-macabi"
sdk=$(xcrun --sdk macosx --show-sdk-path)
xcrun clang -fobjc-arc -target "$target" -isysroot "$sdk" -c ../WebRTC/ECKTWebRTC.m -o "$out/ECKTWebRTC.o"
xcrun clang -fobjc-arc -target "$target" -isysroot "$sdk" -c ECKTWebRTCTests.m -o "$out/ECKTWebRTCTests.o"
xcrun swiftc -target "$target" -sdk "$sdk" -parse-as-library -import-objc-header ../WebRTC/ECKTWebRTC.h \
  ECKTWebRTCTests.swift "$out/ECKTWebRTC.o" "$out/ECKTWebRTCTests.o" -o "$out/ECKTWebRTCTests"
"$out/ECKTWebRTCTests"
