import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final BorderRadius? radius;

  const Skeleton({
    Key? key,
    this.height,
    this.width,
    this.color,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.black,
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color ?? Colors.black.withOpacity(0.07),
          borderRadius: radius ?? BorderRadius.circular(15),
        ),
      ),
    );
  }
}
