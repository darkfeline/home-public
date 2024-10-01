# Personal Bash library for setting up Python virtualenvs

# Setup a Python virtualenv.
#
# Input variables:
# - pyvenv_setup_name
#
# Output variables:
# - pyvenv_setup_dir
pyvenv_setup() {
    pyvenv_setup_dir=~/.local/share/python-venv/${pyvenv_setup_name}
    if [[ ! -x ${pyvenv_setup_dir}/bin/python ]]; then
        python3 -m venv "${pyvenv_setup_dir}"
    fi
}

# Install a package in a Python virtualenv.
#
# Argument:
# - Name of command to check existence
# - (rest) Arguments to pip install
#
# Input variables:
# - pyvenv_setup_dir
pyvenv_setup_install_command() {
    local cmd=$1
    shift 1
    if [[ ! -x ${pyvenv_setup_dir}/bin/${cmd} ]]; then
        "${pyvenv_setup_dir}/bin/python" -m ensurepip
        "${pyvenv_setup_dir}/bin/python" -m pip install "$@"
    fi
}
