import 'package:fix_connect_mobile/core/di/injection_container.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/category_artisans_cubit.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_book_button.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_description_section.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_featured_artisans.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_hero_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_why_choose_us.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceCategoryModel service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryArtisansCubit>()..load(service.id),
      child: _ServiceDetailView(service: service),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  final ServiceCategoryModel service;

  const _ServiceDetailView({required this.service});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: primary,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: const ServiceBackButton(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: 'service_card_${service.id}',
                    child: ServiceHeroHeader(service: service),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ServiceDescriptionSection(service: service),
              ),
              SliverToBoxAdapter(
                child:
                    BlocBuilder<CategoryArtisansCubit, CategoryArtisansState>(
                      builder: (context, state) {
                        final artisans = state is CategoryArtisansLoaded
                            ? state.artisans
                            : const <ArtisanModel>[];
                        return ServiceFeaturedArtisans(
                          artisans: artisans,
                          serviceLabel: service.name,
                        );
                      },
                    ),
              ),
              const SliverToBoxAdapter(child: ServiceWhyChooseUs()),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 90,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ServiceBookButton(service: service),
          ),
        ],
      ),
    );
  }
}
