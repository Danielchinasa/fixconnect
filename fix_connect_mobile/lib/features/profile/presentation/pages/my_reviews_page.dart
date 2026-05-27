import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/empty_state.dart';
import 'package:fix_connect_mobile/features/profile/data/models/my_review.dart';
import 'package:fix_connect_mobile/features/profile/presentation/cubit/reviews_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({super.key});

  @override
  State<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = context.bgColor;
    final textColor = context.textColor;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: textColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'My Reviews',
            style: AppTextStyles.header4Bold(color: textColor),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ReviewsCubit, ReviewsState>(
          builder: (context, state) {
            final reviews = switch (state) {
              ReviewsLoaded(:final reviews) => reviews,
              ReviewsError(:final reviews) => reviews,
              _ => const <MyReview>[],
            };

            if (state is ReviewsLoading || state is ReviewsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (reviews.isEmpty) {
              return const EmptyState(
                icon: Icons.rate_review_outlined,
                title: 'No Reviews Yet',
                subtitle:
                    'Reviews between customers and artisans will appear here.',
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(AppSpacing.custom16),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ReviewCard(review: reviews[i]),
            );
          },
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final MyReview review;

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('dd MMM yyyy').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.primary;
    final surface = context.surfaceColor;
    final textColor = context.textColor;
    final subTextColor = context.subTextColor;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(Icons.star_rounded, color: primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.counterpartyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMediumBold(color: textColor),
                    ),
                    if ((review.serviceName ?? '').isNotEmpty)
                      Text(
                        review.serviceName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmallRegular(
                          color: subTextColor,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.amber.withValues(alpha: 0.15)
                      : Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  review.rating.toStringAsFixed(1),
                  style: AppTextStyles.bodySmallMedium(
                    color: Colors.amber[800]!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment.isEmpty ? 'No comment provided.' : review.comment,
            style: AppTextStyles.bodyMediumRegular(color: textColor),
          ),
          const SizedBox(height: 10),
          Text(
            _fmtDate(review.createdAt),
            style: AppTextStyles.bodySmallRegular(color: subTextColor),
          ),
        ],
      ),
    );
  }
}
