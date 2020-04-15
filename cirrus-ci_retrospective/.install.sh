
# Installs cirrus-ci_retrospective system-wide.  NOT intended to be used directly
# by humans, should only be used indirectly by running
# ../bin/install_automation.sh <ver> cirrus-ci_retrospective

source "$AUTOMATION_LIB_PATH/anchors.sh"
source "$AUTOMATION_LIB_PATH/console_output.sh"

# Assume the directory this script is in, represents what is being installed
INSTALL_NAME=$(basename $(dirname ${BASH_SOURCE[0]}))
AUTOMATION_VERSION=$(automation_version)
[[ -n "$AUTOMATION_VERSION" ]] || \
    die "Could not determine version of common automation libs, was 'install_automation.sh' successful?"

echo "Installing $INSTALL_NAME version $(automation_version) into $INSTALL_PREFIX/share/automation"

unset INST_PERM_ARG
if [[ $UID -eq 0 ]]; then
    INST_PERM_ARG="-o root -g root"
fi

cd $(dirname $(realpath "${BASH_SOURCE[0]}"))
install -v $INST_PERM_ARG -D -t "$INSTALL_PREFIX/share/automation/bin" ./bin/*
install -v $INST_PERM_ARG -D -t "$INSTALL_PREFIX/share/automation/lib" ./lib/*

cat << EOF > "$INSTALL_PREFIX/bin/${INSTALL_NAME}.sh"
#!/bin/bash
# Created by 'install_automation.sh $INSTALL_NAME' on $(date --iso-8601=minutes)
# Automation installer version $AUTOMATION_VERSION
set -e
source "$AUTOMATION_LIB_PATH/environment"
exec "$INSTALL_PREFIX/share/automation/bin/${INSTALL_NAME}.sh"
EOF

# Needed for installer testing
echo "Successfully installed $INSTALL_NAME"
