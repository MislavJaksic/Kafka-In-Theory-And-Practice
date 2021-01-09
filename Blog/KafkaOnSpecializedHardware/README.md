## [Enabling Real-Time Processing of Massive Data Streams](https://www.intel.com/content/www/us/en/architecture-and-technology/enabling-real-time-processing-of-massive-data-streams.html)

Kafka on Intel hardware.

The document references a test. I've marked it with [1].
LinkedIn performed a Kafka test 6 years ago. I've marked it with [2].

[1] Test platform configuration by Intel as of 8/21/2020:
* 3-node, 2x Intel® Xeon® Gold 6258R Processors, 28 cores HT On Turbo ON
* Total Memory 384 GB (12 slots/ 32 GB/ 2933 MHz)
* BIOS: SE5C620.86B.02.01.0010.010620200716 (ucode: 0x400002c )
* CentOS 8, 4.18.0-147.8.1.el8_1.x86_64, gcc (GCC) 8.3.1 20190507 (Red Hat 8.3.1-4)
* 100 GB Intel® NIC E810-CQDA2 (3 brokers)
* Confluent Control Center 5.5, NIC X722 10 GB (20 clients)
* Tunings: Open JDK 15, Broker (Java) Memory: 128 GB, Topic config: [1 Topic, 480 Partitions, 3x replications,  2 min_insyn replicas, ack=1(default),0,-1], Open files:16384, Max mmap:225000
* Storage: 4x 4 TB Intel® Optane™ SSD DC P4510 (3D NAND)

[2] [Benchmarking Apache Kafka: 2 Million Writes Per Second (On Three Cheap Machines)](https://engineering.linkedin.com/kafka/benchmarking-apache-kafka-2-million-writes-second-three-cheap-machines):
* 3 machines for Kafka
* 3 machines for Zookeeper and load generation
* Intel Xeon 2.5 GHz processor with six cores
* Six 7200 RPM SATA drives
* 32GB of RAM
* 1Gb Ethernet

### Business Story

#### Solution Benefits

Max 8 Gbps on 10 GbE networking
Max 76 Gbps on 100 GbE network
Max 50 ms latency
SSDs have 6.5x endurance of NVMe storage - A
Near? linear load scaling

#### Intel Technology Further Boosts Apache Kafka Performance

Max 8 Gbps
Performance ingestion rate of max 86 TB data per day on [1] (3.6 TB per hour, 995 MB per second) [Note: 333 MB per second if excluding 3x replication]
SSDs have 6.5x endurance of 3D NAND SSDs - A
10x throughput when upgrading from 10 GbE to 100 GbE network

### Reference Architecture

#### Summary of findings

* Improves network throughput up to 1.2x network throughput (compared to what?)
* Max 5x producer and 9.1x consumer throughput compared to a 2014 benchmark
* SSDs have 6.5x endurance of 3D NAND SSDs
* Linear scaling of throughput and compute when upgrading from 10 GbE to 100 GbE network
* 1.2x better performance when using Open source Java JDK 15

#### Confluent/Apache Kafka Reference Architecture Overview

Figure 4:
* DC 1 has Leader ISR
* DC 2 has Observer Replicas
* DC 3 has an odd Zookeeper to maintain the quorum in case of a failure

#### Historical vs. Current Benchmark Results Show System Components are Critical

When compering tests [1] and [2]:
* 5x producer throughput
* 9.1x consumer throughput
* producers delivered 488 MB/s each
* at 20 producers performance "varied" (decreased!)
* producer throughput is not influenced by thread count

#### Boost Applications with Modern Network (100 GbE)

Different I/O and Network thread ratios and producer count:
* 70+40, 14, 12 ms
* 80+30, 14, 20 ms
* 60:32, 14, sharp increase!

Minor thread adjustments create chaotic results.

ACKs have a big impact on performance.

#### Higher-Endurance SSDs Can Lower System Total Costs

Endurance = lifetime drive writes per day, if every cell on the SSD were written to 60 times per day - A

SSDs have 6.5x endurance of 3D NAND SSDs

#### JDK Performance Improvements to Apache Kafka

JDK 15 performance compared to a non-patched build? improves receive, transmit and latency metrics by 1.1x.

#### Recommendations: Intel Technology Significantly Improves Apache Kafka Performance

Links between:
* leaf and spine switches, as well as broker nodes and the spine, should be 100 G
* support nodes and the leaf switch can be 10 G for cost saving purposes
