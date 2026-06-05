# Network Share Modules

This directory defines the shared NFS export module and its helper.

## Layout

- `nfs-export-tree.nix`: helper that bind-mounts real paths onto `/srv/nfs/*`
  and exports them through NFS
- `network-share.nix`: shared module that selects the right export set based on
  the current host

## How It Works

Each exported directory is exposed under `/srv/nfs/<share-name>` using a bind
mount. NFS then exports those `/srv/nfs/*` paths.

Example manual client mount:

```bash
sudo mount -t nfs -o vers=3 desktop:/srv/nfs/file-data /mnt/file-data
sudo mount -t nfs -o vers=3 server:/srv/nfs/draft-notes /mnt/draft-notes
```

## Mounting Notes

These shares are currently easiest to consume with NFSv3-style numeric
UID/GID handling. If a client does a plain `mount -t nfs ...` and ends up on an
NFSv4 mount with unresolved identity mapping, ownership can show up as
`nobody:nogroup` or `65534:65534`, and a `770` directory can reject writes even
when Unix groups look correct locally.

If that happens, either:

- mount with `-o vers=3`, or
- configure matching NFSv4 id-mapping on both client and server

The helper mount script should therefore default to `vers=3` unless you are
intentionally testing an NFSv4 setup.

## Current Setup

- `desktop`: exports the same paths and read-only/read-write policy as the
  desktop branch in `modules/system/samba.nix`
- `server`: exports the same paths and read-only/read-write policy as the
  server branch in `modules/system/samba.nix`
- `laptop`: no exports; intended to mount shares manually as a client

Home-based exports are defined via a small host map with an explicit
`userHome` string. That keeps the NFS module predictable and avoids
module-evaluation recursion.

The export ACL defaults to `192.0.2.0/24`. If that subnet changes, update the
`clients` value in the host module.
