#!/bin/bash

# Author: Francisco Chaves <https://franciscochaves.com>
# Description: Initial configuration for mobile development

# To load the settings, use the command: source config-mobile.sh

# NodeJS - https://nodejs.org/en/
# Phonegap - https://phonegap.com/ - npm install -g phonegap
# Cordova - https://cordova.apache.org/ - npm install -g cordova
# Ionic - https://ionicframework.com/ - npm install -g @ionic/cli
# Android - https://developer.android.com/studio
# command-line - https://developer.android.com/studio/command-line
# Java - https://adoptopenjdk.net/
# kvm - https://www.linux-kvm.org/page/Main_Page - sudo apt -y install kvm
# Gradle - https://gradle.org/ - sudo apt -y install gradle
# Ant - https://ant.apache.org/ - sudo apt -y install ant
# adb - https://developer.android.com/studio/command-line/adb?hl=pt-br - sudo apt -y install adb

export ANDROID_SDK_ROOT="${HOME}/Android/Sdk"
export ANDROID_HOME="${HOME}/Android/Sdk"
export ANDROID_AVD_HOME="${HOME}/.android/avd"
export ANDROID_SDK_HOME="/opt/android/Sdk"
export ANDROID_EMULATOR="${ANDROID_HOME}/emulator"

export JAVA_HOME="/usr/lib/jvm/adoptopenjdk-8-hotspot-amd64"
export GRADLE_HOME="/usr/share/gradle"

export PATH="${PATH}:${ANDROID_HOME}/build-tools/29.0.3:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/latest/bin:${JAVA_HOME}/bin:${GRADLE_HOME}/bin:${ANDROID_EMULATOR}"

export NEXUS_5_API_22="Nexus-5-API-22"
export PIXEL_2_API_27="Pixel-2-API-27"

alias emulator="${ANDROID_EMULATOR}/emulator"
alias emulator-list="${ANDROID_EMULATOR}/emulator -list-avds"

alias phone-nexus5="${ANDROID_EMULATOR}/emulator -avd ${NEXUS_5_API_22} -netdelay none -netspeed full >/dev/null 2>&1 & disown %1 ; notify-send --icon=utilities-terminal '$(cat /etc/passwd | grep $USER | cut -d: -f5 | cut -d, -f1)' '${NEXUS_5_API_22} emulator process running';"
alias phone-pixel2="${ANDROID_EMULATOR}/emulator -avd ${PIXEL_2_API_27} -netdelay none -netspeed full >/dev/null 2>&1 & disown %1 ; notify-send --icon=utilities-terminal '$(cat /etc/passwd | grep $USER | cut -d: -f5 | cut -d, -f1)' '${PIXEL_2_API_27} emulator process running';"