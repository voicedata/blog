#! /bin/sh

# File: /etc/init.d/blog_app

### BEGIN INIT INFO
# Provides:          blog_app
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the blog_app web server
# Description:       starts blog_app
### END INIT INFO

DAEMON=/home/webmstr/.rvm/bin/blog_unicorn_rails
DAEMON_OPTS="-c /opt/www/blog/current/config/unicorn.rb -D -E production"
NAME=blog
DESC="blog for testing"
PID=/opt/www/blog/current/tmp/pids/unicorn.pid

case "$1" in
  start)
    echo -n "Starting $DESC: "
    $DAEMON $DAEMON_OPTS
    echo "$NAME."
    ;;
  stop)
    echo -n "Stopping $DESC: "
        kill -QUIT `cat $PID`
    echo "$NAME."
    ;;
  restart)
    echo -n "Restarting $DESC: "
        kill -QUIT `cat $PID`
    sleep 5
    $DAEMON $DAEMON_OPTS
    echo "$NAME."
    ;;
  reload)
        echo -n "Reloading $DESC configuration: "
        kill -HUP `cat $PID`
        echo "$NAME."
        ;;
  *)
    echo "Usage: $NAME {start|stop|restart|reload}" >&2
    exit 1
    ;;
esac

exit 0

