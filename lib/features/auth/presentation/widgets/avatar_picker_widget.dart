import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/utils/app_toast.dart';
import '../providers/onboarding_state_provider.dart';

class AvatarPickerWidget extends ConsumerWidget {
  const AvatarPickerWidget({super.key});

  void _showSettingsDialog(BuildContext context, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission Required'),
        content: Text(
          'We need access to your $permissionName to set your profile picture. '
          'Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              PermissionService.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    Navigator.of(context).pop();

    bool hasPermission = false;
    if (source == ImageSource.camera) {
      hasPermission = await PermissionService.requestCameraPermission();
      if (!hasPermission) {
        final isPermanent = await PermissionService.isCameraPermanentlyDenied();
        if (isPermanent && context.mounted) {
          _showSettingsDialog(context, 'Camera');
        } else {
          AppToast.showWarning(
            'Camera permission is required to take a photo.',
          );
        }
        return;
      }
    } else {
      hasPermission = await PermissionService.requestPhotosPermission();
      if (!hasPermission) {
        final isPermanent = await PermissionService.isPhotosPermanentlyDenied();
        if (isPermanent && context.mounted) {
          _showSettingsDialog(context, 'Photos');
        } else {
          AppToast.showWarning(
            'Photos permission is required to select an image.',
          );
        }
        return;
      }
    }

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked != null) {
        ref
            .read(onboardingFormStateProvider.notifier)
            .updateAvatar(File(picked.path));
      }
    } catch (_) {
      AppToast.showError('Failed to pick image.');
    }
  }

  void _showSourceSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(20),
                Text(
                  'Upload Photo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const Gap(6),
                Text(
                  'Choose a profile picture',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SourceOption(
                          icon: Icons.camera_alt_rounded,
                          label: 'Camera',
                          isDark: isDark,
                          onTap: () =>
                              _pickImage(context, ref, ImageSource.camera),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _SourceOption(
                          icon: Icons.photo_library_rounded,
                          label: 'Gallery',
                          isDark: isDark,
                          onTap: () =>
                              _pickImage(context, ref, ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarFile = ref.watch(
      onboardingFormStateProvider.select((s) => s.avatarFile),
    );
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showSourceSheet(context, ref),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 2.5,
                  ),
                  image: avatarFile != null
                      ? DecorationImage(
                          image: FileImage(avatarFile),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: avatarFile == null
                    ? Icon(
                        Icons.person_rounded,
                        size: 48,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      )
                    : null,
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(
                    color: isDark
                        ? AppColors.surfaceDark
                        : AppColors.surfaceLight,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        Text(
          avatarFile == null ? 'Add Profile Photo' : 'Change Photo',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: AppColors.primary),
                const Gap(8),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
