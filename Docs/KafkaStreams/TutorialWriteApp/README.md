## [Tutorial: Write a Kafka Streams Application](https://kafka.apache.org/23/documentation/streams/tutorial)

### Setup

Note: don't follow their advice; it doesn't work

Copy the sample project from this directory.  

### Pipe

```
`StreamsConfig`: configuration values
`StreamsBuilder`: builds a computational logic topology
`KafkaStreams`: generates records/messages from the input Kafka topic
`Topology`: computational logic
```

You can run the sample project using the script in the same project.  

### Line Split

```
`.flatMapValues`:
```

### Wordcount

Changelog streams require output topics with log compaction.  

```
`.groupBy`: generates a grouped stream keyed on a value
`.count`: counts events
`toStream`:
`Materialized`: store data in a state store which can be queried
```

TODO
As we can see above, the topology now contains two disconnected sub-topologies. The first sub-topology's sink node KSTREAM-SINK-0000000004 will write to a repartition topic Counts-repartition, which will be read by the second sub-topology's source node KSTREAM-SOURCE-0000000006. The repartition topic is used to "shuffle" the source stream by its aggregation key, which is in this case the value string. In addition, inside the first sub-topology a stateless KSTREAM-FILTER-0000000005 node is injected between the grouping KSTREAM-KEY-SELECT-0000000002 node and the sink node to filter out any intermediate record whose aggregate key is empty. 

Creates two topologies:  
1) from source topic to repartition sink ("shuffle")  
2) shuffle to reduce  
