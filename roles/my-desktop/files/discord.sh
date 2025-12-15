#!/bin/bash

NS_NAME="isolated"
VETH_HOST="veth0"
VETH_NS="veth1"
SUBNET="10.200.200.0/24"
HOST_IP="10.200.200.1"
NS_IP="10.200.200.2"

# Создать namespace
sudo ip netns add $NS_NAME 2>/dev/null || echo "Namespace '$NS_NAME' уже существует"

# Создать veth-пару
sudo ip link add $VETH_HOST type veth peer name $VETH_NS
sudo ip link set $VETH_NS netns $NS_NAME

# Настроить хостовую сторону
sudo ip addr add $HOST_IP/24 dev $VETH_HOST
sudo ip link set $VETH_HOST up

# Настроить сторону namespace
sudo ip netns exec $NS_NAME ip addr add $NS_IP/24 dev $VETH_NS
sudo ip netns exec $NS_NAME ip link set $VETH_NS up
sudo ip netns exec $NS_NAME ip link set lo up

# Добавить default route в namespace через хост
sudo ip netns exec $NS_NAME ip route add default via $HOST_IP

# Включить маскарадинг (NAT) через enp6s0
sudo iptables -t nat -A POSTROUTING -s $SUBNET -o enp6s0 -j MASQUERADE
sudo iptables -A FORWARD -i $VETH_HOST -o enp6s0 -j ACCEPT
sudo iptables -A FORWARD -i enp6s0 -o $VETH_HOST -m state --state RELATED,ESTABLISHED -j ACCEPT

# Настроить DNS внутри namespace
sudo mkdir -p /etc/netns/$NS_NAME
echo "nameserver 8.8.8.8" | sudo tee /etc/netns/$NS_NAME/resolv.conf

sudo -E ip netns exec isolated  "/opt/nekoray/nekobox" &

sudo -E ip netns exec isolated su - $USER -c "DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORIT DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS HOME=$HOME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR discord" &
#sudo -E ip netns exec isolated su - $USER -c "DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORIT DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS HOME=$HOME XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR /opt/google/chrome/chrome" &

#sleep 3
#sudo resolvectl dns enp6s0 8.8.8.8 192.168.3.1 && sudo systemctl restart systemd-resolved.service

#sudo systemctl restart openvpn@al.komyakov01
