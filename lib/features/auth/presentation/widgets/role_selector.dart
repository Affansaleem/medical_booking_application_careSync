import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/auth_state_provider.dart';

class RoleSelector extends ConsumerWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRole = ref.watch(authRoleProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Sliding background indicator
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: selectedRole == UserRole.patient
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              // Toggle items
              Row(
                children: UserRole.values.map((role) {
                  final isSelected = selectedRole == role;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref.read(authRoleProvider.notifier).state = role;
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              role == UserRole.patient
                                  ? Icons.person_outline_rounded
                                  : Icons.medical_services_outlined,
                              size: 18,
                              color: isSelected ? Colors.white : textSecondary,
                            ),
                            const Gap(6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              child: Text(
                                role == UserRole.patient ? 'Patient' : 'Doctor',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const Gap(10),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              selectedRole == UserRole.patient
                  ? 'Access medical booking, consult doctors, and track your care.'
                  : 'Manage your schedule, consultation files, and patient requests.',
              style: context.textTheme.bodySmall?.copyWith(
                color: textSecondary.withValues(alpha: 0.8),
                height: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
