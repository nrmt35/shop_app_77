import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common_header.dart';
import '../../components/loading_indicator.dart';
import '../../components/optimized_image.dart';
import '../../components/page_state_indicator.dart';
import '../../data/responses.dart';
import '../../navigation.dart';
import '../../providers.dart';
import 'products_screen.dart';

final homeProvider = FutureProvider(
  (ref) => ref.watch(apiClientProvider).categories(),
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        right: false,
        left: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ref.watch(homeProvider).when(
                skipLoadingOnRefresh: false,
                data: (categories) => _Body(categories: categories),
                error: (e, trace) => PageStateIndicator(
                  title: 'Что-то пошло не так',
                  onActionTap: () => ref.refresh(homeProvider),
                ),
                loading: () => const LoadingIndicator(),
              ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final List<Category> categories;

  const _Body({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CommonHeader(),
        const SizedBox(height: 6),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                sliver: SliverList.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) => _CategoryWidget(
                    category: categories[index],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryWidget extends StatelessWidget {
  final Category category;

  const _CategoryWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigateToScreen(
        context,
        DishesScreen(
          title: category.name,
        ),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 150,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            OptimizedImage(
              imageUrl: category.imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              placeholderBuilder: (context) =>
                  Platform.isIOS ? const LoadingIndicator() : const SizedBox(),
              errorBuilder: (context, _, __) => const Center(
                child: Text('Что-то пошло не так'),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              right: MediaQuery.of(context).size.width / 2 - 32,
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
