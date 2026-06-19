import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/toast_service.dart';
import '../utils/app_toast.dart';

class AppToastListener extends ConsumerWidget {
  final Widget child;

  const AppToastListener({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ToastEvent?>(toastServiceProvider, (previous, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppToast.show(
          message: next.message,
          type: next.type,
          title: next.title,
        );
        ref.read(toastServiceProvider.notifier).consume();
      });
    });

    return child;
  }
}
