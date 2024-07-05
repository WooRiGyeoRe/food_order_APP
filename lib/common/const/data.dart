import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

// isIOS라면 simulatorIp를 반환하고
// 아닐 경우에는 emulatorIp를 반환
final ip = Platform.isIOS ? simulatorIp : emulatorIp;

const storage = FlutterSecureStorage();
