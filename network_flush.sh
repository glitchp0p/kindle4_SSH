cat > network-setup.sh << 'EOF'
#!/bin/bash

# Generic USB Network Device Setup Script
# Usage: ./network-setup.sh <interface> <host_ip> [target_ip]
# Example: ./network-setup.sh enxee4900000000 192.168.15.201 192.168.15.244

INTERFACE="$1"
HOST_IP="$2"
TARGET_IP="$3"

# Validate arguments
if [ -z "$INTERFACE" ] || [ -z "$HOST_IP" ]; then
    echo "Usage: $0 <interface> <host_ip> [target_ip]"
    echo "Example: $0 enxee4900000000 192.168.15.201 192.168.15.244"
    echo ""
    echo "Available interfaces:"
    ip link show | grep -E "^[0-9]+" | cut -d: -f2 | tr -d ' ' | grep -v lo
    exit 1
fi

# Check if interface exists
if ! ip link show "$INTERFACE" >/dev/null 2>&1; then
    echo "❌ Interface $INTERFACE not found"
    echo "Available interfaces:"
    ip link show | grep -E "^[0-9]+" | cut -d: -f2 | tr -d ' ' | grep -v lo
    exit 1
fi

echo "🔧 Configuring interface: $INTERFACE"
echo "🏠 Host IP: $HOST_IP"
[ -n "$TARGET_IP" ] && echo "🎯 Target IP: $TARGET_IP"

# Step 1: Stop NetworkManager from interfering
echo "📡 Disabling NetworkManager control..."
sudo nmcli device set "$INTERFACE" managed no 2>/dev/null || echo "   (nmcli not available or failed - continuing)"

# Step 2: Flush existing configuration
echo "🧹 Flushing existing IP configuration..."
sudo ip addr flush dev "$INTERFACE"

# Step 3: Assign new IP
echo "🔗 Assigning IP address..."
sudo ip addr add "$HOST_IP/24" dev "$INTERFACE"

# Step 4: Bring interface up
echo "⬆️  Bringing interface up..."
sudo ip link set "$INTERFACE" up

# Step 5: Verify configuration
echo "✅ Configuration complete!"
echo ""
echo "Interface status:"
ip addr show "$INTERFACE" | grep inet
echo ""
echo "Routes:"
ip route show dev "$INTERFACE"

# Step 6: Test connectivity if target IP provided
if [ -n "$TARGET_IP" ]; then
    echo ""
    echo "🏓 Testing connectivity to $TARGET_IP..."
    if ping -c 3 -W 2 "$TARGET_IP" >/dev/null 2>&1; then
        echo "✅ Connection successful!"
        echo "🚀 Ready for: ssh root@$TARGET_IP"
    else
        echo "❌ Connection failed - device may not be ready"
    fi
fi
EOF

chmod +x network-setup.sh
