#!/bin/zsh --no-rcs

# ================================================
# build_iconconverter.zsh
#
# Xcode build script
#
# Description:
# - Xcode build script
# - Creates a notarized pkg containing the app bundle, Finder extension and the cli tool
# - Package installs the app bundle to /Applications and cli tool to /usr/local/bin
# - "github-mac-apps-notarization" keychain profile is utilized for notarization
# ================================================

# set -o errexit              # Exit script when command fails
set -o nounset              # Exit script if variable is not set

# Vars

## Paths
script_dir=$(dirname $0)
parent_dir=$(dirname "$script_dir")
xcode_project_name="Icon Converter.xcodeproj"
target_path="$HOME/Desktop"
datetime=$(/bin/date +%Y%m%d%H%M%S)
product_name="iconconverter"
app_name="Icon Converter"
export_path="${target_path}/${product_name}-$datetime"
build_path_xcode="${export_path}/build_xcode"
build_path_app="${build_path_xcode}/Build/Products/Release/${app_name}.app"
zip_path="${build_path_xcode}/Build/Products/Release/${app_name}.zip"
build_path_cli_tool="${build_path_xcode}/Build/Products/Release/${product_name}"
log_file="${export_path}/${product_name}-build-$datetime.txt"
build_path_pkg="${export_path}/build_pkg"
pkg_name="$product_name"
install_path_app="/Applications"
install_path_cli_tool="/usr/local/bin"

## App info
identifier="com.github.IconConverter"
app_signing_cert="Developer ID Application: Janne Lehikoinen (DAQCN465V5)"
installer_signing_cert="Developer ID Installer: Janne Lehikoinen (DAQCN465V5)"
keychain_profile="github-mac-apps-notarization"

###

# Create target folders
/bin/mkdir -p "$build_path_xcode"
/bin/mkdir -p "$build_path_pkg"

# Output everything to a log file
exec > "$log_file" 2>&1

###

function increment_version_number() {

    # Bump up build number with agvtool
    xcrun agvtool next-version -all
    major_version=$(xcodebuild -showBuildSettings | awk '/MARKETING_VERSION / {print $3}')
    build_number=$(xcodebuild -showBuildSettings | awk '/CURRENT_PROJECT_VERSION / {print $3}')
    version="$major_version.$build_number"

    echo
    echo "-----------------------------"
    echo "Building new version: $version"
    echo "-----------------------------"
    echo
}

function tail_log() {

    /usr/bin/osascript -e 'tell app "Terminal" to do script "tail -f " & quoted form of "'"$log_file"'"'
    /bin/sleep 2
}

function build_app() {

    echo "Exporting archive.."
    /usr/bin/xcodebuild -project "${parent_dir}/${xcode_project_name}" \
        -scheme "$app_name" \
        -configuration Release \
        -derivedDataPath "$build_path_xcode" \
        CODE_SIGN_IDENTITY=$app_signing_cert OTHER_CODE_SIGN_FLAGS="--timestamp" CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO

    if [[ $? -ne 0 ]]; then
        echo "ERROR: Export failed. Exiting."
        exit 1
    fi
}

function build_cli_tool() {

    echo "Exporting archive.."
    /usr/bin/xcodebuild -project "${parent_dir}/${xcode_project_name}" \
        -scheme "$product_name" \
        -configuration Release \
        -derivedDataPath "$build_path_xcode" \
        CODE_SIGN_IDENTITY=$app_signing_cert OTHER_CODE_SIGN_FLAGS="--timestamp" CODE_SIGN_INJECT_BASE_ENTITLEMENTS=NO

    if [[ $? -ne 0 ]]; then
        echo "ERROR: Export failed. Exiting."
        exit 1
    fi
}

function create_pkg() {

    # Paths
    mkdir -p ${build_path_pkg}/${install_path_app}
    mkdir -p ${build_path_pkg}/${install_path_cli_tool}
    pkg_path="${export_path}/$pkg_name-$version.pkg"

    # Move components to pkg build root
    mv "$build_path_app" ${build_path_pkg}/${install_path_app}
    mv "$build_path_cli_tool" ${build_path_pkg}/${install_path_cli_tool}

    # Create the pkg
    /usr/bin/pkgbuild --root "$build_path_pkg" \
            --identifier "$identifier" \
            --version $version \
            --install-location "/" \
            --sign "$installer_signing_cert" \
            "$pkg_path"
}

function notarize_pkg() {

    # Submit for notarization
    /usr/bin/xcrun notarytool submit "$pkg_path" \
                                --keychain-profile "$keychain_profile" \
                                --wait

    # Staple
    /usr/bin/xcrun stapler staple "$pkg_path"
}

###

tail_log
increment_version_number
build_app
build_cli_tool
create_pkg
notarize_pkg
echo "\nPost-action done. Exiting."

exit $?