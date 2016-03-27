#!/bin/sh

SUBNET=private_subnet

source ~/keystonerc_admin
source ./octavia_utils.sh
if [ "$1_" == "run_" ]; then
    echo "running tests"
    logrotate -f octavia_logrotate.conf
    create_loadbalancer 1

    sleep 5
    os-log-merger -b /var/log/ octavia/api.log:OAPI1 octavia/api-2.log:OAPI2 \
                  octavia/api-3.log:OAPI3 octavia/worker.log:OWK \
                  octavia/housekeeping.log:OHK \
                  octavia/health-manager.log:OHM > merged_log.log
else
    echo "cleaning up mess"
    cleanup_loadbalancer 1
fi

 
