set -eu

BOOTSTRAP=localhost:9092
TOPICS=/opt/kafka/bin/kafka-topics.sh

WEEK=604800000 # 7 days
MONTH=2592000000 # 30 days
FOREVER=-1 # forever

create() {
  echo "-> $1 (retention $2"
  "$TOPICS" --bootstrap-server "$BOOTSTRAP" --create --if-not-exists \
    --topic "$1" --partitions 3 --replication-factor 1 \
    --config retention.ms="$2"
}

create ledger.commands "$WEEK"
create screening.commands "$WEEK"
create transfer.replies "$WEEK"

create transfer.events "$FOREVER"
create ledger.events "$FOREVER"
create screening.events "$FOREVER"

for t in ledger.commands screening.commands transfer.replies transfer.events ledger.events customer.events; do
  create "$t.dlq" "$MONTH"
done

echo "Done. Topics now:"
"$TOPICS" --bootstrap-server "$BOOTSTRAP" --list