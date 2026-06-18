import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository repository;

  WatchAuthStateUseCase(this.repository);

  Stream<supabase.AuthState> call() {
    return repository.authStateChanges;
  }
}
