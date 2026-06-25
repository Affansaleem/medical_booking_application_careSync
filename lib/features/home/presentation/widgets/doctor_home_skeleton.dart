import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';

class DoctorHomeSkeleton extends StatelessWidget {
  const DoctorHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      enableSwitchAnimation: true,
      containersColor: AppColors.surfaceLight,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(child: _HeaderSkeleton()),
          ),
          const SliverToBoxAdapter(child: Gap(20)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _BannerSkeleton()),
          ),
          const SliverToBoxAdapter(child: Gap(20)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _MetricsSkeleton()),
          ),
          const SliverToBoxAdapter(child: Gap(20)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _UpNextSkeleton()),
          ),
          const SliverToBoxAdapter(child: Gap(20)),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 140),
            sliver: SliverToBoxAdapter(child: _ScheduleSkeleton()),
          ),
          const SliverToBoxAdapter(child: Gap(20)),
        ],
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Bone.circle(size: 56),
        Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(width: 120),
              Gap(10),
              Bone.text(width: 180),
              Gap(10),
              Bone.button(width: 110, height: 24, borderRadius: BorderRadius.all(Radius.circular(999))),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(width: 150),
          Gap(10),
          Bone.multiText(lines: 2),
        ],
      ),
    );
  }
}

class _MetricsSkeleton extends StatelessWidget {
  const _MetricsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _MetricCardSkeleton()),
        Gap(12),
        Expanded(child: _MetricCardSkeleton()),
        Gap(12),
        Expanded(child: _MetricCardSkeleton()),
      ],
    );
  }
}

class _MetricCardSkeleton extends StatelessWidget {
  const _MetricCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppShadows.cardLight,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Bone.circle(size: 40),
          Gap(16),
          Bone.text(width: 42),
          Gap(4),
          Bone.text(width: 78),
        ],
      ),
    );
  }
}

class _UpNextSkeleton extends StatelessWidget {
  const _UpNextSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppShadows.cardLight,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(width: 90),
          Gap(14),
          Row(
            children: [
              Bone.circle(size: 52),
              Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(width: 140),
                    Gap(8),
                    Bone.text(width: 110),
                  ],
                ),
              ),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Bone.button(width: 94, height: 30, borderRadius: BorderRadius.all(Radius.circular(999))),
              Spacer(),
              Bone.button(width: 136, height: 42, borderRadius: BorderRadius.all(Radius.circular(14))),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleSkeleton extends StatelessWidget {
  const _ScheduleSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppShadows.cardLight,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(width: 140),
          Gap(16),
          _TimelineItemSkeleton(),
          Gap(14),
          _TimelineItemSkeleton(),
          Gap(14),
          _TimelineItemSkeleton(),
        ],
      ),
    );
  }
}

class _TimelineItemSkeleton extends StatelessWidget {
  const _TimelineItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          width: 96,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.text(width: 62),
              Gap(4),
              Bone.text(width: 52),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(height: 76, child: VerticalDivider(width: 1)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.circle(size: 40),
                  Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Bone.text(width: 120),
                        Gap(6),
                        Bone.multiText(lines: 2),
                      ],
                    ),
                  ),
                  Gap(8),
                  Bone.button(width: 86, height: 28, borderRadius: BorderRadius.all(Radius.circular(999))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
