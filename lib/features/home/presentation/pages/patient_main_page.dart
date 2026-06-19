import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';

class PatientMainPage extends ConsumerStatefulWidget {
  const PatientMainPage({super.key});

  @override
  ConsumerState<PatientMainPage> createState() => _PatientMainPageState();
}

class _PatientMainPageState extends ConsumerState<PatientMainPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _specialties = [
    {
      'icon': Icons.favorite_rounded,
      'name': 'Cardiologist',
      'color': AppColors.accent,
    },
    {
      'icon': Icons.psychology_rounded,
      'name': 'Neurologist',
      'color': AppColors.secondary,
    },
    {
      'icon': Icons.child_care_rounded,
      'name': 'Pediatrician',
      'color': AppColors.success,
    },
    {
      'icon': Icons.vaccines_rounded,
      'name': 'Generalist',
      'color': AppColors.primaryLight,
    },
  ];

  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Robert Chen',
      'specialty': 'Cardiologist',
      'hospital': 'St. Jude Heart Hospital',
      'rating': '4.9',
      'reviews': '124',
      'avatarColor': AppColors.accent,
      'initials': 'RC',
    },
    {
      'name': 'Dr. Sarah Jenkins',
      'specialty': 'Neurologist',
      'hospital': 'Metropolitan Neuro Clinic',
      'rating': '4.8',
      'reviews': '92',
      'avatarColor': AppColors.secondary,
      'initials': 'SJ',
    },
    {
      'name': 'Dr. Alisha Patel',
      'specialty': 'Pediatrician',
      'hospital': 'Children First Care Center',
      'rating': '5.0',
      'reviews': '210',
      'avatarColor': AppColors.success,
      'initials': 'AP',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);

    final user = authState is AuthAuthenticated ? authState.user : null;
    final patientName = user?.fullName ?? 'Patient';
    final avatarUrl = user?.avatarUrl;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isDark
                        ? AppColors.surfaceDark
                        : Colors.white,
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? Icon(
                            Icons.person_rounded,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          )
                        : null,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to CareSync,',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        Text(
                          patientName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    tooltip: 'Log Out',
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    onPressed: () async {
                      final confirmed = await AppConfirmationDialog.show(
                        context,
                        title: 'Log Out',
                        content:
                            'Are you sure you want to log out from CareSync?',
                        confirmText: 'Log Out',
                        isDangerous: true,
                        icon: Icons.logout_rounded,
                      );
                      if (confirmed && context.mounted) {
                        ref.read(authNotifierProvider.notifier).signOut();
                      }
                    },
                  ),
                ],
              ),
              const Gap(24),

              // Welcome banner card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find & Book Doctors\nEasily online',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Search through certified professional profiles near you.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isDark
                      ? AppShadows.cardDark
                      : AppShadows.cardLight,
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search doctors, clinics...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
              const Gap(28),

              // Specialties Section
              Text(
                'Doctor Specialties',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(12),
              SizedBox(
                height: 96,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _specialties.length,
                  itemBuilder: (context, index) {
                    final item = _specialties[index];
                    final Color color = item['color'] as Color;

                    return Container(
                      width: 88,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                        boxShadow: isDark
                            ? AppShadows.cardDark
                            : AppShadows.cardLight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: color,
                              size: 20,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            item['name'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Gap(28),

              // Recommended Doctors Section
              Text(
                'Recommended Doctors',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              const Gap(12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doc = _doctors[index];
                  final Color avatarColor = doc['avatarColor'] as Color;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                      boxShadow: isDark
                          ? AppShadows.cardDark
                          : AppShadows.cardLight,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: avatarColor.withValues(alpha: 0.2),
                          child: Text(
                            doc['initials'] as String,
                            style: TextStyle(
                              color: avatarColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'] as String,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                              ),
                              Text(
                                '${doc['specialty']} • ${doc['hospital']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: AppColors.warning,
                                    size: 14,
                                  ),
                                  const Gap(4),
                                  Text(
                                    '${doc['rating']} (${doc['reviews']} reviews)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                          ),
                          onPressed: () {},
                          color: isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
