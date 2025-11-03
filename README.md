# Icon Converter

Convert macOS app bundle icon to `.png` format.

App Sandbox enabled.

## Features

- Drop app bundle to app window
- Drop app bundle to Dock icon
- Right click app bundle in Finder

## CLI Usage

```
iconconverter convert path/to/Example.app path/to/savelocation [--size 256]
```

## Settings

Read app settings:

```
defaults read ~"/Library/Group Containers/group.com.github.IconConverter/Library/Preferences/group.com.github.IconConverter.plist"
```
