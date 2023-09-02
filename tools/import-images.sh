#!/bin/bash

### Kubernetes internal services

REMOTE="registry.k8s.io";
VERSIONS=("v1.25.0" "v1.26.0" "v1.27.0");
MIRROR="registry.sigma.fr/kubeception";
APPS=("kube-apiserver" "kube-controller-manager" "kube-scheduler" "kube-proxy");
for VERSION in ${VERSIONS[@]}; do
	for APP in "${APPS[@]}"; do
		podman pull "${REMOTE}/${APP}:${VERSION}"
		podman tag "${REMOTE}/${APP}:${VERSION}" "${MIRROR}/${APP}:${VERSION}"
		podman push "${MIRROR}/${APP}:${VERSION}"
	done
done

### Kubernetes SIGs services

# Konnectivity
VERSIONS=("v0.0.37");
for VERSION in ${VERSIONS[@]}; do
	podman pull "${REMOTE}/kas-network-proxy/proxy-server:${VERSION}"
	podman pull "${REMOTE}/kas-network-proxy/proxy-agent:${VERSION}"
	podman tag "${REMOTE}/kas-network-proxy/proxy-server:${VERSION}" "${MIRROR}/konnectivity-server:${VERSION}"
	podman tag "${REMOTE}/kas-network-proxy/proxy-agent:${VERSION}" "${MIRROR}/konnectivity-agent:${VERSION}"
	podman push "${MIRROR}/konnectivity-server:${VERSION}"
	podman push "${MIRROR}/konnectivity-agent:${VERSION}"
done

### External Kubernetes services

# ETCD database
VERSIONS=("v3.5.7" "v3.5.8" "v3.5.9");
for VERSION in ${VERSIONS[@]}; do
        podman pull "quay.io/coreos/etcd:${VERSION}"
        podman tag "quay.io/coreos/etcd:${VERSION}" "${MIRROR}/etcd:${VERSION}"
        podman push "${MIRROR}/etcd:${VERSION}"
done

# Kubernetes dashboard
VERSIONS=("v2.6.1" "v2.7.0");
for VERSION in ${VERSIONS[@]}; do
        podman pull "docker.io/kubernetesui/dashboard:${VERSION}"
        podman tag "docker.io/kubernetesui/dashboard:${VERSION}" "${MIRROR}/dashboard:${VERSION}"
        podman push "${MIRROR}/dashboard:${VERSION}"
done
