#!/usr/bin/env bash

# Script that runs emulator and saving snapshot

RESET="\033[0m"
F_BOLD="\033[1m"
F_BOLD_RESET="\033[22m"
C_RED="\033[31m"
TIMEOUT_IN_SEC=360

function log_info() { printf -- "%s\n" "$*"; }
function log_success() { printf -- "\n${F_BOLD}${C_GREEN}%s${RESET}\n" "$*"; }
function log_error() { printf -- "\n${F_BOLD}${C_RED}ERROR:${F_BOLD_RESET} %s${RESET}\n" "$*"; }

function fail_with_msg() {
    printf -- "\n${F_BOLD}${C_RED}ERROR:${F_BOLD_RESET} %s${RESET}\n" "$*";
    exit 1
}

function require() {
    local expected=$1
    shift
    local actual=`$@`

    if [[ "$actual" != *"$expected"* ]]; then
        fail_with_msg "Required output for command: $@ is $expected, actual: $actual"
    fi
}

log_info "Starting emulator..."

SNAPSHOT_ENABLED="false" start-emulator

log_info "Checking settings applying result..."
require 0.0 adb shell "settings get global window_animation_scale"
require 0.0 adb shell "settings get global transition_animation_scale"
require 0.0 adb shell "settings get global animator_duration_scale"
require 1 adb shell "settings get global hidden_api_policy_pre_p_apps"
require 1 adb shell "settings get global hidden_api_policy_p_apps"
require 1 adb shell "settings get global hidden_api_policy"
require 0 adb shell "settings get secure spell_checker_enabled"
require 1 adb shell "settings get secure show_ime_with_hard_keyboard"
require 1500 adb shell "settings get secure long_press_timeout"

# https://androidstudio.googleblog.com/2019/05/emulator-2906-stable.html
require 2147483647 adb shell "settings get system screen_off_timeout"

adb emu avd snapshot save ${DEFAULT_SNAPSHOT}

sleep 5

adb emu avd snapshot list
adb emu kill

sleep 5

adb kill-server

log_success "Emulator snapshot preparation finished"
