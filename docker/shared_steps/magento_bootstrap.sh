#!/bin/bash

echo "START Magento Bootstrap"

set -x

if [ -d /var/run/secrets/kubernetes.io ]; then

  export NAMESPACE="default"
  [ -f /var/run/secrets/kubernetes.io/serviceaccount/namespace ] && export NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`

  echo "Use Namespace: ${NAMESPACE}"

  echo "Create Symlinks..."
  rm -rf $DOCUMENT_ROOT/pub/media && ln -s /kubernetes/nfs/$NAMESPACE/pub/media $DOCUMENT_ROOT/pub/media

  if [ "${USE_SHARED_STATICS}" == "True" ]; then
    echo "Use shared static ... create symlink"
    rm -rf $DOCUMENT_ROOT/pub/static && ln -s /kubernetes/nfs/$NAMESPACE/pub/static $DOCUMENT_ROOT/pub/static
  fi

  kubectl -n ${NAMESPACE} get configmap magento-app--etc -o jsonpath="{.data.env\.php}" > ${DOCUMENT_ROOT}/app/etc/env.php
  chown www-data:www-data ${DOCUMENT_ROOT}/app/etc/env.php

fi

mkdir -p --mode=777 $DOCUMENT_ROOT/var/report $DOCUMENT_ROOT/var/log
chown www-data:www-data $DOCUMENT_ROOT/var/report $DOCUMENT_ROOT/var/log

echo "END Magento Bootstrap"
