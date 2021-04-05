export ODA_SITE=${ODA_SITE:-}
export ODA_NAMESPACE=${ODA_NAMESPACE:-staging-1-3}


function create-secret() {
    kubectl -n $ODA_NAMESPACE delete secret dispatcher-conf || echo ok
    kubectl -n $ODA_NAMESPACE create secret generic dispatcher-conf --from-file=conf_env.yml=conf/conf_env.yml
}

function install() {
    upgrade
}

function upgrade() {
    set -x
    helm upgrade --install -n ${ODA_NAMESPACE:?} oda-dispatcher . -f values-${ODA_SITE:?}.yaml --set image.tag="$(cd dispatcher; git describe --always)" 
}

$@
