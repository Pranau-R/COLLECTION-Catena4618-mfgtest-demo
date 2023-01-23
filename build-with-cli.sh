#!/bin/bash

##############################################################################
#
# Module: build-with-cli.sh
#
# Function:
#	This script must be sourced; it sets variables used by other
#	scripts in this directory.
#
# Usage:
#	build-with-cli.sh --help
#
# Copyright and License:
#	See accompanying LICENSE.md file
#
# Author:
#	Terry Moore, MCCI	February 2021
#
##############################################################################

# install arduino-cli from github using:
#  curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh

# if Linux, to set up:
#  sudo dpkg --add-architecture i386
#  sudo apt install libc6-i386

# exit if any errors encountered
set -e

# get the path to this file as the default for the build path.
PDIR=$(realpath "$(dirname "$0")")

# export the root name of this script for use by build-common.
PNAME=$(basename "$0")
export PNAME

# so the build directory shows up where this script lives, CD here.
cd "$PDIR"

# launch the common script and pass in the args.
. "${PDIR}/extra/tools-build-with-cli/build-with-cli-lib.sh"

function _setProject {
    #---- project settings -----
    readonly OPTOUTPUTNAME_DEFAULT=Catena4618-mfgtest
    readonly OPTARDUINO_SOURCE_DEFAULT=sketches/catena4618-mfgtest/catena4618-mfgtest.ino
    readonly OPTARDUINO_BOARD_DEFAULT=4618
    readonly OPTKEYFILE_DEFAULT="$INVOKEDIR/keys/project.pem"
    readonly OPTREGION_DEFAULT=us915
    readonly OPTNETWORK_DEFAULT=ttn
    readonly OPTSUBBAND_DEFAULT=default
    readonly OPTCLOCK_DEFAULT=16
    readonly OPTXSERIAL_DEFAULT=usb
}

# result is version as either x.y.z-N or x.y.z (if pre-release tag is -0)
_debug "Override _getversion"
function _getversion {
    sed -n -e '/^constexpr std::uint32_t kAppVersion /s/^.*makeVersion[ \t]*([ \t]*\([0-9]*\)[ \t]*,[ \t]*\([0-9]*\)[ \t]*,[ \t]*\([0-9]*\)[ \t]*,[ \t]*\([0-9]*\)[ \t]*).*/\1.\2.\3_pre\4/p' \
           -e '/^constexpr std::uint32_t kAppVersion /s/^.*makeVersion[ \t]*([ \t]*\([0-9]*\)[ \t]*,[ \t]*\([0-9]*\)[ \t]*,[ \t]*\([0-9]*\)[ \t]*).*/\1.\2.\3/p' "$1" |
        sed -e 's/_pre0$//'
}

_doBuild "$@"
