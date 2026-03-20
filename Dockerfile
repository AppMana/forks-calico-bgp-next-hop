ARG BASE_IMAGE=calico/node-windows:v3.29.6
FROM ${BASE_IMAGE}

# Replace confd scripts with keepOriginalNextHop support.
# See: https://github.com/projectcalico/calico/issues/12208
COPY CalicoWindows/confd/config-bgp.ps1 CalicoWindows/confd/config-bgp.ps1
COPY CalicoWindows/confd/config-bgp.psm1 CalicoWindows/confd/config-bgp.psm1
COPY CalicoWindows/confd/templates/peerings.ps1.template CalicoWindows/confd/templates/peerings.ps1.template
