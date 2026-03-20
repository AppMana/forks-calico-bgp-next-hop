# calico-bgp-next-hop

Patch for [calico/node-windows](https://github.com/projectcalico/calico) that implements `keepOriginalNextHop` on Windows.

Upstream issue: https://github.com/projectcalico/calico/issues/12208

## Problem

Calico's `keepOriginalNextHop` BGPPeer setting has no effect on Windows nodes. The Windows RRAS BGP router always rewrites the next-hop to its own IP when re-advertising routes to eBGP peers. On Linux, Calico's BIRD daemon uses `next hop keep;` in export filters.

## Fix

Windows RRAS supports per-prefix egress routing policies via `Add-BgpRoutingPolicy -NewNextHop`. This patch extends the Windows confd scripts to create these policies for eBGP peers that have `keepOriginalNextHop: true`, preserving the original next-hop from the iBGP mesh.

Changed files (layered on top of `calico/node-windows`):
- `CalicoWindows/confd/config-bgp.psm1` -- added `ProcessBgpNextHopPolicies`
- `CalicoWindows/confd/config-bgp.ps1` -- calls `ProcessBgpNextHopPolicies`
- `CalicoWindows/confd/templates/peerings.ps1.template` -- passes `KeepOriginalNextHop` flag from BGPPeer data

## Building

```
docker build -t harbor.appmana.com/appmana-shared/node-windows:v3.29.6-keephalive -f Dockerfile .
docker push harbor.appmana.com/appmana-shared/node-windows:v3.29.6-keephalive
```

Or use the Tekton automation in the appmana cluster.
