import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class CommonButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final bool inProgress;
  final VoidCallback? onPressed;
  final Color color;

  const CommonButton({
    Key? key,
    required this.label,
    this.icon,
    this.inProgress = false,
    required this.onPressed,
    this.color = AppColors.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 46,
      duration: const Duration(milliseconds: 100),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: color,
        child: InkWell(
          onTap: inProgress //
              ? null
              : onPressed,
          splashColor: Colors.white.withOpacity(0.1),
          child: AnimatedCrossFade(
            crossFadeState: inProgress //
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 100),
            reverseDuration: const Duration(milliseconds: 100),
            firstChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Center(
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: Platform.isIOS
                      ? const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
