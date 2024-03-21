# healthcare_map
Sample app for Healtcare system with allow to search and booking system, 

Feature
- Login
- Register
- Logout

- Nearby clinic searching
- Booking queue
- Annouce incoming booking
- Booking history

- Promotion section
- Loyalty program
================
Third party
- Firebase firestore
https://console.firebase.google.com/u/0/project/healthcare-bf396/overview

- Google map API
================
Prerequest
Flutter installation
Dart SDK >3.2.0

Step
How to prepare for run/install
1. download project to your PC.
2. cd healthcare
3. flutter clean
4. flutter pub run build_runner build -d

To run
1. flutter run

To build and install on real device.
Make sure you already connect your mobile device and 
https://developer.apple.com/documentation/xcode/enabling-developer-mode-on-a-device
https://www.samsung.com/uk/support/mobile-devices/how-do-i-turn-on-the-developer-options-menu-on-my-samsung-galaxy-device/ 
(Other brand than Samsung will neary the same menu location)
then,

1. ios
- flutter build ios
- flutter install

2. android with apk support
- flutter build apk --release
- flutter run

3. android with aab support (Android OS version 10 and above)
- flutter build appbundle --release
- flutter run

===================
