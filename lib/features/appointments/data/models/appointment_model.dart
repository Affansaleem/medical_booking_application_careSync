import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.appointmentDate,
    required super.startTime,
    required super.endTime,
    required super.status,
    required super.appointmentType,
    super.meetingLink,
    super.clinicAddress,
    super.contactNumber,
    super.patientNotes,
    super.doctorNotes,
    required super.createdAt,
    super.patientName,
    super.patientAvatarUrl,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final patientData =
        (json['patient'] ?? json['profiles']) as Map<String, dynamic>?;

    return AppointmentModel(
      id: json['id'] as String? ?? '',
      doctorId: json['doctor_id'] as String? ?? '',
      patientId: json['patient_id'] as String? ?? '',
      appointmentDate: json['appointment_date'] != null
          ? DateTime.tryParse(json['appointment_date'] as String) ??
                DateTime.now()
          : DateTime.now(),
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      appointmentType: json['appointment_type'] as String? ?? 'clinic',
      meetingLink: json['meeting_link'] as String?,
      clinicAddress: json['clinic_address'] as String?,
      contactNumber: json['contact_number'] as String?,
      patientNotes: json['patient_notes'] as String?,
      doctorNotes: json['doctor_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      patientName: patientData?['full_name'] as String?,
      patientAvatarUrl: patientData?['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'appointment_date': appointmentDate.toIso8601String().split('T').first,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'appointment_type': appointmentType,
      'meeting_link': meetingLink,
      'clinic_address': clinicAddress,
      'contact_number': contactNumber,
      'patient_notes': patientNotes,
      'doctor_notes': doctorNotes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
