## [Core Concepts](https://kafka.apache.org/23/documentation/streams/core-concepts)

Kafka Streams knows the difference between event time and processing time and supports windowing.  

Kafka Streams leverages Kafka's parallelism model.  
Kafka Streams features:  
* simple and lightweight
* no external dependencies
* fault-tolerant local state
* exactly-once processing
* one-record-at-a-time processing
* event-time based windowing operations
* high-level Streams DSL
* low-level Processor API

### Stream Processing Topology

```
Stream: ordered, re-playable, and fault-tolerant sequence of immutable data records
Data record: key-value pair
Processor topology: graph of stream processors (vertices, nodes) connected by streams (edges)
Stream processor: receives one input record at a time, applies an operation, produces output records
```

```
Source Processor: has no upstream processors, but consumes records from Kafka topics
Sink Processor: has no down-stream processors, but produces records for a Kafka topic
```

Other remote systems can be accessed while processing a record.  

```
Kafka Streams DSL: provides map, filter, join, aggregation, ...
Processor API: provides custom processors and interaction with the state store
```

A processor topology is an abstraction which is translated into parallel processes.  

### Time

Timestamps are embedded into Kafka records.  
Timestamps either represent event-time or ingestion-time.  
Depends on the topic and Kafka broker settings.  

Event-time:
* when a record is created

Ingestion-time:
* greater then event-time
* when a record is appended to a Kafka topic

Processing-time:
* greater then ingestion-time
* when the record is processed


Kafka Streams timestamps records using the `TimestampExtractor` interface.  
These stamps are used by time sensitive Kafka Streams operations (windowing).  

Kafka Streams timestamps when writing records to a topic:  
* output record timestamps are inherited from input record timestamps directly if new output records are generated via processing some input record
* output record timestamp is defined as the current internal time of the stream task when new output records are generated via periodic functions
* for aggregations the timestamp of a aggregate update record is that of the latest arrived input record

This default behaviour can be changed in the Processor API with `#forward()`.

### Aggregations

It takes a stream or table, combines records into a new record     and yields a new table.  
Kafka Streams DSL uses a KStream or a KTable and the output will be a KTable.  

Late arrivals make the aggregating KStream or KTable emit a new aggregate value. The output KTable will update the key to a new value.  

### Windowing

Windowing groups records by a record key into windows.  

You can specify how long a window will wait, a retention period.  
Late records exist only in event-time or ingestion-time semantics because, by definition, processing-time records can never be late.  

### Duality of Streams and Tables

Stream processing require streams and databases.  
Stream-table duality means:
* a stream can be viewed as a table
* a table can be viewed as a stream

### States

State stores store and query data through `Interactive Queries`.  

### Processing Guarantees

Once and only once record processing can be achieved.  

Producers can send records to topic partitions in a transactional and idempotent manner.  
Set `processing.guarantee` configuration value to `exactly_once` (default is `at_least_once`).  

### Out-of-Order Handling

Caused by:
* records with larger timestamps (but smaller offsets) are processed earlier than records with smaller timestamps (but larger offsets) in the same topic partition
* within a stream task processing multiple topic partitions, records with smaller timestamps might be processed first

If users want to handle out-of-order records they need to make trade-off decisions between latency, cost, and correctness.  
