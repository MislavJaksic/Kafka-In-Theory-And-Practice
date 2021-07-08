## [kafkcat](https://github.com/edenhill/kafkacat)

Apache Kafka Command Line Interface (CLI) for producing and consuming Kafka Records, a netcat for Kafka.  

### Install

```
$: apt install kafkacat
```

### Usage

```
$: kafkacat -b localhost:9092 -G mygroup topic1 topic2

Read messages from stdin, produce to 'test-topic' topic with snappy compression

$: tail -f /var/log/test-topic | kafkacat -b localhost:9092 -t test-topic -z snappy

Read messages from Kafka 'test-topic' topic, print to stdout

$: kafkacat -b localhost:9092 -t test-topic

Produce messages from file (one file is one message)

$: kafkacat -P -b localhost:9092 -t filedrop -p 0 myfile1.bin /etc/motd thirdfile.tgz

Produce messages transactionally (one single transaction for all messages):

$: kafkacat -P -b localhost:9092 -t mytopic -X transactional.id=myproducerapp

Read the last 2000 messages from 'test-topic' topic, then exit

$: kafkacat -C -b localhost:9092 -t test-topic -p 0 -o -2000 -e

Consume from all partitions from 'test-topic' topic

$: kafkacat -C -b localhost:9092 -t test-topic

Output consumed messages in JSON envelope:

$: kafkacat -b localhost:9092 -t test-topic -J

Decode Avro key (-s key=avro), value (-s value=avro) or both (-s avro) to JSON using schema from the Schema-Registry:

$: kafkacat -b localhost:9092 -t ledger -s avro -r http://schema-registry-url:8080

Decode Avro message value and extract Avro record's "age" field:

$: kafkacat -b localhost:9092 -t ledger -s value=avro -r http://schema-registry-url:8080 | jq .payload.age

Decode key as 32-bit signed integer and value as 16-bit signed integer followed by an unsigned byte followed by string:

$: kafkacat -b localhost:9092 -t mytopic -s key='i$:' -s value='hB s'

Hint: see ./kafkacat -h for all available deserializer options.

Output consumed messages according to format string:

$: kafkacat -b localhost:9092 -t test-topic -f 'Topic %t[%p], offset: %o, key: %k, payload: %S bytes: %s\n'

Read the last 100 messages from topic 'test-topic' with librdkafka configuration parameter 'broker.version.fallback' set to '0.8.2.1' :

$: kafkacat -C -b localhost:9092 -X broker.version.fallback=0.8.2.1 -t test-topic -p 0 -o -100 -e

Produce a tombstone (a "delete" for compacted topics) for key "abc" by providing an empty message value which -Z interpretes as NULL:

$: echo "abc:" | kafkacat -b localhost:9092 -t mytopic -Z -K:

Produce with headers:

$: echo "hello there" | kafkacat -b localhost:9092 -H "header1=header value" -H "nullheader" -H "emptyheader=" -H "header1=duplicateIsOk"

Print headers in consumer:

$: kafkacat -b localhost:9092 -C -t mytopic -f 'Headers: %h: Message value: %s\n'

Enable the idempotent producer, providing exactly-once and strict-ordering producer guarantees:

$: kafkacat -b localhost:9092 -X enable.idempotence=true -P -t mytopic ....

Connect to cluster using SSL and SASL PLAIN authentication:

$: kafkacat -b localhost:9092 -X security.protocol=SASL_SSL -X sasl.mechanism=PLAIN -X sasl.username=myapikey -X sasl.password=myapisecret ...

Metadata listing:

$: kafkacat -L -b localhost:9092
Metadata for all topics (from broker 1: localhost:9092:9092/1):
 3 brokers:
  broker 1 at localhost:9092:9092
  broker 2 at localhost:9092too:9092
  broker 3 at thirdbroker:9092
 16 topics:
  topic "test-topic" with 3 partitions:
    partition 0, leader 3, replicas: 1,2,3, isrs: 1,2,3
    partition 1, leader 1, replicas: 1,2,3, isrs: 1,2,3
    partition 2, leader 1, replicas: 1,2, isrs: 1,2
  topic "rdkafkatest1_auto_49f744a4327b1b1e" with 2 partitions:
    partition 0, leader 3, replicas: 3, isrs: 3
    partition 1, leader 1, replicas: 1, isrs: 1
  topic "rdkafkatest1_auto_e02f58f2c581cba" with 2 partitions:
    partition 0, leader 3, replicas: 3, isrs: 3
    partition 1, leader 1, replicas: 1, isrs: 1
  ....

JSON metadata listing

$: kafkacat -b localhost:9092 -L -J

Pretty-printed JSON metadata listing

$: kafkacat -b localhost:9092 -L -J | jq .

Query offset(s) by timestamp(s)

$: kafkacat -b localhost:9092 -Q -t mytopic:3:2389238523 -t mytopic2:0:18921841

Consume messages between two timestamps

$: kafkacat -b localhost:9092 -C -t mytopic -o s@1568276612443 -o e@1568276617901

```

```
1098  kafkacat
 1099  
 1100  kafkacat
 1101  
 1102  kafkacat -b 172.23.97.48:31000 -C -t order-tester-demo -f '%t %p @ %o: %s\n' > output-order-tester-demo.txt
 1103  kafkacat -b 172.23.97.48:31000 -C -t order-tester-demo -f '%t %p @ %o: %s\n' > output-order-tester-demo-new.txt
 1104  kafkacat -b 172.23.97.48:31000 -C -t order-tester-demo-new -f '%t %p @ %o: %s\n' > output-order-tester-demo-new.txt
 1105  kafkacat -b 172.23.97.48:31000 -C -t order-tester-demo-flight -f '%t %p @ %o: %s\n' > output-order-tester-demo-flight.txt
 1207  kafkacat
 1208  kafkacat -b 172.23.97.48:31000 -t druid-metrics-0-18-1 > kafkacat.txt
 1209  kafkacat -b 172.23.97.48:31000 -t druid-metrics-0-18-1 > kafkacat.json
 1238  kafkacat
 1239  history | grep kafkacat
 1240  kafkacat -b 172.23.97.48:31000 -C -t druid-metrics-0-18-1 -f '%t %p @ %o: %s\n' > topic-output.txt
 1244  kafkacat -b 172.23.97.48:31000 -C -t druid-metrics-0-18-1 -f '%t %p @ %o: %s\n' > topic-output-5min-later.txt
 1245  kafkacat
 1246  kafkacat -b 172.23.97.48:31000 -C -t druid-metrics-0-18-1 -o 3853102641 -f '%t %p @ %o: %s\n' > topic-output-first-offset.txt
 1248  kafkacat -b 172.23.97.48:31000 -C -t mmsc-mirror-mmsc -f '%t %p @ %o: %s\n' > topic-mmsc-mirror.txt
 1567  kafkacat
 1568  kafkacat -b 172.23.97.48:31000 -G kc-test fastcapa-out
 1569  kafkacat -b 172.23.97.48:31000 kafkacat -t fastcapa-out
 1570  kafkacat -b 172.23.97.48:31000 -t fastcapa-out
 1571  kafkacat -b 172.23.97.48:31000 -t fastcapa-out -o beginning
 1572  kafkacat -b 172.23.97.48:31000 -t fastcapa-out -o-o beginning
 1573  kafkacat -b 172.23.97.48:31000 -t fastcapa-out -o beginning
 1574  kafkacat -b 172.23.97.48:31000 -t faoffline-pcap-raw -o beginning
 1575  kafkacat -b 172.23.97.48:31000 -t offline-pcap-raw -o beginning
 1576  kafkacat -b 172.23.97.48:31000 -t ofpcap-event-bus-offline -o beginning
 1577  kafkacat -b 172.23.97.48:31000 -t pcap-event-bus-offline -o beginning
 1578  kafkacat -b 172.23.97.48:31000 -t pcpcap-event-bus -o beginning
 1579  kafkacat -b 172.23.97.48:31000 -t pcap-event-bus -o beginning
 1927  kafkacat
 1928  kafkacat -b 10.64.1.7:31000 -t online-pcap-raw
 1929  kafkacat -b 10.64.1.7:31000 -t offline-pcap-decoded
 1978  kafkacat
 1979  kafkacat -L -b 172.23.97.86:9092
 2002  kafkacat
 2003  kafkacat -b 172.23.97.86:9092 -t fastcapa-out -p 0 > output.txt
 2004  kafkacat -b 172.23.97.86:9092 -t fastcapa-out -p 0
 2005  kafkacat -b 172.23.97.86:9092 -t fastcapa-out -p 0 -f 'Topic %t[%p], offset: %o, key: %k, payload: %S bytes: %s\n'
 2006  kafkacat -b 172.23.97.86:9092 -t fastcapa-out -p 0 -f 'Topic %t[%p], offset: %o, k bytes: %s\n'
 2007  history | grep kafkacat
docker run -it --rm edenhill/kafkacat
OR
kafkacat
 -C -b 172.22.68.100:9092 -t nims-ca-pm-mav -p 0 -o -2 -e -f 'Topic %t[%p], offset: %o, timestamp: %T, key: %k, payload: %S bytes: %s\n'
```
