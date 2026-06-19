import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/onboarding_state_provider.dart';

class DoctorOnboardingForm extends ConsumerStatefulWidget {
  const DoctorOnboardingForm({super.key});

  @override
  ConsumerState<DoctorOnboardingForm> createState() =>
      _DoctorOnboardingFormState();
}

class _DoctorOnboardingFormState extends ConsumerState<DoctorOnboardingForm> {
  late final TextEditingController _specialtyController;
  late final TextEditingController _qualificationsController;
  late final TextEditingController _experienceController;
  late final TextEditingController _clinicController;
  late final TextEditingController _licenseController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(onboardingFormStateProvider);
    _specialtyController = TextEditingController(text: initial.specialty)
      ..addListener(() {
        ref
            .read(onboardingFormStateProvider.notifier)
            .updateSpecialty(_specialtyController.text);
      });
    _qualificationsController =
        TextEditingController(text: initial.qualifications)..addListener(() {
          ref
              .read(onboardingFormStateProvider.notifier)
              .updateQualifications(_qualificationsController.text);
        });
    _experienceController = TextEditingController(text: initial.experience)
      ..addListener(() {
        ref
            .read(onboardingFormStateProvider.notifier)
            .updateExperience(_experienceController.text);
      });
    _clinicController = TextEditingController(text: initial.clinic)
      ..addListener(() {
        ref
            .read(onboardingFormStateProvider.notifier)
            .updateClinic(_clinicController.text);
      });
    _licenseController = TextEditingController(text: initial.license)
      ..addListener(() {
        ref
            .read(onboardingFormStateProvider.notifier)
            .updateLicense(_licenseController.text);
      });
  }

  @override
  void dispose() {
    _specialtyController.dispose();
    _qualificationsController.dispose();
    _experienceController.dispose();
    _clinicController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _specialtyController,
          labelText: 'Specialty / Field',
          hintText: 'e.g. Cardiologist, Dermatologist',
          prefixIcon: Icons.local_hospital_rounded,
          validator: (value) => null,
        ),
        const Gap(16),
        AppTextField(
          controller: _qualificationsController,
          labelText: 'Qualifications',
          hintText: 'e.g. MD, MBBS, PhD',
          prefixIcon: Icons.school_rounded,
          validator: (value) => null,
        ),
        const Gap(16),
        AppTextField(
          controller: _experienceController,
          labelText: 'Years of Experience',
          hintText: 'e.g. 8',
          prefixIcon: Icons.trending_up_rounded,
          keyboardType: TextInputType.number,
          validator: (value) => null,
        ),
        const Gap(16),
        AppTextField(
          controller: _clinicController,
          labelText: 'Clinic / Hospital Name',
          hintText: 'e.g. CareSync Health Center',
          prefixIcon: Icons.business_rounded,
          validator: (value) => null,
        ),
        const Gap(16),
        AppTextField(
          controller: _licenseController,
          labelText: 'Medical License Number',
          hintText: 'e.g. LIC-12345678',
          prefixIcon: Icons.verified_user_rounded,
          validator: (value) => null,
        ),
      ],
    );
  }
}
