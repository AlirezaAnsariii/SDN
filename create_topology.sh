#!/bin/bash
set -e

ip netns del node1 2>/dev/null || true
ip netns del node2 2>/dev/null || true
ip netns del router 2>/dev/null || true
ip link del br1 2>/dev/null || true
ip link del br2 2>/dev/null || true

ip netns add node1
ip netns add node2
ip netns add router

ip link add name br1 type bridge
ip link set br1 up
ip link add name br2 type bridge
ip link set br2 up

ip link add veth-node1 type veth peer name veth-node1-br
ip link set veth-node1 netns node1
ip link set veth-node1-br master br1
ip link set veth-node1-br up

ip link add veth-node2 type veth peer name veth-node2-br
ip link set veth-node2 netns node2
ip link set veth-node2-br master br2
ip link set veth-node2-br up

ip link add veth-r1 type veth peer name veth-r1-br
ip link set veth-r1 netns router
ip link set veth-r1-br master br1
ip link set veth-r1-br up

ip link add veth-r2 type veth peer name veth-r2-br
ip link set veth-r2 netns router
ip link set veth-r2-br master br2
ip link set veth-r2-br up

# node1
ip netns exec node1 ip link set lo up
ip netns exec node1 ip link set veth-node1 up
ip netns exec node1 ip addr add 172.0.0.2/24 dev veth-node1
ip netns exec node1 ip route add default via 172.0.0.1

# node2
ip netns exec node2 ip link set lo up
ip netns exec node2 ip link set veth-node2 up
ip netns exec node2 ip addr add 10.10.1.2/24 dev veth-node2
ip netns exec node2 ip route add default via 10.10.1.1

# router
ip netns exec router ip link set lo up
ip netns exec router ip link set veth-r1 up
ip netns exec router ip link set veth-r2 up
ip netns exec router ip addr add 172.0.0.1/24 dev veth-r1
ip netns exec router ip addr add 10.10.1.1/24 dev veth-r2
ip netns exec router sysctl -w net.ipv4.ip_forward=1 >/dev/null
