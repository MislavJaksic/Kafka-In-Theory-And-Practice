## [Run Demo App](https://kafka.apache.org/23/documentation/streams/quickstart)

Run WordCount on an infinite, unbounded stream of data.  

### Step 1 and 2: Start Zookeeper and Kafka

[Instructions](../../QuickStart)

### Step 3: prepare input and output topic

```
$: bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic Input-Topic-Name
$: bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic Output-Topic-Name --config cleanup.policy=compact

# Note: changelog streams require output topics with log compaction
# Note: log compacted topics require a Kafka Stream to output key-value pairs (such as changelog Kafka Streams)
```

### Step 4: start WordCount, Producer and Consumer

```
$: bin/kafka-run-class.sh org.apache.kafka.streams.examples.wordcount.WordCountDemo

$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic Input-Topic-Name
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic Output-Topic-Name --from-beginning --formatter kafka.tools.DefaultMessageFormatter --property print.key=true --property print.value=true --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer

# Note: you will see the following output:
  # abc 1
  # def 8
  # ...
```

### Step 5: process data

Produce a few messages using a console producer.  

Each console producer message will have a:
* key=null
* value=Typed-String

Behind the scene:
* table `KTable<String, Long>` is counting words
* changelog stream `KStream` is a downstream from `KTable` and prints upserted Kafka Stream values

### Step 6: close the Kafka Stream

```
CTRL+C
```
