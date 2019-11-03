## [Testing Kafka Streams](https://kafka.apache.org/23/documentation/streams/developer-guide/testing.html)

### Importing the test utilities

```
# Note: add to pom.xml
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-streams-test-utils</artifactId>
    <version>${kafka.version}</version>
    <scope>test</scope>
</dependency>
```

### Testing a Streams application

```
`TopologyTestDriver` pipes records through a `Topology`
`StreamsBuilder` helps build a `Topology`
`ConsumerRecordFactory` helps create key-value records
`ProducerRecord` helps read results
`OutputVerifier` verifies results
```

`TopologyTestDriver` supports event-time and wall-clock-time punctuations.  
`TopologyTestDriver` can access the `KeyValueStore`.  
Always close the `TopologyTestDriver`.  

### Unit Testing Processors

If you write a `Processor` using `Processor API`, you will want to test it.  

TODO
