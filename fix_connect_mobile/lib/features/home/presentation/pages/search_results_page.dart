import 'package:fix_connect_mobile/app/router/route_names.dart';
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/home/data/datasources/home_mock_datasource.dart';
import 'package:fix_connect_mobile/features/home/data/models/artisan_model.dart';
import 'package:fix_connect_mobile/features/home/presentation/widgets/artisan_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _Sort { relevance, ratingDesc, priceAsc }

class SearchResultsPage extends StatefulWidget {
  final String? initialQuery;

  const SearchResultsPage({super.key, this.initialQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController _ctrl;
  String _query = '';
  bool _verifiedOnly = false;
  double _minRating = 0;
  _Sort _sort = _Sort.relevance;

  final List<ArtisanModel> _all = HomeMockDatasource.getTopArtisans();

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _ctrl = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<ArtisanModel> get _results {
    var list = _all.where((a) {
      final q = _query.toLowerCase();
      final matchQ = q.isEmpty ||
          a.name.toLowerCase().contains(q) ||
          a.specialty.toLowerCase().contains(q);
      return matchQ && (!_verifiedOnly || a.isVerified) && a.rating >= _minRating;
    }).toList();

    switch (_sort) {
      case _Sort.relevance:
        break;
      case _Sort.ratingDesc:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case _Sort.priceAsc:
        list.sort((a, b) => a.startingPrice.compareTo(b.startingPrice));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final results = _results;

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
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom8),
            child: Row(children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    size: 20, color: textColor),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    autofocus: widget.initialQuery == null,
                    textInputAction: TextInputAction.search,
                    style: AppTextStyles.bodyMediumRegular(color: textColor),
                    onChanged: (v) => setState(() => _query = v),
                    cursorColor: primary,
                    decoration: InputDecoration(
                      hintText: 'Search artisans or services…',
                      hintStyle: AppTextStyles.bodySmallRegular(
                          color: textColor.withValues(alpha: 0.4)),
                      prefixIcon:
                          Icon(Icons.search, color: primary, size: 20),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close_rounded,
                                  size: 18,
                                  color: textColor.withValues(alpha: 0.5)),
                              onPressed: () => setState(() {
                                _ctrl.clear();
                                _query = '';
                              }),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              AppGaps.w8,
            ]),
          ),
        ),
        body: Column(children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.custom16,
                vertical: AppSpacing.custom8),
            child: Row(children: [
              _Chip(
                label: 'Relevance',
                selected: _sort == _Sort.relevance,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.relevance),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Top Rated',
                selected: _sort == _Sort.ratingDesc,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.ratingDesc),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Price ↑',
                selected: _sort == _Sort.priceAsc,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _sort = _Sort.priceAsc),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Verified',
                icon: Icons.verified_rounded,
                selected: _verifiedOnly,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () => setState(() => _verifiedOnly = !_verifiedOnly),
              ),
              AppGaps.w8,
              _Chip(
                label: 'Rating 4.5+',
                icon: Icons.star_rounded,
                selected: _minRating >= 4.5,
                primary: primary,
                textColor: textColor,
                surfaceColor: surfaceColor,
                onTap: () =>
                    setState(() => _minRating = _minRating >= 4.5 ? 0 : 4.5),
              ),
            ]),
          ),

          // Results count
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
                AppSpacing.custom16, AppSpacing.custom8),
            child: Row(children: [
              Text('${results.length} result${results.length == 1 ? '' : 's'}',
                  style: AppTextStyles.bodyMediumSemibold(color: textColor)),
              if (_query.isNotEmpty) ...[
                Text(' for "',
                    style: AppTextStyles.bodyMediumRegular(
                        color: textColor.withValues(alpha: 0.55))),
                Text(_query,
                    style: AppTextStyles.bodyMediumSemibold(color: primary)),
                Text('"',
                    style: AppTextStyles.bodyMediumRegular(
                        color: textColor.withValues(alpha: 0.55))),
              ],
            ]),
          ),

          // Results list
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.search_off_rounded,
                          size: 56, color: primary.withValues(alpha: 0.3)),
                      AppGaps.h16,
                      Text('No artisans found',
                          style: AppTextStyles.bodyMediumRegular(
                              color: textColor.withValues(alpha: 0.5))),
                      if (_query.isNotEmpty) ...[
                        AppGaps.h4,
                        Text('Try a different search term',
                            style: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.35))),
                      ],
                    ]),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(
                        top: 4,
                        bottom: MediaQuery.of(context).padding.bottom + 72),
                    physics: const BouncingScrollPhysics(),
                    itemCount: results.length,
                    itemBuilder: (_, i) => ArtisanListTile(
                      artisan: results[i],
                      surfaceColor: surfaceColor,
                      textColor: textColor,
                      primary: primary,
                      onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.artisanProfile,
                          arguments: results[i]),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final Color primary, textColor, surfaceColor;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    this.icon,
    required this.selected,
    required this.primary,
    required this.textColor,
    required this.surfaceColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (icon != null
                  ? primary.withValues(alpha: 0.12)
                  : primary)
              : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primary : textColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[
            Icon(icon,
                size: 14,
                color: selected ? primary : textColor.withValues(alpha: 0.5)),
            const SizedBox(width: 5),
          ],
          Text(label,
              style: AppTextStyles.bodySmallSemibold(
                  color: selected
                      ? (icon != null ? primary : Colors.white)
                      : textColor)),
        ]),
      ),
    );
  }
}
