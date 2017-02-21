beMQTTDemo
===============
A  iOS app to show how MQTT work.
用 iOS app 模擬展示 MQTT 協定的物聯網環境。

![GitHub](https://github.com/benjenq/beMQTTDemo/blob/master/beMQTTDemo/Images/LaunchImage/Default@2x.png "icon,benjenq")

## How to Use?
如何使用？

### 1. Create a MQTT broker service first.
#### 先建立 MQTT 伺服器。

A lot of version and way to build MQTT broker server. For windows example:
建立 MQTT 主機服務有很多種版本和方式。用 Windows  版本為例

####(1)go to https://mosquitto.org/download/ and download win32 version (mosquitto-x.x.xx-install-win32.exe)。
到 https://mosquitto.org/download/ 下載 mosquitto-x.x.xx-install-win32.exe 。

####(2)Install mosquitto-x.x.xx-install-win32.exe。Following the install process. Simpply!
安裝  mosquitto-x.x.xx-install-win32.exe。照著安裝流程的指示，很簡單。

### 2. Start a MQTT broker service.
啟動  MQTT broker 服務。

Use command console, execute "C:\Program files (x32)\mosquitto\mosquitto.exe" -v
使用 Command console 視窗，執行指令 "C:\Program files (x32)\mosquitto\mosquitto.exe" -v

Now we have a real/simple MQTT broker server. This demo project need it.Remember the server ip address and port munber (shown on the windows console)。
現在我們有了真實又簡單的 MQTT 服務主機。本專案需要它，請記下主機的 ip 位址和使用的埠號（埠號會顯示在 Windows 的 console 視窗）。



## How it work?
如何運作？

### iOS App 版: Use Xcode to compile & build app。
- iOS 版本：使用 Xcode 編譯運行。

see the movie : https://youtu.be/l7yAkBQzLUM

觀看影片 https://youtu.be/l7yAkBQzLUM

### Arduino: for Arduino UNO with Ethernet shield W5100 module. Use Arduino IDE to build it.
Arduino 版：Arduino UNO 搭配 W5100 網卡模組。使用 Arduino IDE 開發工具。

#### Source Code in ArduinoUno_W5100/bemqtt_arduinoUno_basic/*.ino
程式碼在 ArduinoUno_W5100/bemqtt_arduinoUno_basic/*.ino

- Compile & build into Arduino UNO via Arduino IDE. Need to modify code to your real IPAddress & MQTT server ip.
- 編譯安裝到 Arduino UNO 設備上。程式碼內必須修改為您的實際 IP 位址。

- The code show that when Arduino Uno get a "Start Fan" and "Stop Fan" message will turn pin 9 on/off.Use led plug on pin 9 to see the  result.
- 程式碼表示當收到 "Start Fan" 和 "Stop Fan" 訊息指令時，對應 pin9 腳位輸出的開啟或關閉。可在 pin 9 腳位插入 led 元件來顯示這結果。


### Esp8266: for Esp8266 wifi module. Use Arduino IDE to build it.
Esp8266 版：對應 Esp8266 無線模組。使用 Arduino IDE 開發工具。

#### Source Code: in Esp8266/bemqtt_esp8266_basic/*.ino
程式碼在 Esp8266/bemqtt_esp8266_basic/*.ino

- Compile & build into Esp8266 via Arduino IDE. Need to modify code to wifi ap ssid/password & MQTT server ip.
- 編譯安裝到 Esp8266 模組上。程式碼內必須修改對應的無線網路 ssid 和密碼，以及 MQTT 服務伺服器位址。

- The code show that when Esp8266 connected to internet and get a "Start Fan" and "Stop Fan" message will turn GPIO2 on/off. Use led plug on GPIO2 to see the result.
- 程式碼表示當 Esp8266 連網後收到"Start Fan"和"Stop Fan"訊息指令時，對應 GPIO2 腳位輸出的開啟或關閉。可在 GPIO2 腳位插上 led 元件來顯示這結果。
