import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/my_artisan_profile_cubit.dart';
import 'package:fix_connect_mobile/features/home/presentation/cubit/services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageArtisanCategoriesSheet extends StatefulWidget {
  final ArtisanModel artisan;

  const ManageArtisanCategoriesSheet({super.key, required this.artisan});

  @override
  State<ManageArtisanCategoriesSheet> createState() =>
      _ManageArtisanCategoriesSheetState();
}

class _ManageArtisanCategoriesSheetState
    extends State<ManageArtisanCategoriesSheet> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    // Pre-select the first existing category if any.
    _selectedId = widget.artisan.categories.isNotEmpty
        ? widget.artisan.categories.first.id
        : null;
  }

  void _select(String id) {
    setState(() => _selectedId = id);
  }

  Future<void> _save() async {
    if (_selectedId == null) return;

    final isDark = context.isDark;
    final textColor = context.textColor;
    final primary = context.primary;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    // Find the selected category name for the confirmation message.
    final servicesState = context.read<ServicesCubit>().state;
    final allCategories = servicesState is ServicesLoaded
        ? servicesState.categories
        : <dynamic>[];
    final selectedName =
        allCategories
                .cast<dynamic>()
                .firstWhere((c) => c.id == _selectedId, orElse: () => null)
                ?.name
            as String? ??
        'this service';

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Confirm Service',
              style: AppTextStyles.header4Bold(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Set "$selectedName" as your service?',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMediumRegular(
                color: textColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.15)
                            : Colors.black.withOpacity(0.12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyMediumSemibold(color: textColor),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: AppTextStyles.bodyMediumSemibold(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      context.read<MyArtisanProfileCubit>().updateCategories([_selectedId!]);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final primary = context.primary;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final surfaceColor = context.surfaceColor;

    return BlocBuilder<ServicesCubit, ServicesCubitState>(
      builder: (context, servicesState) {
        final List<ServiceCategoryModel> allCategories =
            servicesState is ServicesLoaded ? servicesState.categories : [];

        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      // Handle + title
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.grey300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Manage Services',
                                        style: AppTextStyles.header4Bold(
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_selectedId != null ? 1 : 0} selected',
                                        style: AppTextStyles.bodySmallRegular(
                                          color: textColor.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: surfaceColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: textColor.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              height: 1,
                              color: isDark
                                  ? Colors.white.withOpacity(0.07)
                                  : Colors.black.withOpacity(0.06),
                            ),
                          ],
                        ),
                      ),

                      // Category list
                      if (allCategories.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: primary),
                                const SizedBox(height: 12),
                                Text(
                                  'Loading services…',
                                  style: AppTextStyles.bodySmallRegular(
                                    color: textColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SliverList.builder(
                          itemCount: allCategories.length,
                          itemBuilder: (context, i) {
                            final cat = allCategories[i];
                            final isSelected = _selectedId == cat.id;
                            return InkWell(
                              onTap: () => _select(cat.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    // Category icon bg
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primary.withOpacity(0.12)
                                            : surfaceColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? primary.withOpacity(0.4)
                                              : isDark
                                              ? Colors.white.withOpacity(0.07)
                                              : Colors.black.withOpacity(0.06),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.build_circle_outlined,
                                        size: 18,
                                        color: isSelected
                                            ? primary
                                            : textColor.withOpacity(0.4),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.name,
                                            style:
                                                AppTextStyles.bodyMediumSemibold(
                                                  color: textColor,
                                                ),
                                          ),
                                          if (cat.description != null &&
                                              cat.description!.isNotEmpty)
                                            Text(
                                              cat.description!,
                                              style:
                                                  AppTextStyles.bodySmallRegular(
                                                    color: textColor
                                                        .withOpacity(0.5),
                                                  ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primary
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? primary
                                              : textColor.withOpacity(0.25),
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                // ── Floating save button ──────────────────────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _selectedId == null ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        disabledBackgroundColor: primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _selectedId != null
                            ? 'Save Service'
                            : 'Select a Service',
                        style: AppTextStyles.bodyLargeBold(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
