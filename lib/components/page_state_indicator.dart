import 'package:flutter/material.dart';

import '../theme.dart';

class PageStateIndicator extends StatelessWidget {
  final String? title;
  final VoidCallback? onActionTap;

  const PageStateIndicator({
    super.key,
    this.title,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key(title!),
      child: Padding(
        padding: EdgeInsets.fromLTRB(28, 28, 28, 28 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            if (onActionTap != null) const SizedBox(height: 20),
            if (onActionTap != null)
              Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(5),
                color: AppColors.primary,
                child: InkWell(
                  onTap: onActionTap,
                  borderRadius: BorderRadius.circular(5),
                  splashColor: Colors.white.withOpacity(0.1),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      'Повторите попытку',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
