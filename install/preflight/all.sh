source $DEBIAN_INSTALL/preflight/guard.sh
source $DEBIAN_INSTALL/preflight/begin.sh
run_logged $DEBIAN_INSTALL/preflight/show-env.sh
run_logged $DEBIAN_INSTALL/preflight/pacman.sh
run_logged $DEBIAN_INSTALL/preflight/migrations.sh
run_logged $DEBIAN_INSTALL/preflight/first-run-mode.sh
run_logged $DEBIAN_INSTALL/preflight/disable-mkinitcpio.sh
