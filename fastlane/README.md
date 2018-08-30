fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
### fiv_test
```
fastlane fiv_test
```
Test lane for action development

----

## iOS
### ios fiv_testflight
```
fastlane ios fiv_testflight
```
Build and release a test version to testflight

----

## Android
### android fiv_alpha
```
fastlane android fiv_alpha
```
Build and release a test version to testflight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
