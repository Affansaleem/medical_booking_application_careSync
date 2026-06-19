import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_toast.dart';

class ToastEvent {
  final String message;
  final ToastType type;
  final String? title;

  const ToastEvent({required this.message, required this.type, this.title});
}

class ToastServiceNotifier extends StateNotifier<ToastEvent?> {
  ToastServiceNotifier() : super(null);

  void show(String message, {required ToastType type, String? title}) {
    state = ToastEvent(message: message, type: type, title: title);
  }

  void showSuccess(String message, {String? title}) =>
      show(message, type: ToastType.success, title: title);

  void showError(String message, {String? title}) =>
      show(message, type: ToastType.error, title: title);

  void showWarning(String message, {String? title}) =>
      show(message, type: ToastType.warning, title: title);

  void showInfo(String message, {String? title}) =>
      show(message, type: ToastType.info, title: title);

  void consume() => state = null;
}

final toastServiceProvider =
    StateNotifierProvider<ToastServiceNotifier, ToastEvent?>(
      (ref) => ToastServiceNotifier(),
    );
