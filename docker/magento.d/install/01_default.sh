#!/bin/bash
#
# Magento installation script for kubernetes cluster
#
# Author: Martin Weber <martin.weber@de.clara.net>
#

set -x 

export NAMESPACE="default"
[ -f /var/run/secrets/kubernetes.io/serviceaccount/namespace ] && export NAMESPACE=`cat /var/run/secrets/kubernetes.io/serviceaccount/namespace`

echo "Use Namespace: ${NAMESPACE}"

echo "Create Directories..."
mkdir -p /kubernetes/nfs/$NAMESPACE/pub/media \
         /kubernetes/nfs/$NAMESPACE/pub/static \
         /kubernetes/nfs/$NAMESPACE/var/report
chmod a+w -R /kubernetes/nfs/$NAMESPACE/

# vim: sw=2 sts=2
