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
extension_name="Extract App Icon"
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

## GitHub
gh_access_token_name_in_keychain="iconconverter-gh-access-token"

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

function create_release() {

    json_string=$(/usr/bin/jq -n \
        --arg tag_name "v$version" \
        --arg name "$pkg_name v$version" \
        --arg body 'This is a signed and notarized installer package containing **'"${app_name}"'** app, **'"${extension_name}"'** Finder extension and `'"${pkg_name}"'` cli tool.' \
    '
    {
        tag_name: $tag_name,
        target_commitish: "main",
        name: $name,
        body: $body,
        draft: false,
        prerelease: false,
        generate_release_notes: false
    }
    '
    )

    release_id=$(/usr/bin/curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $(/usr/bin/security find-generic-password -w -s "$gh_access_token_name_in_keychain" -a "$gh_access_token_name_in_keychain")" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repos/jlehikoinen/iconconverter/releases \
        -d "$json_string" | /usr/bin/jq .id)
}

function upload_release_asset() {
    /usr/bin/curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $(/usr/bin/security find-generic-password -w -s "$gh_access_token_name_in_keychain" -a "$gh_access_token_name_in_keychain")" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        -H "Content-Type: application/octet-stream" \
        "https://uploads.github.com/repos/jlehikoinen/iconconverter/releases/$release_id/assets?name=$pkg_name-$version.pkg" \
        --data-binary "@${pkg_path}"
}

function create_new_commit() {

    git -C ${parent_dir} commit -a -m "Version $version release"
    git -C ${parent_dir} push
}

function open_releases_url() {

    open "https://github.com/jlehikoinen/iconconverter/releases"
}

###

tail_log
increment_version_number
build_app
build_cli_tool
create_pkg
notarize_pkg
create_release
upload_release_asset
create_new_commit
sleep 3
open_releases_url
echo "\nPost-action done. Exiting."

exit $?