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

NAME="blog"
RUBY_VERSION="ruby-1.9.3-p362"
APP_ROOT="/opt/www/$NAME/current"
GEM_HOME="/opt/www/$APP_NAME/shared/bundle/ruby/1.9.1/"
SET_PATH="cd $APP_ROOT; rvm use $RUBY_VERSION; export GEM_HOME=$GEM_HOME"
DAEMON="$SET_PATH; $GEM_HOME/bin/unicorn_rails"
DAEMON_OPTS="-c /opt/www/$NAME/current/config/unicorn.rb -D -E production"
DESC="$NAME"
PID="$APP_ROOT/tmp/pids/unicorn.pid"

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
        kill -USR2 `cat $PID`
#    sleep 5
#    $DAEMON $DAEMON_OPTS
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

