#!/bin/bash

# Fail fast, including pipelines
set -exo pipefail

cd /adventure

cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon = true
user = root

[unix_http_server]
file=/tmp/supervisor.sock   ; (the path to the socket file)

[eventlistener:stdout] 
command = supervisor_stdout 
buffer_size = 100 
events = PROCESS_LOG 
result_handler = supervisor_stdout:event_handler
EOF

# Ensure defaults
export PORT=${PORT:-3000}

env | grep -v 'HOME\|PWD\|PATH' | while read line; do
   key="$(echo $line | cut -d= -f1)"
   value="$(echo $line | cut -d= -f2-)"
   echo "export $key=\"$value\"" >> /home/term/.bashrc
done

cat <<EOF > /tmp/adventure.sh
#!/bin/bash
cd /adventure
source /home/term/.bashrc
exec ./adventure
EOF

chmod 755 /tmp/adventure.sh /tmp/adventure.sh

ln -sf /tmp/adventure.sh /bin/login

cat <<EOF > /tmp/wetty.sh
#!/bin/bash
cd /adventure
source /home/term/.bashrc
exec /usr/bin/node /opt/wetty/app.js -p ${PORT}
EOF

chmod 755 /tmp/wetty.sh

cat > /etc/supervisor/conf.d/wetty.conf <<EOF
[program:wetty]
command=/tmp/wetty.sh
priority=10
directory=/opt/wetty
process_name=%(program_name)s
autostart=true
autorestart=true
stdout_events_enabled=true
stderr_events_enabled=true
stopsignal=TERM
stopwaitsecs=1
EOF

chown daemon:daemon /etc/supervisor/conf.d/ /var/run/ /var/log/supervisor/ /adventure

# start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
