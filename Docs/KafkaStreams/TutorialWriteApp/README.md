## [Tutorial: Write a Kafka Streams Application](https://kafka.apache.org/23/documentation/streams/tutorial)

### Setup

Note: don't follow the source tutorial. It doesn't work.

Copy the sample project from this directory.  

### Pipe

```
`StreamsConfig`: configuration values
`StreamsBuilder`: builds a computational logic topology
`KafkaStreams`: generates records from the input Kafka topic
`Topology`: computational logic
```

You can run the sample project using the script in the same project.  

### Line Split

```
`.flatMapValues`: modifies values of newly created records based on the the original record
```

### Wordcount

Changelog streams require output topics with log compaction.  

```
`.groupBy`: generates a grouped stream keyed on a value
`.count`: counts events
`.toStream`: transform a KTable to a KStream
`Materialized`: store data in a state store that can be queried
```

Creates two topologies:  
1) from source topic to repartition sink topic
2) from repartition source topic to sink topic

Repartition topic is used to "shuffle" the source stream by its aggregation key.  
