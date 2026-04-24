import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  String _searchQuery = '';
  int? _expandedIndex;

  static const _faqs = <_Faq>[
    // Getting Started
    _Faq(
      'Getting Started',
      'How do I find an artisan?',
      'Use the search bar on the home screen or browse service categories. You can filter by rating, specialty, and verified status to find the right match.',
    ),
    _Faq(
      'Getting Started',
      'Are artisans on FixConnect verified?',
      'Yes. Every artisan goes through identity verification, document checks, and a background review before being listed on the platform.',
    ),
    _Faq(
      'Getting Started',
      'How do I know if an artisan is available?',
      "Each artisan profile shows their weekly availability schedule and today's open hours. You can also see if they're currently online.",
    ),
    // Bookings
    _Faq(
      'Bookings',
      'How do I book an artisan?',
      "Open any artisan profile and tap 'Book Now'. Select your preferred date, time, address, and any notes about the job, then confirm.",
    ),
    _Faq(
      'Bookings',
      'Can I reschedule a booking?',
      'Yes. Open the booking from the My Bookings tab and tap Reschedule. Changes must be made at least 24 hours before the scheduled time.',
    ),
    _Faq(
      'Bookings',
      'How do I cancel a booking?',
      "Open the booking detail and tap 'Cancel Booking'. Cancellations made less than 2 hours before the scheduled time may incur a small fee.",
    ),
    _Faq(
      'Bookings',
      "What if the artisan doesn't show up?",
      "Contact our support team immediately. We will help you reschedule at no extra cost or issue a full refund if the artisan fails to show.",
    ),
    // Payments
    _Faq(
      'Payments',
      'What payment methods are accepted?',
      'We accept Visa, Mastercard, Verve, and bank transfers. You can save multiple payment methods under Profile → Payment Methods.',
    ),
    _Faq(
      'Payments',
      'When am I charged?',
      'Payment is only processed after the job is marked complete. Your card is held on file but not charged until you confirm the work is done.',
    ),
    _Faq(
      'Payments',
      'How do I request a refund?',
      'Refund requests must be submitted within 48 hours of job completion. Open the booking detail and tap Contact Support to start the process.',
    ),
    // Account
    _Faq(
      'Account',
      'How do I update my profile?',
      'Go to Profile → Edit Profile to update your name, phone number, profile photo, and other personal details.',
    ),
    _Faq(
      'Account',
      'Can I use FixConnect on multiple devices?',
      'Yes. Your account syncs across all devices. Simply log in with your email and password on any device.',
    ),
    _Faq(
      'Account',
      'How do I delete my account?',
      'To delete your account, contact us at support@fixconnect.ng. Note that deletion is permanent and cannot be undone.',
    ),
  ];

  List<_Faq> get _filtered {
    if (_searchQuery.isEmpty) return _faqs;
    final q = _searchQuery.toLowerCase();
    return _faqs
        .where(
          (f) =>
              f.question.toLowerCase().contains(q) ||
              f.answer.toLowerCase().contains(q) ||
              f.category.toLowerCase().contains(q),
        )
        .toList();
  }

  List<String> get _categories =>
      _filtered.map((f) => f.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final filtered = _filtered;
    final categories = _categories;

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
            'Help & Support',
            style: AppTextStyles.header4Bold(color: textColor),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.custom16,
                AppSpacing.custom8,
                AppSpacing.custom16,
                AppSpacing.custom16,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  onChanged: (v) => setState(() {
                    _searchQuery = v;
                    _expandedIndex = null;
                  }),
                  style: AppTextStyles.bodyMediumRegular(color: textColor),
                  cursorColor: primary,
                  decoration: InputDecoration(
                    hintText: 'Search help articles…',
                    hintStyle: AppTextStyles.bodyMediumRegular(
                      color: textColor.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(Icons.search, color: primary, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Empty state ──────────────────────────────────────────────
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: primary.withValues(alpha: 0.3),
                    ),
                    AppGaps.h10,
                    Text(
                      'No results for "$_searchQuery"',
                      style: AppTextStyles.bodyMediumRegular(
                        color: textColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              )
            else
              // ── FAQ sections ──────────────────────────────────────────
              ...categories.map((cat) {
                final items = filtered.where((f) => f.category == cat).toList();
                final startIdx = filtered.indexOf(items.first);
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.custom16,
                    0,
                    AppSpacing.custom16,
                    AppSpacing.custom16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.custom8),
                        child: Text(
                          cat,
                          style: AppTextStyles.bodySmallSemibold(
                            color: textColor.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: List.generate(items.length, (i) {
                            final globalIdx = startIdx + i;
                            final isExpanded = _expandedIndex == globalIdx;
                            final isLast = i == items.length - 1;
                            return _FaqTile(
                              faq: items[i],
                              isExpanded: isExpanded,
                              isLast: isLast,
                              textColor: textColor,
                              primary: primary,
                              onTap: () => setState(
                                () => _expandedIndex = isExpanded
                                    ? null
                                    : globalIdx,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }),

            // ── Contact card ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.custom16),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.custom20),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primary.withValues(alpha: 0.15)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.support_agent_rounded, color: primary, size: 32),
                    AppGaps.h10,
                    Text(
                      'Still need help?',
                      style: AppTextStyles.bodyLargeBold(color: textColor),
                    ),
                    AppGaps.h4,
                    Text(
                      'Our team is available Mon–Sat, 8 AM–8 PM.',
                      style: AppTextStyles.bodySmallRegular(
                        color: textColor.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _ContactBtn(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'Chat with Us',
                      primary: primary,
                      filled: true,
                      onTap: () {},
                    ),
                    AppGaps.h8,
                    _ContactBtn(
                      icon: Icons.mail_outline_rounded,
                      label: 'support@fixconnect.ng',
                      primary: primary,
                      filled: false,
                      onTap: () {},
                    ),
                    AppGaps.h8,
                    _ContactBtn(
                      icon: Icons.call_outlined,
                      label: '+234 800 349 266 83',
                      primary: primary,
                      filled: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────
class _Faq {
  final String category;
  final String question;
  final String answer;

  const _Faq(this.category, this.question, this.answer);
}

// ── FAQ tile with expand/collapse ─────────────────────────────────────────────
class _FaqTile extends StatelessWidget {
  final _Faq faq;
  final bool isExpanded;
  final bool isLast;
  final Color textColor, primary;
  final VoidCallback onTap;

  const _FaqTile({
    required this.faq,
    required this.isExpanded,
    required this.isLast,
    required this.textColor,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : BorderRadius.zero,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.custom16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: isExpanded
                        ? AppTextStyles.bodyMediumBold(color: primary)
                        : AppTextStyles.bodyMediumMedium(color: textColor),
                  ),
                ),
                SizedBox(width: AppSpacing.custom8),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isExpanded
                        ? primary
                        : textColor.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.custom16,
              0,
              AppSpacing.custom16,
              AppSpacing.custom16,
            ),
            child: Text(
              faq.answer,
              style: AppTextStyles.bodySmallRegular(
                color: textColor.withValues(alpha: 0.7),
              ).copyWith(height: 1.6),
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.only(left: AppSpacing.custom16),
            child: Divider(height: 1, color: textColor.withValues(alpha: 0.08)),
          ),
      ],
    );
  }
}

// ── Contact button ────────────────────────────────────────────────────────────
class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  final bool filled;
  final VoidCallback onTap;

  const _ContactBtn({
    required this.icon,
    required this.label,
    required this.primary,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: filled ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: filled
              ? null
              : Border.all(color: textColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: filled ? Theme.of(context).colorScheme.surface : textColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmallSemibold(
                color: filled
                    ? Theme.of(context).colorScheme.surface
                    : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
