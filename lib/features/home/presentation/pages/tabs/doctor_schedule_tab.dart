import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/app_calendar_picker.dart';
import '../../providers/doctor_schedule_provider.dart';
import '../../widgets/schedule/schedule_header.dart';
import '../../widgets/schedule/calendar_strip.dart';
import '../../widgets/schedule/schedule_filter_sheet.dart';
import '../../widgets/schedule/schedule_appointment_list.dart';

class DoctorScheduleTab extends ConsumerWidget {
  const DoctorScheduleTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final scheduleState = ref.watch(doctorScheduleControllerProvider);
    final controller = ref.read(doctorScheduleControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScheduleHeader(
              selectedDate: scheduleState.selectedDate,
              onTodayPressed: () {
                controller.selectDate(DateTime.now());
              },
              onCalendarPressed: () async {
                final pickedDate = await AppCalendarPicker.show(
                  context,
                  initialDate: scheduleState.selectedDate,
                );
                if (pickedDate != null) {
                  controller.selectDate(pickedDate);
                }
              },
              onFilterPressed: () => ScheduleFilterSheet.show(context),
            ),
            const Gap(10),
            CalendarStrip(
              weekDays: scheduleState.weekDays,
              selectedDate: scheduleState.selectedDate,
              onDateSelected: (date) {
                controller.selectDate(date);
              },
            ),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                height: 1,
              ),
            ),
            const Gap(16),
            const Expanded(child: ScheduleAppointmentList()),
          ],
        ),
      ),
    );
  }
}
