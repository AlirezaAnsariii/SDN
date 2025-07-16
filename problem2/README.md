# Simple Container Runtime

This project implements a minimal container runtime, simulating Docker-like functionality using Linux namespaces and `chroot`.

- Uses separate namespaces: `net`, `mnt`, `uts`, `pid`
- Launches an isolated `bash` shell with:
  - Custom hostname
  - Independent process tree (PID namespace)
  - Minimal Ubuntu 20.04 filesystem (via debootstrap)
- [Bonus] Optional memory limit using cgroups


Make sure the following packages are installed:

```bash
sudo apt update
sudo apt install debootstrap -y
