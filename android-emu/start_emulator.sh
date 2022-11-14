#!/bin/bash

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

function check_kvm() {
    cpu_support_hardware_acceleration=$(grep -cw ".*\(vmx\|svm\).*" /proc/cpuinfo)
    if [ "$cpu_support_hardware_acceleration" != 0 ]; then
        echo 1
    else
        echo 0
    fi
}

function config_emulator_settings() {
    log_info "Let's configure emulator via adb.."

    adb shell "settings put global window_animation_scale 0.0"
    adb shell "settings put global transition_animation_scale 0.0"
    adb shell "settings put global animator_duration_scale 0.0"
    adb shell "settings put secure spell_checker_enabled 0"
    adb shell "settings put secure show_ime_with_hard_keyboard 1"

    # This is not applied to system images with API level < 26
    # as there is not a reliable boot complete signal communicated back to the host for those system images.
    adb shell "settings put system screen_off_timeout 2147483647"
    adb shell "settings put secure long_press_timeout 1500"
    # Hidden APIs
    # https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces#how_can_i_enable_access_to_non-sdk_interfaces
    # Android 9
    adb shell "settings put global hidden_api_policy_pre_p_apps 1"
    adb shell "settings put global hidden_api_policy_p_apps 1"
    # Android 10+
    adb shell "settings put global hidden_api_policy 1"

    adb shell "am broadcast -a com.android.intent.action.SET_LOCALE --es com.android.intent.extra.LOCALE EN"
    adb shell input keyevent 82
}

function wait_emulator() {
    log_info "Wait device..."
    timeout $TIMEOUT_IN_SEC adb wait-for-device && log_success "Device connected!" || \
        fail_with_msg "Timeout ($TIMEOUT_IN_SEC seconds) reached - failed to wait the device"
}

function wait_emulator_boot_completed() {
    failcounter=0

    log_info "Wait when boot is fully completed..."

    while [ true ]; do
        status=$(adb shell getprop sys.boot_completed | tr -d '\r')

        if [ "$status" == "1" ]; then
            log_success "Boot completed!"
            break
        else
            let "failcounter += 1"

            if [[ $failcounter -gt TIMEOUT_IN_SEC ]]; then
                fail_with_msg "Timeout ($TIMEOUT_IN_SEC seconds) reached - failed to start emulator"
            fi

            sleep 1
            log_info "try #$failcounter/$TIMEOUT_IN_SEC, boot in progress, still waiting..."
        fi
    done
}

function wait_emulator_to_be_ready() {
    adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done

    ${ANDROID_HOME}/emulator/emulator -avd ${EMULATOR_NAME} -verbose -no-boot-anim -wipe-data -no-snapshot -no-audio -no-window &

    wait_emulator
    wait_emulator_boot_completed
}

function start_emulator_if_possible() {
    log_info "Let's try to run the emulator"

    check_kvm=$(check_kvm)

    if [ "$check_kvm" != "1" ]; then
        log_error "Run emulator failed, nested virtualization is not supported"
        exit 1
    else
        wait_emulator_to_be_ready
        sleep 1
        config_emulator_settings
    fi
}

start_emulator_if_possible
