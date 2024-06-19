# ChoreShare
Living with roommates or sharing an apartment while studying abroad can be challenging. One of our main problems when moving to Poland and sharing an apartment with strangers is to evenly divide the house chores and not have to remind them ourselves. This way it ensures everyone contributes the same. ChoreShare is a mobile app to simplify household chore management, helping roommates maintain a good living environment without disagreements or conflicts.In this app you can put all the tasks/chores that need to get done throughout the week. You can also add different participants that will contribute (flat mates). The app will provide an evenly divided schedule. 

ChoreShare is a Flutter application designed by us Noelia Sierra Sanchez and Yael Martin Benzaquen. It is our first project in Flutter using Dart and so it is not fully developed.

## Project Structure

Although we are only using Android, when we created the project Flutter structured created as follow:

- `android`: Platform-specific code for Android.
- `ios`: Platform-specific code for iOS.
- `lib`: Contains the main source code of the application.
- `test`: Contains unit tests and widget tests for the application.
- `web`: Platform-specific code for web.
- `linux`: Platform-specific code for Linux.
- `macos`: Platform-specific code for macOS.
- `windows`: Platform-specific code for Windows.
- `assets`: Contains static resources like images, fonts, etc.
- `pubspec.yaml`: Dart and Flutter configuration file.

## Installation

To install and run this application locally, follow these steps:

1. Clone this repository:
    ```bash
    git clone https://github.com/yaelitamb/ChoreShare
    ```
2. Navigate to the project directory:
    ```bash
    cd ChoreShare/choreshare
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Run the application:
    ```bash
    flutter run
    ```

## Running the Application on an Emulator

We use the Android Studio emulator to test the application and see the result. Here’s how you can set it up:

1. **Install Android Studio:**
   - Download and install Android Studio from the official website: [Android Studio](https://developer.android.com/studio).

2. **Set up the Emulator:**
   - Open Android Studio.
   - Go to `AVD Manager` (Android Virtual Device Manager) from the toolbar or navigate through `Tools > AVD Manager`.
   - Create a new virtual device by clicking on `Create Virtual Device`.
   - Select a device model (e.g., Pixel 3) and click `Next`.
   - Choose a system image (e.g., Android 11.0) and click `Next`.
   - Configure the AVD (you can leave the default settings) and click `Finish`.

3. **Run the Emulator:**
   - In the `AVD Manager`, click the `Play` button next to the device you just created to start the emulator.

4. **Connect the Emulator with the App:**
   - Ensure the emulator is running.
   - In the terminal, navigate to the project directory and run the application:
     ```bash
     flutter run
     ```
   - Select the running emulator as the target device.

## Running Tests

To run the tests for this project, use the following command:

```bash
flutter test

