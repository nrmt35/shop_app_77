import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/common_button.dart';
import '../../components/loading_indicator.dart';
import '../../components/optimized_image.dart';
import '../../components/page_state_indicator.dart';
import '../../data/responses.dart';
import '../../providers.dart';
import '../../theme.dart';

final dishesProvider = FutureProvider(
  (ref) => ref.watch(apiClientProvider).dishes(),
);

class DishesScreen extends ConsumerWidget {
  final String title;

  const DishesScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(left: 6),
            child: SvgPicture.asset(
              'assets/icons/arrow_left.svg',
              width: 18,
              height: 18,
            ),
          ),
        ),
        leadingWidth: 40,
        actions: [
          CircleAvatar(
            child: Image.asset(
              'assets/images/profile.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ref.watch(dishesProvider).when(
              skipLoadingOnRefresh: false,
              data: (dishes) => _Body(dishes: dishes),
              error: (e, trace) => PageStateIndicator(
                title: 'Что-то пошло не так',
                onActionTap: () => ref.refresh(dishesProvider),
              ),
              loading: () => const LoadingIndicator(),
            ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final List<Dish> dishes;

  const _Body({
    Key? key,
    required this.dishes,
  }) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<String> tags = [];
  bool _swipeIsInProgress = false;
  bool _tapIsBeingExecuted = false;
  int _selectedIndex = 0;
  int _prevIndex = 0;

  @override
  void initState() {
    widget.dishes.map((d) => tags.addAll(d.tags!)).toList();
    tags = tags.toSet().toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tags.length,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: Builder(
                builder: (context) {
                  final _tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, animated) {
                      _tabController.animation?.addListener(() {
                        if (!_tapIsBeingExecuted &&
                            !_swipeIsInProgress &&
                            (_tabController.offset >= 0.5 || _tabController.offset <= -0.5)) {
                          final int newIndex = _tabController.offset > 0
                              ? _tabController.index + 1
                              : _tabController.index - 1;
                          _swipeIsInProgress = true;
                          _prevIndex = _selectedIndex;
                          setState(() {
                            _selectedIndex = newIndex;
                          });
                        } else {
                          if (!_tapIsBeingExecuted &&
                              _swipeIsInProgress &&
                              ((_tabController.offset < 0.5 && _tabController.offset > 0) ||
                                  (_tabController.offset > -0.5 && _tabController.offset < 0))) {
                            _swipeIsInProgress = false;
                            setState(() {
                              _selectedIndex = _prevIndex;
                            });
                          }
                        }
                      });
                      _tabController.addListener(() {
                        _swipeIsInProgress = false;
                        setState(() {
                          _selectedIndex = _tabController.index;
                        });
                        if (_tapIsBeingExecuted == true) {
                          _tapIsBeingExecuted = false;
                        } else {
                          if (_tabController.indexIsChanging) {
                            _tapIsBeingExecuted = true;
                          }
                        }
                      });
                      return TabBar(
                        isScrollable: true,
                        labelColor: Colors.white,
                        indicatorColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        unselectedLabelColor: Theme.of(context).textTheme.titleMedium!.color,
                        labelStyle: const TextStyle(fontSize: 14),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        tabs: tags
                            .map(
                              (t) => AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: tags.indexOf(t) == _selectedIndex
                                      ? AppColors.primary
                                      : AppColors.lightGray2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Tab(
                                  text: t,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: TabBarView(
              children: tags.map(
                (tag) {
                  final List<Dish> dishes =
                      widget.dishes.where((d) => d.tags!.any((t) => t == tag)).toList();
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    itemCount: dishes.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 4 / 3,
                      mainAxisExtent: 160,
                      maxCrossAxisExtent: 140,
                    ),
                    itemBuilder: (context, index) => _DishWidget(
                      dish: dishes[index],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DishWidget extends ConsumerWidget {
  final Dish dish;

  const _DishWidget({
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
    return GestureDetector(
      onTap: () => showProductDetail(context, ref),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
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
          const SizedBox(height: 5),
          Text(
            dish.name,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
