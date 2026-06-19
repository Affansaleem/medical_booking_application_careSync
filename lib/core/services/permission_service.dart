import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    final result = await Permission.camera.request();
    return result.isGranted || result.isLimited;
  }

  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    final result = await Permission.photos.request();
    return result.isGranted || result.isLimited;
  }

  static Future<bool> isCameraPermanentlyDenied() async {
    return await Permission.camera.isPermanentlyDenied;
  }

  static Future<bool> isPhotosPermanentlyDenied() async {
    return await Permission.photos.isPermanentlyDenied;
  }

  static Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
