import 'package:app2/background_wave.dart';
import 'package:flutter/material.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  const SliverSearchAppBar();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
    shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.5;
    double topPadding = MediaQuery.of(context).padding.top + 16;

    return Stack(
      children: [
        const BackgroundWave(
          height: 140,
        ),
      ],
    );
  }

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}
