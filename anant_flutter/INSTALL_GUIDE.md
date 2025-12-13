# 📱 How to Run the App on Mobile

## 1. Prerequisites
- Ensure your mobile device is connected via USB.
- Enable **USB Debugging** on your Android device (Settings > Developer Options).
- Ensure your computer and mobile are on the same Wi-Fi network (if testing locally without USB, but USB is recommended).

## 2. Verify Device Connection
Run the following command in your terminal to see connected devices:
```bash
flutter devices
```
You should see your mobile device listed.

## 3. Run the App
Navigate to the Flutter project directory:
```bash
cd anant_flutter
```

Run the app on your device:
```bash
flutter run
```
If you have multiple devices, specify the device ID:
```bash
flutter run -d <device_id>
```

## 4. Login with Dummy Data
Use the following credentials to log in:

| Role | Anant ID | Password |
|---|---|---|
| **Student** | `25A003.student@AnantSchool.anant` | `password123` |
| **Teacher** | `25Staff003.teacher@AnantSchool.anant` | `password123` |

> **Note:** The Anant ID is **case-insensitive**. You can enter it in lowercase (e.g., `25a003.student@anantschool.anant`) and it will still work.

## 5. Troubleshooting
- **Connection Refused**: If the app cannot connect to the server, ensure your server is running and your mobile device can reach your computer's IP address.
  - You might need to update `client.dart` or `config` to use your computer's local IP (e.g., `192.168.1.x`) instead of `localhost`.
  - Serverpod usually binds to `0.0.0.0` or `localhost`. If using an emulator, `10.0.2.2` works. If using a real device, use your PC's IP.

### Updating Server URL for Real Device
If you are using a real physical device, `localhost` will not work.
1. Find your PC's IP address (`ipconfig` on Windows).
2. Update the client initialization in `lib/main.dart` (or wherever `client` is created) to use `http://<YOUR_PC_IP>:8080/`.
