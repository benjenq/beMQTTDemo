/*
  Basic MQTT example

  This sketch demonstrates the basic capabilities of the library.
  It connects to an MQTT server then:
  - publishes "hello world" to the topic "outTopic"
  - subscribes to the topic "inTopic", printing out any messages
    it receives. NB - it assumes the received payloads are strings not binary

  It will reconnect to the server if the connection is lost using a blocking
  reconnect function. See the 'mqtt_reconnect_nonblocking' example for how to
  achieve the same result without blocking the main loop.

*/
/*W5100 Ethernet shield to connect to network */
#include <SPI.h>
#include <Ethernet.h>
#include <PubSubClient.h>

// Update these with values suitable for your network.
byte mac[]    = {  0xDE, 0xED, 0xBA, 0xFE, 0xFE, 0xED };
IPAddress ip(192, 168, 31, 177);
/*server: IP Address or Domain name. Choose one */
//IPAddress server(192, 168, 31, 153);
const char* server = "broker.mqtt-dashboard.com";

int iPinLed = 9; //pwn pin: 3.5.6.9.10.11, choose pin 9 for led

int brightness = 0;
int fadeAmount = 5;
int delayDurion = 30;

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  String fanStr = "";

  for (int i = 0; i < length; i++) {
    fanStr = fanStr + (char)payload[i];
    Serial.print((char)payload[i]);
  }

  delay(100);

  if (fanStr == "Start Fan") { //Fade in
    brightness = 0;
    while (brightness <= 255 && brightness >= 0) {
      analogWrite(iPinLed, brightness);
      delay(delayDurion);
      brightness = brightness + fadeAmount ;
    }
    delay(delayDurion);
  }
  else if (fanStr == "Stop Fan") { //Fade out
    brightness = 255;
    while (brightness <= 255 && brightness >= 0) {  
      analogWrite(iPinLed, brightness);
      delay(delayDurion);
      brightness = brightness - fadeAmount ;
    }
    delay(delayDurion);
  }

  Serial.println();
}

EthernetClient ethClient;
PubSubClient client(ethClient);

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("arduinoClient")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      // client.publish("Lab/CoolFan","hello world");
      // ... and resubscribe
      client.subscribe("Lab/CoolFan");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void setup()
{
  pinMode(iPinLed, OUTPUT);
  Serial.begin(9600);

  client.setServer(server, 1883);
  client.setCallback(callback);

  Ethernet.begin(mac, ip);
  // Allow the hardware to sort itself out
  delay(1500);
}

void loop()
{
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}
