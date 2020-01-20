
set -x

export NAMESPACE="default"
[ -f /var/run/secrets/kubernetes.io/serviceaccount/namespace ] && export NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`

echo "Use Namespace: ${NAMESPACE}"

echo "Create Symlinks..."
rm -rf $DOCUMENT_ROOT/pub/media && ln -s /kubernetes/nfs/$NAMESPACE/pub/media $DOCUMENT_ROOT/pub/media
rm -rf $DOCUMENT_ROOT/pub/static && ln -s /kubernetes/nfs/$NAMESPACE/pub/static $DOCUMENT_ROOT/pub/static
rm -rf $DOCUMENT_ROOT/var/report && ln -s /kubernetes/nfs/$NAMESPACE/var/report $DOCUMENT_ROOT/var/report


kubectl -n ${NAMESPACE} get configmap magento-app--etc -o jsonpath="{.data.env\.php}" > ${DOCUMENT_ROOT}/app/etc/env.php
# kubectl -n ${NAMESPACE} get configmap magento-app--etc -o jsonpath="{.data.config\.php}" > ${DOCUMENT_ROOT}/app/etc/config.php
chown www-data:www-data ${DOCUMENT_ROOT}/app/etc/env.php
# chown www-data:www-data ${DOCUMENT_ROOT}/app/etc/config.php