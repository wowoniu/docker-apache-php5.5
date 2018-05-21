#!/bin/bash
chown www-data:www-data /app -R





#更改xdebug的配置

#XDEBUG_REMOTE HOST默认值处理
${XDEBUG_REMOTE_HOST:=10.20.103.87}
#默认开启XDEBUG
${XDEBUG_REMOTE_ENABLE:=1}
#默认关闭XDEBUG PROFILE性能日志
${XDEBUG_PROFILE_ENABLE:=0}
#默认性能日志的输入文件路径
${XDEBUG_PROFILE_DIR:=/data/__PHPDEBUG__}
#XDEBUG 远端端口
${XDEBUG_REMOTE_PORT:=9001}
#XDEBUG 的会话KEY
${XDEBUG_IDE_KEY:=XDEBUG_SESSION}

echo "[xdebug]
zend_extension=/usr/lib/php5/20121212/xdebug.so
xdebug.remote_enable = ${XDEBUG_REMOTE_ENABLE}
xdebug.profiler_enable =${XDEBUG_PROFILE_ENABLE}
xdebug.profiler_enable_trigger = 1
xdebug.profiler_output_name = [%t]_%R.profile
xdebug.profiler_output_dir = ${XDEBUG_PROFILE_DIR}
xdebug.auto_trace = 0
xdebug.trace_output_dir = ${XDEBUG_PROFILE_DIR}
xdebug.remote_port = ${XDEBUG_REMOTE_PORT}
xdebug.ideky= ${XDEBUG_IDE_KEY}
xdebug.remote_host=${XDEBUG_REMOTE_HOST}
xdebug.remote_autostart = 0 " >> /etc/php5/apache2/php.ini






source /etc/apache2/envvars
echo $APACHE_LOCK_DIR
#tail -F /var/log/apache2/* &
#exec apache2 -D FOREGROUND
apache2ctl -D FOREGROUND
