import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/error/exceptions.dart';
import '../models/appointment_model.dart';

abstract class AppointmentsRemoteDataSource {
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    String? date,
  });
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  final supabase.SupabaseClient _supabaseClient;

  AppointmentsRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    String? date,
  }) async {
    try {
      var query = _supabaseClient
          .schema('caresync')
          .from('appointments')
          .select('*, patient:profiles!patient_id(full_name, avatar_url)')
          .eq('doctor_id', doctorId);

      if (date != null) {
        query = query.eq('appointment_date', date);
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
}
