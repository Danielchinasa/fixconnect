import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WriteReviewPage extends StatefulWidget {
  final BookingModel booking;

  const WriteReviewPage({super.key, required this.booking});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _commentCtrl = TextEditingController();

  static const _labels = ['', 'Terrible', 'Poor', 'Okay', 'Good', 'Excellent!'];

  void _submit() {
    if (_rating == 0) return;
    final primary = context.primary;
    final textColor = context.textColor;
    final bgColor = context.bgColor;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: const Icon(Icons.star_rounded,
                color: Color(0xFFFFB800), size: 32),
          ),
          AppGaps.h16,
          Text('Review Submitted!',
              style: AppTextStyles.header4Bold(color: textColor)),
          AppGaps.h8,
          Text(
            'Thanks for rating ${widget.booking.artisanName.split(' ').first}. '
            'Your feedback helps other customers.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMediumRegular(
                color: textColor.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 28),
          ButtonPrimary(
            text: 'Done',
            bgColor: primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

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
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Write a Review',
              style: AppTextStyles.header4Bold(color: textColor)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.custom24),
          child: Column(children: [
            // Artisan identity card
            Container(
              padding: EdgeInsets.all(AppSpacing.custom16),
              decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      widget.booking.artisanBadgeColor.withValues(alpha: 0.15),
                  child: Text(widget.booking.artisanInitials,
                      style: AppTextStyles.bodyMediumBold(
                          color: widget.booking.artisanBadgeColor)),
                ),
                SizedBox(width: AppSpacing.custom14),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.booking.artisanName,
                            style: AppTextStyles.bodyLargeBold(color: textColor)),
                        Text(widget.booking.service,
                            style: AppTextStyles.bodySmallRegular(
                                color: textColor.withValues(alpha: 0.55))),
                      ]),
                ),
              ]),
            ),
            AppGaps.h32,

            // Star rating
            Text('How would you rate the service?',
                style: AppTextStyles.bodyLargeBold(color: textColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _rating;
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: filled
                          ? const Color(0xFFFFB800)
                          : textColor.withValues(alpha: 0.25),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            AnimatedOpacity(
              opacity: _rating > 0 ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Text(_labels[_rating],
                  style: AppTextStyles.bodyLargeSemibold(
                      color: const Color(0xFFFFB800))),
            ),
            const SizedBox(height: 28),

            // Comment
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Add a comment (optional)',
                  style: AppTextStyles.bodyMediumSemibold(color: textColor)),
            ),
            AppGaps.h10,
            Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _commentCtrl,
                maxLines: 4,
                style: AppTextStyles.bodyMediumRegular(color: textColor),
                cursorColor: primary,
                decoration: InputDecoration(
                  hintText: 'Share your experience with other customers...',
                  hintStyle: AppTextStyles.bodyMediumRegular(
                      color: textColor.withValues(alpha: 0.35)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            AppGaps.h32,

            ButtonPrimary(
              text: 'Submit Review',
              bgColor: primary,
              enabled: _rating > 0,
              onTap: _submit,
            ),
          ]),
        ),
      ),
    );
  }
}
