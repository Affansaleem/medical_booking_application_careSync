import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../config/doctor_home_tab_config.dart';
import '../../../../core/widgets/common/app_metric_card.dart';

class DoctorHomeMetricsRow extends StatelessWidget {
  const DoctorHomeMetricsRow({super.key, required this.metrics});

  final List<DoctorDashboardMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (var index = 0; index < metrics.length; index++) ...[
          Expanded(
            child: AppMetricCard(
              title: metrics[index].title,
              value: metrics[index].value,
              icon: metrics[index].icon,
              color: metrics[index].color,
            ),
          ),
          if (index != metrics.length - 1) const Gap(12),
        ],
      ],
    );
  }
}
