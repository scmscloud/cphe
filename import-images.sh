#!/bin/bash

REMOTE="registry.k8s.io";
VERSION="v1.26.0";
MIRROR="registry.sigma.fr/kubeception";

APPS=("kube-apiserver" "kube-controller-manager" "kube-scheduler");

for APP in "${APPS[@]}"; do
	podman pull "${REMOTE}/${APP}:${VERSION}"
	podman tag "${REMOTE}/${APP}:${VERSION}" "${MIRROR}/${APP}:${VERSION}"
	podman push "${MIRROR}/${APP}:${VERSION}"
done
