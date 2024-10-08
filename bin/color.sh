if [ -z "${BOLD:-}" ]; then
    case "${TERM:-dumb}" in
        dumb)
            readonly BOLD
            readonly BLACK
            readonly RED
            readonly GREEN
            readonly YELLOW
            readonly BLUE
            readonly MAGENTA
            readonly CYAN
            readonly WHITE
            readonly RESET
            ;;
        *)
            readonly BOLD=$(tput bold)
            readonly BLACK=$(tput setaf 0)
            readonly RED=$(tput setaf 1)
            readonly GREEN=$(tput setaf 2)
            readonly YELLOW=$(tput setaf 3)
            readonly BLUE=$(tput setaf 4)
            readonly MAGENTA=$(tput setaf 5)
            readonly CYAN=$(tput setaf 6)
            readonly WHITE=$(tput setaf 7)
            readonly RESET=$(tput sgr0)
            ;;
    esac
fi
