const mqtt = require('mqtt');
const TestController = require('../src/mqttcontrollers/test/TestController')
const GenqrcodeController = require('../src/mqttcontrollers/qrcode/gencodepayment')
const NotiController = require('../src/mqttcontrollers/noti/noti')

class MqttHandler {
    constructor(host) {
        this.mqttClient = mqtt.connect(host);
    }

    connect() {
        var mqtts = this.mqttClient

        // Connect mqtt with credentials (in case of needed, otherwise we can omit 2nd param)
        // const mqttClient = mqtt.connect(host);
        // this.mqttClients = mqtt.connect(host);

        // Mqtt error calback
        this.mqttClient.on('error', (err) => {
            console.log(err);
            this.mqttClient.end();
        });

        // Connection callback
        this.mqttClient.on('connect', () => {
            console.log(`mqtt client connected`);
        });

        // mqtt subscriptions
        this.mqttClient.subscribe('outTopic');
        this.mqttClient.subscribe('payment');
        this.mqttClient.subscribe('mytopic');
        this.mqttClient.subscribe('noti');

        // When a message arrives, console.log it
        this.mqttClient.on('message', async function (topic, message) {
            console.log(topic)
            console.log(message.toString());
            if (topic.toString() === "mytopic") {
                const test = await TestController.Test(JSON.parse(message.toString()))
                await mqtts.publish('outTopic', "YES");
            }
            if (topic.toString() === "payment") {
                console.log("IN")
                const test = await GenqrcodeController.genqrcode(message.toString())
                await mqtts.publish(test.id, "qr," + test.qr);
            }
            if (topic.toString() === "noti") {
                console.log("IN")
                await NotiController.linenoti(message.toString())
            }
            // this.sendMessage("iiii","uuu")
        });

        this.mqttClient.on('close', () => {
            console.log(`mqtt client disconnected`);
        });

    }
    // Sends a mqtt message to topic: mytopic
    sendMessage(topic, message) {
        console.log("iiiiii")
        this.mqttClient.publish(topic, message);
    }
}

module.exports = MqttHandler;