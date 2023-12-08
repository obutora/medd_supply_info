import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.chipColor,
    required this.child,
    required this.onTap,
    this.isBorderEnable = false,
  });

  final Color chipColor;
  final Widget child;
  final bool isBorderEnable;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(8),
          border: isBorderEnable
              ? Border.all(
                  color: Colors.black12,
                  width: 1,
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }
}
