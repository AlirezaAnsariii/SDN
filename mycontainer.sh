
#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <hostname> [memory_limit_MB]"
  exit 1
fi

HOSTNAME=$1
MEM_LIMIT_MB=$2
ROOTFS="/containers/ubuntu-rootfs"

if [ ! -z "$MEM_LIMIT_MB" ]; then
  CGROUP_NAME="mycontainer-$$"
  mkdir -p /sys/fs/cgroup/memory/$CGROUP_NAME
  echo "$((MEM_LIMIT_MB*1024*1024))" > /sys/fs/cgroup/memory/$CGROUP_NAME/memory.limit_in_bytes
fi

sudo unshare --fork --pid --mount --uts --net --mount-proc \
  chroot $ROOTFS /bin/bash -c "
    hostname $HOSTNAME
    mount -t proc proc /proc
    if [ ! -z \"$MEM_LIMIT_MB\" ]; then
      echo $$ > /sys/fs/cgroup/memory/$CGROUP_NAME/tasks
    fi
    exec /bin/bash
"
