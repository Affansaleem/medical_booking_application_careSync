import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/doctor_home_tab_config.dart';
import 'doctor_home_controller.dart';

final doctorHomeTabProvider =
    Provider.autoDispose<AsyncValue<DoctorHomeTabData>>((ref) {
      return ref.watch(doctorHomeControllerProvider);
    });
