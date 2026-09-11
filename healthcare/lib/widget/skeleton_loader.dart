import 'package:flutter/material.dart';
import 'package:healthcare/theme/app_theme.dart';

/// A plain grey placeholder box used to sketch out where content will
/// appear while it's still loading, instead of a bare spinner.
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
    );
  }
}

/// A row of [SkeletonBox]es, for horizontally scrolling loading lists.
class SkeletonRow extends StatelessWidget {
  final int count;
  final double itemWidth;
  final double itemHeight;

  const SkeletonRow({
    super.key,
    this.count = 3,
    this.itemWidth = 140,
    this.itemHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          count,
          (index) => SkeletonBox(width: itemWidth, height: itemHeight),
        ),
      ),
    );
  }
}

/// A column of [SkeletonBox]es, for vertically scrolling loading lists.
class SkeletonColumn extends StatelessWidget {
  final int count;
  final double itemHeight;

  const SkeletonColumn({
    super.key,
    this.count = 3,
    this.itemHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => SkeletonBox(width: double.infinity, height: itemHeight),
      ),
    );
  }
}
