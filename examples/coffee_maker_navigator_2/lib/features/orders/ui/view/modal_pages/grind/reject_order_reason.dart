import 'package:flutter/material.dart';

enum RejectOrderReason {
  runOutOfCoffee(
    title: 'Run out of coffee',
    subtitle: 'One or more items are out of stock',
    leadingIcon: Icons.search_off,
  ),
  tooBusy(
    title: 'Too busy',
    subtitle: 'There is not enough time to prepare the order',
    leadingIcon: Icons.people,
  ),
  closingSoon(
    title: 'Closing soon',
    subtitle: 'Not enough time to prepare the order before closing',
    leadingIcon: Icons.timelapse,
  );

  const RejectOrderReason({
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
  });

  final IconData leadingIcon;
  final String title;
  final String subtitle;
}
