# Personal Bash library for executing Flatpak alternatives.

# Run a flatpak program or native alternative.
#
# Input variables:
# - flatpak_exec_name
# - flatpak_native_path
flatpak_exec_alt() {
    [ -x "${flatpak_native_path}" ] && exec "${flatpak_native_path}" "$@"
    if command -v flatpak >/dev/null 2>&1; then
        exec flatpak run "${flatpak_exec_name}" "$@"
    fi
    printf "$0: missing flatpak and native\n" >2
    exit 1
}
