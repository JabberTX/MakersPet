# Makers Pet Mini BDC-30P Updates

## Changes made
- Changed the lidar posts to fixed, with housing for magnets (6x2mm)
- Changed the lidar skirt to use magnets (6x2mm)
- Changed the PCB posts to fixed, with housing for threaded inserts (m3)
- Remade the enclosure to be a single part, with tabs for magnets (6x2mm)
- Merged the backstop for the battery housing
- Removed all the surplus screw holes
- Updated the firmware to allow multiple wifi access points
- Removed the requirement for a base station IP
- Added functionality for the firmware to search for the base station
- Updated the HTML for the built in wifi access point to allow the multiple AP's and Robot Name

## 3D Printed Parts
- Body.stl
- Enclosure.stl
- Lidar_Skirt.stl
- Mini_BDC-30P.blend (incase you want to dabble with it in Blender)
  
## New hardware needed
- (16) 6mm x 2mm neodymium magnets - https://a.co/d/8Cy52b6
- (4) M3 (M3x4x5mm) threaded inserts - https://a.co/d/8gOsn0B

## Hardware comments
I used a threaded insert kit that fits my Hakko FX-888D (https://a.co/d/5Wtt7Fi), set to the same temp as the filament used to print the 3D parts.  Slow and steady wins here.

# Base Station Software Update
My goal was to install the firmware with the following system requirements
- RPi 4
- No Docker
- Ubuntu 24.04
- ROS2 Kilted Kaiju

## Installation and setup
If there are any issues, please let me know, thanks

On your Ubuntu 24.04 base station

1. `sudo apt update && sudo apt upgrade -y`

2. `mkdir ~/makerspet_ws && cd ~/makerspet_ws`  

Download the three bash files from the github.com/JabberTX/MakersPet/scripts folder

3. `source ./install_kaiaai_kilted.sh`

If there are no errors then continue

4. `source ./install_ros2_kilted_ubuntu_24.sh`

Finally, run `source ./robot_service.sh YOUR_ROBOT_NAME` replacing YOUR_ROBOT_NAME with whatever unique name you choose. We will use this name later.

At this point, everything should be installed and ready to use on your base station.

## Updating the firmware on your MakersPet

This next part updates the firmware on your robot so that you can add multiple WIFI access points and remove the need for including your base stations IP address, instead using the Robot Name from the previous step.

- **It assumes that you have already set up the default MakersPet arduino code and SPIFFS plugin per [Kaiaai Firmware setup](https://github.com/kaiaai/firmware)**

   Download the contents of `github.com/JabberTX/MakersPet/firmware/arduino` to your arduino project folder (Typically on Windows - c:\users\YOURNAME\documents\Arduino, on Ubuntu /home/YOURNAME/Arduino.  This could differ, check your Arduino IDE settings to confirm.)  This should add kaiaai-esp32-updated in your Arduino projects folder.
   
   Follow the original MakersPet instructions for building, uploading, and using the SPIFFS plugin to upload the html and config files to your robot.

### Configuration

   Once this is all good, power on the robot, hold the boot button within a second of powering on.  After several fast blinks it will start the WIFI AP.  Connect to it with your phone etc, as per the original instructions

   On the HTML page in your browser, you should see the "Robot Service Configurator".  Access points are attempted by the robot in order, so enter your primary access point first, etc.

   Click on the "Add Network" to add another network.

   At the end of the list of Networks is "Your Unique Bot Name" which is where you need to put the name you used for the "robot service" from the previous step.  Case sensitive.
   
   Hit Submit and you are done with this part.

## Running it

On your base station, you should be able to navigate to `/makerspet_ws`, run `./install/local_setup.bash` and then run the command `ros2 launch kaiaai_bringup physical.launch.py`

Once this is running, reset/power on your robot.  It will take several seconds to find and connect, you can connect it to your base station / Arduino IDE if you wish to see the Serial Monitor output

### Issues?
  Send me a message!

## Acknowledgements
  [MakersPet](https://github.com/makerspet/makerspet_mini)

  [Kaia.ai](https://github.com/kaiaai)