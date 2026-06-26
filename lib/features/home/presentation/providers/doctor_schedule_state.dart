import '../config/doctor_home_tab_config.dart';

class DoctorScheduleState {
  final DateTime selectedDate;
  final List<DateTime> weekDays;
  final String statusFilter;
  final String methodFilter;
  final List<DoctorAppointmentItem> appointments;
  final bool isLoading;
  final String? errorMessage;

  const DoctorScheduleState({
    required this.selectedDate,
    required this.weekDays,
    required this.statusFilter,
    required this.methodFilter,
    required this.appointments,
    this.isLoading = false,
    this.errorMessage,
  });

  DoctorScheduleState copyWith({
    DateTime? selectedDate,
    List<DateTime>? weekDays,
    String? statusFilter,
    String? methodFilter,
    List<DoctorAppointmentItem>? appointments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DoctorScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      weekDays: weekDays ?? this.weekDays,
      statusFilter: statusFilter ?? this.statusFilter,
      methodFilter: methodFilter ?? this.methodFilter,
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          errorMessage, // We pass explicitly to allow clearing error message
    );
  }
}
