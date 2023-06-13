import 'dart:io';

import 'package:diffutil_sliverlist/diffutil_sliverlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/common_button.dart';
import '../../components/common_header.dart';
import '../../components/loading_indicator.dart';
import '../../components/optimized_image.dart';
import '../../components/page_state_indicator.dart';
import '../../data/responses.dart';
import '../../providers.dart';
import '../../theme.dart';

class BasketScreen extends ConsumerWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        right: false,
        left: false,
        child: basket.basketProducts.isNotEmpty
            ? Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      const CommonHeader(),
                      const SizedBox(height: 6),
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
                              sliver: DiffUtilSliverList<Dish>(
                                items: basket.basketProducts,
                                equalityChecker: (oldItem, newItem) => oldItem.id == newItem.id,
                                builder: (_, item) => _BasketItem(dish: item),
                                insertAnimationBuilder: (_, animation, child) =>
                                    FadeTransition(opacity: animation, child: child),
                                removeAnimationBuilder: (_, animation, child) => SizeTransition(
                                  sizeFactor: animation,
                                  child: FadeTransition(opacity: animation, child: child),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: CommonButton(
                        label: 'Оплатить ${basket.totalCost()} ₽',
                        onPressed: () async {
                          await ref.read(basketProvider.notifier).clearBasket();
                        },
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: PageStateIndicator(
                  title: 'Ваша корзина пуста',
                ),
              ),
      ),
    );
  }
}

class _BasketItem extends ConsumerWidget {
  final Dish dish;

  const _BasketItem({
    Key? key,
    required this.dish,
  }) : super(key: key);

  void showProductDetail(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    final int quantity = basket.getQuantity(dish.id)!;
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.90,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.lightGray2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      children: [
                        OptimizedImage(
                          imageUrl: dish.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) =>
                              Platform.isIOS ? const LoadingIndicator() : const SizedBox(),
                          errorBuilder: (context, _, __) => const Center(
                            child: Text('Что-то пошло не так'),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 10,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: SvgPicture.asset(
                                  'assets/icons/heart.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => Navigator.maybePop(context),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: SvgPicture.asset(
                                    'assets/icons/close.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.name,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: '${dish.price} ₽',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: ' · ${dish.weight}г',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dish.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommonButton(
                    label: 'Добавить в корзину',
                    onPressed: () async {
                      if (quantity < 1) {
                        await ref
                            .read(basketProvider.notifier)
                            .addToBasket(
                              id: dish.id,
                              name: dish.name,
                              price: dish.price,
                              weight: dish.weight,
                              description: dish.description,
                              imageUrl: dish.imageUrl,
                            )
                            .then(
                              (value) => Navigator.maybePop(context),
                            );
                      } else {
                        await ref.read(basketProvider.notifier).updateQuantity(id: dish.id).then(
                              (value) => Navigator.maybePop(context),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    final int quantity = basket.getQuantity(dish.id)!;
    return GestureDetector(
      onTap: () => showProductDetail(context, ref),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGray2,
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 2, 2),
              child: OptimizedImage(
                imageUrl: dish.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                placeholderBuilder: (context) =>
                    Platform.isIOS ? const LoadingIndicator() : const SizedBox(),
                errorBuilder: (context, _, __) => const Center(
                  child: Text('Что-то пошло не так'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      text: '${dish.price} ₽',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: ' · ${dish.weight}г',
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.lightGray,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (quantity == 1) {
                        await ref.read(basketProvider.notifier).removeFromBasket(id: dish.id);
                      } else {
                        await ref
                            .read(basketProvider.notifier)
                            .updateQuantity(id: dish.id, quantity: -1);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(
                        Icons.remove,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      dish.quantity!.toString(),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await ref.read(basketProvider.notifier).updateQuantity(id: dish.id);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(
                        Icons.add,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
