apk add curl jq > /dev/null

# Usage: ./node-monitor.sh testnet testnet.your-node.com
network="$1"                                # mainnet | testnet
node_url="$2"                               # e.g. testnet.your-node.com
sync_ref_node_url="${network}-financialserver.coti.io"
unsync_tolerance=10
RESTART_COMMAND="docker-compose -f /coti-node/docker-compose.yml restart coti-node"

function get_last_index() {
  echo "$(curl -s "https://$1/transaction/lastIndex" | jq -r '.lastIndex')"
}

function restart_if_unsynced() {
  echo "Performing sync check: $(date '+%A %d %m %Y %X')"
  local node_url=$1
  local sync_ref_node_url=$2
  local unsync_tolerance=$3
  local node_last_index=$(get_last_index "$node_url")
  local sync_ref_node_last_index=$(get_last_index "$sync_ref_node_url")

  # Check if $node_last_index and $sync_ref_node_last_index are integers
  if ! echo "$node_last_index" | grep -qE '^[0-9]+$' || ! echo "$sync_ref_node_last_index" | grep -qE '^[0-9]+$'; then
    echo "  Error getting last_index. Try again later"
    return 1
  fi

  local index_diff=$((sync_ref_node_last_index - node_last_index))
  if [ $index_diff -gt $unsync_tolerance ]; then
    echo "  Node is unsynced (difference=$index_diff). Performing restart."
    $RESTART_COMMAND
  else
    echo "  Node is synced (difference=$index_diff)."
  fi
}

while true; do
  sleep 600
  echo "Performing status check: $(date '+%A %d %m %Y %X')"
  status_code=$(curl -o /dev/null -s -w '%{http_code}' https://${network}-nodemanager.coti.io/nodes)


  if [ "$status_code" -eq 200 ]; then
    if curl -s https://${network}-nodemanager.coti.io/nodes | grep -q ${node_url}; then
      echo "  Node ${node_url} is connected."
      restart_if_unsynced $node_url $sync_ref_node_url $unsync_tolerance
    else
      echo "  Node not found. Performing restart."
      $RESTART_COMMAND
    fi
  else
    echo "  Node manager returned unusual status code: $status_code"
  fi
done

