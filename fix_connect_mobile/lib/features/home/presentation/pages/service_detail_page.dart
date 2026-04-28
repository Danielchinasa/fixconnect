import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_book_button.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_description_section.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_featured_artisans.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_hero_header.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_popular_services.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_stats_strip.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/service_detail/service_why_choose_us.dart';
import 'package:flutter/material.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceCategoryModel service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final featured = HomeMockDatasource.getTopArtisans().take(3).toList();

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
                backgroundColor: service.gradientColors.last,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                leading: const ServiceBackButton(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Hero(
                    tag: 'service_card_\${service.id}',
                    child: ServiceHeroHeader(service: service),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: ServiceStatsStrip(service: service)),
              SliverToBoxAdapter(
                child: ServiceDescriptionSection(service: service),
              ),
              SliverToBoxAdapter(
                child: ServicePopularServices(service: service),
              ),
              SliverToBoxAdapter(
                child: ServiceFeaturedArtisans(
                  artisans: featured,
                  serviceLabel: service.label,
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
