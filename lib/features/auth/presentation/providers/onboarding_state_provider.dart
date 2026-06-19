import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'onboarding_config.dart';

class OnboardingFormState {
  final DateTime? dob;
  final File? avatarFile;
  final String specialty;
  final String qualifications;
  final String experience;
  final String clinic;
  final String license;
  final Set<String> selectedDays;
  final Map<String, TimeOfDay> startTimes;
  final Map<String, TimeOfDay> endTimes;
  final String activeDay;

  OnboardingFormState({
    this.dob,
    this.avatarFile,
    this.specialty = '',
    this.qualifications = '',
    this.experience = '',
    this.clinic = '',
    this.license = '',
    required this.selectedDays,
    required this.startTimes,
    required this.endTimes,
    required this.activeDay,
  });

  OnboardingFormState copyWith({
    DateTime? dob,
    File? avatarFile,
    bool clearAvatar = false,
    String? specialty,
    String? qualifications,
    String? experience,
    String? clinic,
    String? license,
    Set<String>? selectedDays,
    Map<String, TimeOfDay>? startTimes,
    Map<String, TimeOfDay>? endTimes,
    String? activeDay,
  }) {
    return OnboardingFormState(
      dob: dob ?? this.dob,
      avatarFile: clearAvatar ? null : (avatarFile ?? this.avatarFile),
      specialty: specialty ?? this.specialty,
      qualifications: qualifications ?? this.qualifications,
      experience: experience ?? this.experience,
      clinic: clinic ?? this.clinic,
      license: license ?? this.license,
      selectedDays: selectedDays ?? this.selectedDays,
      startTimes: startTimes ?? this.startTimes,
      endTimes: endTimes ?? this.endTimes,
      activeDay: activeDay ?? this.activeDay,
    );
  }
}

class OnboardingFormNotifier extends StateNotifier<OnboardingFormState> {
  OnboardingFormNotifier()
    : super(
        OnboardingFormState(
          selectedDays: OnboardingConfig.daysOfWeek.take(5).toSet(),
          startTimes: {
            for (final day in OnboardingConfig.daysOfWeek)
              day: const TimeOfDay(
                hour: OnboardingConfig.defaultStartHour,
                minute: OnboardingConfig.defaultStartMinute,
              ),
          },
          endTimes: {
            for (final day in OnboardingConfig.daysOfWeek)
              day: const TimeOfDay(
                hour: OnboardingConfig.defaultEndHour,
                minute: OnboardingConfig.defaultEndMinute,
              ),
          },
          activeDay: OnboardingConfig.daysOfWeek.first,
        ),
      );

  void updateDob(DateTime dob) {
    state = state.copyWith(dob: dob);
  }

  void updateAvatar(File? file) {
    if (file == null) {
      state = state.copyWith(clearAvatar: true);
    } else {
      state = state.copyWith(avatarFile: file);
    }
  }

  void updateSpecialty(String value) {
    state = state.copyWith(specialty: value);
  }

  void updateQualifications(String value) {
    state = state.copyWith(qualifications: value);
  }

  void updateExperience(String value) {
    state = state.copyWith(experience: value);
  }

  void updateClinic(String value) {
    state = state.copyWith(clinic: value);
  }

  void updateLicense(String value) {
    state = state.copyWith(license: value);
  }

  void toggleDay(String day) {
    final updated = Set<String>.from(state.selectedDays);
    if (updated.contains(day)) {
      if (updated.length > 1) {
        updated.remove(day);
        String active = state.activeDay;
        if (active == day) {
          active = updated.first;
        }
        state = state.copyWith(selectedDays: updated, activeDay: active);
      }
    } else {
      updated.add(day);
      state = state.copyWith(selectedDays: updated, activeDay: day);
    }
  }

  void updateActiveDay(String day) {
    state = state.copyWith(activeDay: day);
  }

  void updateTime(String day, bool isStartTime, TimeOfDay time) {
    if (isStartTime) {
      final updated = Map<String, TimeOfDay>.from(state.startTimes);
      updated[day] = time;
      state = state.copyWith(startTimes: updated);
    } else {
      final updated = Map<String, TimeOfDay>.from(state.endTimes);
      updated[day] = time;
      state = state.copyWith(endTimes: updated);
    }
  }

  void applyToAllDays() {
    final activeStart = state.startTimes[state.activeDay]!;
    final activeEnd = state.endTimes[state.activeDay]!;
    final updatedStart = Map<String, TimeOfDay>.from(state.startTimes);
    final updatedEnd = Map<String, TimeOfDay>.from(state.endTimes);
    for (final day in state.selectedDays) {
      updatedStart[day] = activeStart;
      updatedEnd[day] = activeEnd;
    }
    state = state.copyWith(startTimes: updatedStart, endTimes: updatedEnd);
  }
}

final onboardingFormStateProvider =
    StateNotifierProvider.autoDispose<
      OnboardingFormNotifier,
      OnboardingFormState
    >((ref) {
      return OnboardingFormNotifier();
    });
