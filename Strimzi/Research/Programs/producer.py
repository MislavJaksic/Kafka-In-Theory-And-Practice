from kafka import KafkaProducer
from json import dumps
from datetime import datetime
from time import sleep
from random import randint

bootstrap_servers = "Kubectl-Server-Ip:31000"  # change
kafka_topic = "Topic-Name"  # change


def main():
    producer = KafkaProducer(bootstrap_servers=bootstrap_servers)
    dict_generator = create_dict_generator()

    for dict in dict_generator:
        binary_json = tranform_to_binary_json(dict)
        producer.send(topic=kafka_topic, value=binary_json)
        sleep(1)

    producer.close()


def create_dict_generator():
    counter = 0
    anomalyes = ["all", "your", "kafka", "are", "belong", "to", "us"]
    while True:
        timestamp = str(datetime.today())
        counter += 1
        number = randint(0, 2)

        if not anomalyes:
            anomalyes = ["all", "your", "kafka", "are", "belong", "to", "us"]

        if number == 2:
            anomaly = anomalyes.pop()
            yield {"id": "0",
                   "number": number,
                   "anomaly": anomaly,
                   "counter": counter,
                   "timestamp": timestamp}
        else:
            yield {"id": "0",
                   "number": number,
                   "counter": counter,
                   "timestamp": timestamp}


def tranform_to_binary_json(dict):
    json_string = transform_to_json(dict)
    binary_json = encode_to_binary_utf(json_string)
    return binary_json


def transform_to_json(structure):
    return dumps(structure)


def encode_to_binary_utf(string):
    return string.encode("utf-8")


def run():
    main()


if __name__ == "__main__":
    run()
