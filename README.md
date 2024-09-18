# *Design and development of an embedded system for monitoring the running quality of an athlete*

## *Overview*

The system initially collects data detected by the sensors of an Arduino electronic board, and then trains a machine learning algorithm capable of identifying different types of running. To this end, an Arduino Nano 33 BLE Sense device was used, which collects values ​​​​relating to the accelerometer, gyroscope and magnetometer during running. In our case, the focus was on different types of running, such as optimal running and fatigued running. The acquired data is transmitted to a mobile device connected to the electronic board via Bluetooth Low Energy (BLE) technology, using an application developed with the Flutter Framework. Finally, for data collection, these are sent to an API Framework called Measurify. My goal was to address a use case related to a common sporting practice, not necessarily competitive, demonstrating that with low-cost hardware and software components it is possible to obtain useful results for designing a more structured and multi-sensor prototype, capable of qualitatively analyzing individual types of running.

![Summary diagram](images/Summary-diagram.png?raw=true "Summary diagram")

## *Hardware*

The board used is a [Arduino Nano 33 BLE Sense](https://docs.arduino.cc/hardware/nano-33-ble-sense/)

![Arduino Nano 33 BLE Sense](images/Arduino-Nano-33-BLE-Sense.png?raw=true "Arduino Nano 33 BLE Sense")

![Arduino with custom battery](images/Arduino-with-custom-battery.png?raw=true "Arduino with custom battery")

## *Software*

The necessary code is:

1. Edge-meter script on [Arduino IDE](https://www.arduino.cc/en/software)
2. Flutter code of Smart Collector APP on [VSCode](https://code.visualstudio.com/)
3. Machine learning model developed by the laboratory [Elios Lab](https://elios.diten.unige.it/)

## *Quick start*

To setup the embedded system, the following steps need to be followed:

1. Install Arduino IDE and open the edge-meter script (probably you need to install some libraries), then connect the Arduino via cable connection to the computer, selecting from the Arduino IDE menu Serial Port your Arduino and the cable to which it is connected; for the last step click the botton upload to load the script on the board. The Arduino board is able to work without the need for cables thanks of his custom battery implementation but for complete efficiency throughout the day.

2. Install Visual Studio Code and the Flutter plugin; open the quick_blue_example folder from the smart-collector-main folder then connect a mobile device via cable to run the app on it (developer mode must be activated on the device with "Debug USB" enabled). Finally, to load the code, select the device from the banner and the 'Run without debugging' button, the application will be open on the mobile device.

3. Activate the Arduino board, start the scan in the first page of the app and select the "Measurify-Meter" device; in the next page connect the device. 

4. In the Start page you choose the tag to analyze (type of run), identify the measurement with a name, select the IMU function to collect the data relating to the quantities considered and start the data collection through the “Start” button. A counter at the bottom left confirms the arrival of the data. Pressing the “Start” button will display a scrolling diagram that allows you to view the values collected in real time. Pressing the “Stop and Send” button stops the measurement and, if everything went well, the message “Values sent correctly” appears, indicating that the collected data has been sent to the cloud service.


![Start Page](images/Start-Page.png?raw=true "Start Page")

![Start Page during measurement](images/Start-Page-during-measurement.png?raw=true "Start Page during measurement")

5. In the Running Page you can monitor your run in real time, as it shows a percentage of your run quality based on the Arduino’s predictions. If multiple fatigued run classifications are detected, the page will notify the runner to take a break, showing the run quality achieved.

![Running Page during measurement](images/Running-Page-during-measurement.png?raw=true "Running Page during measurement")

![Running Page during the break](images/Running-Page-during-the-break.png?raw=true "Running Page during the break")