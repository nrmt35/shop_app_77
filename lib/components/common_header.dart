import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../theme.dart';

class CommonHeader extends StatelessWidget {
  const CommonHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            'assets/icons/location.svg',
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 8),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Санкт-Петербург',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '12 Августа, 2023',
              style: TextStyle(fontSize: 14, color: AppColors.secondary),
            ),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          child: Image.asset(
            'assets/images/profile.jpg',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
