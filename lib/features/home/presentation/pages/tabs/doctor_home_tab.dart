import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/common/app_friendly_error_card.dart';
import '../../../../../core/widgets/common/app_notice_banner.dart';
import '../../providers/doctor_home_controller.dart';
import '../../widgets/doctor_home_header.dart';
import '../../widgets/doctor_home_metrics_row.dart';
import '../../widgets/doctor_home_schedule_timeline.dart';
import '../../widgets/doctor_home_skeleton.dart';
import '../../widgets/doctor_home_up_next_card.dart';

class DoctorHomeTab extends ConsumerWidget {
  const DoctorHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(doctorHomeControllerProvider);

    return asyncData.when(
      loading: () => const DoctorHomeSkeleton(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: AppFriendlyErrorCard(
            title: 'Unable to load dashboard',
            message:
                'We could not load the doctor overview right now. Please try again.',
            onRetry: () => ref.invalidate(doctorHomeControllerProvider),
          ),
        ),
      ),
      data: (data) {
        final isDark = context.isDark;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: DoctorHomeHeader(
                  doctorName: data.doctorName,
                  specialty: data.specialty,
                  avatarUrl: data.avatarUrl,
                ),
              ),
            ),
            if (data.isPendingVerification)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: AppNoticeBanner(
                    title: 'Verification in progress',
                    message:
                        'Your account is currently under review by our medical board. You will be visible to patients once verified.',
                    icon: Icons.verified_user_outlined,
                    accentColor: AppColors.warning,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: Gap(20)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: DoctorHomeMetricsRow(metrics: data.metrics),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(20)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: DoctorHomeUpNextCard(
                  appointment: data.nextAppointment,
                  isDark: isDark,
                  onViewDetails: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(20)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
              sliver: SliverToBoxAdapter(
                child: DoctorHomeScheduleTimeline(
                  appointments: data.schedule,
                  isDark: isDark,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Gap(20)),
          ],
        );
      },
    );
  }
}
