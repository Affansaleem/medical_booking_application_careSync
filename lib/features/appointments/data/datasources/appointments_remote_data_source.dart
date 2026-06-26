import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/exceptions.dart';
import '../models/appointment_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    String? date,
    String? status,
    String? appointmentType,
  });

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  });
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  AppointmentsRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    String? date,
    String? status,
    String? appointmentType,
  }) async {
    try {
      var query = _supabaseClient
          .schema('caresync')
          .from('appointments')
          .select('*, patient:profiles!patient_id(full_name, avatar_url)')
          .eq('doctor_id', doctorId);

      if (date != null && date.isNotEmpty) {
        query = query.eq('appointment_date', date);
      }

      if (status != null && status != 'all') {
        query = query.eq('status', status.toLowerCase());
      }

      if (appointmentType != null && appointmentType != 'all') {
        if (appointmentType == 'online') {
          query = query.inFilter('appointment_type', ['video', 'telehealth']);
        } else if (appointmentType == 'in-person') {
          query = query.eq('appointment_type', 'clinic');
        }
      }

      final response = await query.order('start_time', ascending: true);

      final list = response as List<dynamic>;
      return list
          .map(
            (json) => AppointmentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on supabase.PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    try {
      await _supabaseClient
          .schema('caresync')
          .from('appointments')
          .update({'status': status})
          .eq('id', appointmentId);
    } on supabase.PostgrestException catch (e) {
      throw ServerException(
        message: e.message,
        statusCode: int.tryParse(e.code ?? ''),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
