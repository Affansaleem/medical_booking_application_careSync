import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_shadows.dart';
import '../../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../../../core/widgets/app_confirmation_dialog.dart';

class DoctorProfileTab extends ConsumerStatefulWidget {
  const DoctorProfileTab({super.key});

  @override
  ConsumerState<DoctorProfileTab> createState() => _DoctorProfileTabState();
}

class _DoctorProfileTabState extends ConsumerState<DoctorProfileTab> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authNotifierProvider);

    final user = authState is AuthAuthenticated ? authState.user : null;
    final doctorName = user?.fullName ?? 'Doctor';
    final specialty = user?.doctorSpecialty ?? 'Medical Specialist';
    final qualifications = user?.doctorQualifications ?? 'MD, MBBS';
    final clinic = user?.doctorClinic ?? 'General Clinic';
    final license = user?.doctorLicenseNumber ?? 'N/A';
    final experience = user?.doctorYearsExperience ?? 5;
    final avatarUrl = user?.avatarUrl;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 24.0,
        bottom: 120.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 3),
                  boxShadow: isDark
                      ? AppShadows.cardDark
                      : AppShadows.cardLight,
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl == null || avatarUrl.isEmpty
                      ? Icon(
                          Icons.person_rounded,
                          size: 56,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _isOnline ? AppColors.success : AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            doctorName.startsWith('Dr.') ? doctorName : 'Dr. $doctorName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const Gap(4),
          Text(
            '$qualifications • $specialty',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            ),
            child: Row(
              children: [
                Icon(
                  _isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  color: _isOnline
                      ? AppColors.success
                      : AppColors.textMutedLight,
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Active Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        _isOnline
                            ? 'Online • Accepting Patients'
                            : 'Offline • Busy',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isOnline,
                  activeThumbColor: AppColors.primaryLight,
                  onChanged: (val) {
                    setState(() {
                      _isOnline = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const Gap(24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Professional Credentials',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            ),
            child: Column(
              children: [
                _buildCredentialRow(
                  context: context,
                  icon: Icons.badge_outlined,
                  label: 'Medical License',
                  value: license,
                ),
                _buildDivider(isDark),
                _buildCredentialRow(
                  context: context,
                  icon: Icons.local_hospital_outlined,
                  label: 'Clinic Affiliation',
                  value: clinic,
                ),
                _buildDivider(isDark),
                _buildCredentialRow(
                  context: context,
                  icon: Icons.timeline_outlined,
                  label: 'Clinical Experience',
                  value: '$experience Years',
                ),
                _buildDivider(isDark),
                _buildCredentialRow(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  label: 'Working Days',
                  value: _getWorkingDaysString(user?.doctorAvailability),
                ),
              ],
            ),
          ),
          const Gap(24),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Preferences & Settings',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const Gap(10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Column(
                children: [
                  _buildSettingsCardItem(
                    context: context,
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile Information',
                    onTap: () {},
                  ),
                  _buildDivider(isDark),
                  _buildSettingsCardItem(
                    context: context,
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Settings',
                    onTap: () {},
                  ),
                  _buildDivider(isDark),
                  _buildSettingsCardItem(
                    context: context,
                    icon: Icons.security_outlined,
                    title: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _buildDivider(isDark),
                  _buildSettingsCardItem(
                    context: context,
                    icon: Icons.logout_rounded,
                    title: 'Sign Out',
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () async {
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
      height: 1,
      indent: 48,
    );
  }

  Widget _buildCredentialRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryLight, size: 20),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ),
                const Gap(2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCardItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    iconColor ??
                    (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              ),
              const Gap(14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        titleColor ??
                        (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isDark
                    ? AppColors.textMutedDark
                    : AppColors.textMutedLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWorkingDaysString(Map<String, dynamic>? availability) {
    if (availability == null || availability.isEmpty) {
      return 'Not set';
    }
    final keys = availability.keys.toList();
    return keys
        .map((day) {
          if (day.length > 3) {
            return day.substring(0, 3).toUpperCase();
          }
          return day.toUpperCase();
        })
        .join(', ');
  }
}
