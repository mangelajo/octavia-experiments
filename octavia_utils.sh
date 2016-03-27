
function wait_on_pending() {
    LB=$1
    echo "* Waiting for LB: $LB"
    while neutron lbaas-loadbalancer-show $LB | grep PENDING_;
    do
        sleep 2
    done
    neutron lbaas-loadbalancer-show $LB
    sleep 5
}

function create_loadbalancer() {

    num=$1
    NAME=test_loadbalancer_$num
    LISTENER=test_listener_$num
    POOL=test_pool_$num

    neutron lbaas-loadbalancer-create --name $NAME $SUBNET
    wait_on_pending $NAME
    neutron lbaas-listener-create --loadbalancer $NAME --protocol HTTP \
                                  --protocol-port 80 --name $LISTENER

    wait_on_pending $NAME

    neutron lbaas-pool-create --lb-algorithm ROUND_ROBIN --listener $LISTENER \
                              --protocol HTTP --name $POOL
    wait_on_pending $NAME

    neutron lbaas-member-create --subnet $SUBNET --address 10.0.0.36 \
                                --protocol-port 80 $POOL

    wait_on_pending $NAME

    neutron lbaas-member-create --subnet $SUBNET --address 10.0.0.37 \
                                --protocol-port 80 $POOL

}

function cleanup_loadbalancer() {
    num=$1
    NAME=test_loadbalancer_$num
    LISTENER=test_listener_$num
    POOL=test_pool_$num
    neutron lbaas-pool-delete $POOL
    sleep 5
    neutron lbaas-listener-delete $LISTENER
    sleep 5
    neutron lbaas-loadbalancer-delete $NAME
}
