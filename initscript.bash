#!/bin/bash
# chkconfig: 2345 90 90
# description: watcher
### BEGIN INIT INFO
# Provides: watcher
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Control watcher
# Based on http://tech.superhappykittymeow.com/?p=326&cpage=1
### END INIT INFO

# Load sysconfig
source /etc/sysconfig/watcher

if [ -z $CHECK_CMD || -z $USER ] ; then
  echo "Missing CHECK_CMD or USER variable. Make sure you have it defined in /etc/sysconfig/watcher"
fi

LOGFILE="/var/log/watcher.log"
START_CMD="/opt/watcher/watcher -p 5777 -m /opt/watcher/maint -c $CHECK_CMD > $LOGFILE 2>&1 &"
START_DIR="/opt/watcher"
NAME="watcher"
PGREP_STRING="watcher"
PID_FILE="/var/run/watcher.pid"

CUR_USER=`whoami`

killproc() {
  pkill -u $USER -f $PGREP_STRING
}

start_daemon() {
  eval "$*"
}

log_success_msg() {
  echo "$*"
  logger "$_"
}

log_failure_msg() {
  echo "$*"
  logger "$_"
}

check_proc() {
  pgrep -u $USER -f $PGREP_STRING >/dev/null
}

start_script() {
  if [ "${CUR_USER}" != "root" ] ; then
    log_failure_msg "$NAME can only be started as 'root'."
    exit -1
  fi

  check_proc
  if [ $? -eq 0 ]; then
    log_success_msg "$NAME is already running."
    exit 0
  fi

  [ -d /var/run/$NAME ] || (mkdir /var/run/$NAME )

   # make go now
   cd $START_DIR
   start_daemon /bin/su $USER -c "'$START_CMD'"

  # Sleep for a while to see if anything cries
  sleep 5
  check_proc

  if [ $? -eq 0 ]; then
    log_success_msg "Started $NAME."
  else
    log_failure_msg "Error starting $NAME."
    exit -1
  fi
}

stop_script() {
  if [ "${CUR_USER}" != "root" ] ; then
    log_failure_msg "You do not have permission to stop $NAME."
    exit -1
  fi

  check_proc
  if [ $? -eq 0 ]; then
    killproc -p $PID_FILE >/dev/null

    # Make sure it's dead before we return
    until [ $? -ne 0 ]; do
      sleep 1
      check_proc
    done

    check_proc
    if [ $? -eq 0 ]; then
      log_failure_msg "Error stopping $NAME."
      exit -1
    else
      log_success_msg "Stopped $NAME."
    fi
  else
    log_failure_msg "$NAME is not running or you don't have permission to stop it"
  fi
}

check_status() {
  check_proc
  if [ $? -eq 0 ]; then
    log_success_msg "$NAME is running."
  else
    log_failure_msg "$NAME is stopped."
    exit -1
  fi
}

case "$1" in
  start)
    start_script
    ;;
  stop)
    stop_script
    ;;
  restart)
    stop_script
    start_script
    ;;
  status)
    check_status
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
esac

exit 0
