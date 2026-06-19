import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_state_provider.dart';
import '../providers/onboarding_state_provider.dart';
import '../widgets/patient_onboarding_form.dart';
import '../widgets/doctor_onboarding_form.dart';
import '../widgets/availability_scheduler.dart';
import '../widgets/avatar_picker_widget.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late UserEntity _user;

  @override
  void initState() {
    super.initState();
    _user = (ref.read(authNotifierProvider) as AuthAuthenticated).user;
  }

  void _submit(BuildContext context) {
    final state = ref.read(onboardingFormStateProvider);
    final onboardingData = <String, dynamic>{};

    if (state.avatarFile != null) {
      onboardingData['_avatarFilePath'] = state.avatarFile!.path;
    }

    if (_user.role == UserRole.patient) {
      if (state.dob == null) {
        AppToast.showError('Please select your Date of Birth');
        return;
      }
      onboardingData['date_of_birth'] = AppFormatters.formatDate(state.dob!);
    } else {
      if (state.specialty.trim().isEmpty) {
        AppToast.showError('Please enter your specialty');
        return;
      }
      if (state.qualifications.trim().isEmpty) {
        AppToast.showError('Please enter your qualifications');
        return;
      }
      if (state.experience.trim().isEmpty) {
        AppToast.showError('Please enter your years of experience');
        return;
      }
      final experience = int.tryParse(state.experience.trim());
      if (experience == null || experience < 0) {
        AppToast.showError('Please enter a valid experience number');
        return;
      }
      if (state.clinic.trim().isEmpty) {
        AppToast.showError('Please enter your clinic name');
        return;
      }
      if (state.license.trim().isEmpty) {
        AppToast.showError('Please enter your license number');
        return;
      }
      if (state.selectedDays.isEmpty) {
        AppToast.showError('Select at least 1 working day');
        return;
      }

      final availabilityJson = <String, dynamic>{};
      for (final day in state.selectedDays) {
        availabilityJson[day] = {
          'start': AppFormatters.formatTimeOfDay(state.startTimes[day]!),
          'end': AppFormatters.formatTimeOfDay(state.endTimes[day]!),
        };
      }

      onboardingData.addAll({
        'doctor_specialty': state.specialty.trim(),
        'doctor_qualifications': state.qualifications.trim(),
        'doctor_years_experience': experience,
        'doctor_clinic': state.clinic.trim(),
        'doctor_license_number': state.license.trim(),
        'doctor_availability': availabilityJson,
        'doctor_is_pending_verification': false,
      });
    }

    ref.read(authNotifierProvider.notifier).completeOnboarding(onboardingData);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isPatient = _user.role == UserRole.patient;

    final backgroundColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final textPrimary = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogo(),
                const Gap(16),
                Text(
                  'Complete Your Profile',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  isPatient
                      ? 'Help us personalize your patient journey and appointments.'
                      : 'Set up your professional clinical profile for patients.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                const AvatarPickerWidget(),
                const Gap(24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor.withValues(alpha: isDark ? 0.85 : 0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: borderColor.withValues(alpha: isDark ? 0.8 : 1.0),
                    ),
                    boxShadow: isDark
                        ? AppShadows.dialogDark
                        : AppShadows.dialogLight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isPatient)
                        const PatientOnboardingForm()
                      else ...[
                        const DoctorOnboardingForm(),
                        const Gap(24),
                        Divider(color: borderColor, thickness: 1),
                        const Gap(16),
                        const AvailabilityScheduler(),
                      ],
                      const Gap(32),
                      AppButton.primary(
                        onPressed: () => _submit(context),
                        text: 'Submit & Complete',
                        isLoading: authState is AuthLoading,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
