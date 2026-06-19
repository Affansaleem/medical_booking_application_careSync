import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';

class AppInitializationService {
  final Ref _ref;

  AppInitializationService(this._ref);

  Future<void> initialize() async {
    await _ref.read(authNotifierProvider.notifier).checkCurrentUser();
  }
}

final appInitializationServiceProvider = Provider<AppInitializationService>((
  ref,
) {
  return AppInitializationService(ref);
});

final appInitializerProvider = FutureProvider<void>((ref) async {
  final initService = ref.watch(appInitializationServiceProvider);
  await Future.delayed(Duration(seconds: 2));
  await initService.initialize();
});
