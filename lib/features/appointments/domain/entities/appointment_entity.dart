class AppointmentEntity {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String status;
  final String appointmentType;
  final String? meetingLink;
  final String? clinicAddress;
  final String? contactNumber;
  final String? patientNotes;
  final String? doctorNotes;
  final DateTime createdAt;
  final String? patientName;
  final String? patientAvatarUrl;

  const AppointmentEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.appointmentType,
    this.meetingLink,
    this.clinicAddress,
    this.contactNumber,
    this.patientNotes,
    this.doctorNotes,
    required this.createdAt,
    this.patientName,
    this.patientAvatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          doctorId == other.doctorId &&
          patientId == other.patientId &&
          appointmentDate == other.appointmentDate &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status &&
          appointmentType == other.appointmentType &&
          meetingLink == other.meetingLink &&
          clinicAddress == other.clinicAddress &&
          contactNumber == other.contactNumber &&
          patientNotes == other.patientNotes &&
          doctorNotes == other.doctorNotes &&
          createdAt == other.createdAt &&
          patientName == other.patientName &&
          patientAvatarUrl == other.patientAvatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      doctorId.hashCode ^
      patientId.hashCode ^
      appointmentDate.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      status.hashCode ^
      appointmentType.hashCode ^
      meetingLink.hashCode ^
      clinicAddress.hashCode ^
      contactNumber.hashCode ^
      patientNotes.hashCode ^
      doctorNotes.hashCode ^
      createdAt.hashCode ^
      patientName.hashCode ^
      patientAvatarUrl.hashCode;

  @override
  String toString() {
    return 'AppointmentEntity(id: $id, doctorId: $doctorId, patientId: $patientId, appointmentDate: $appointmentDate, startTime: $startTime, endTime: $endTime, status: $status, appointmentType: $appointmentType, meetingLink: $meetingLink, clinicAddress: $clinicAddress, contactNumber: $contactNumber, patientNotes: $patientNotes, doctorNotes: $doctorNotes, createdAt: $createdAt, patientName: $patientName, patientAvatarUrl: $patientAvatarUrl)';
  }
}
