"""Generate Help & Support and Terms & Privacy pages."""
import os

BASE = '/Applications/MAMP/htdocs/fixconnect/fix_connect_mobile/lib'

def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
    print(f'✓ {path.replace(BASE + "/", "")} ({content.count(chr(10))} lines)')


# ══════════════════════════════════════════════════════════════════════════════
# 1. Help & Support page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/support/presentation/pages/help_support_page.dart', """
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
    _Faq('Getting Started', 'How do I find an artisan?',
        'Use the search bar on the home screen or browse service categories. You can filter by rating, specialty, and verified status to find the right match.'),
    _Faq('Getting Started', 'Are artisans on FixConnect verified?',
        'Yes. Every artisan goes through identity verification, document checks, and a background review before being listed on the platform.'),
    _Faq('Getting Started', 'How do I know if an artisan is available?',
        "Each artisan profile shows their weekly availability schedule and today's open hours. You can also see if they're currently online."),
    // Bookings
    _Faq('Bookings', 'How do I book an artisan?',
        "Open any artisan profile and tap 'Book Now'. Select your preferred date, time, address, and any notes about the job, then confirm."),
    _Faq('Bookings', 'Can I reschedule a booking?',
        'Yes. Open the booking from the My Bookings tab and tap Reschedule. Changes must be made at least 24 hours before the scheduled time.'),
    _Faq('Bookings', 'How do I cancel a booking?',
        "Open the booking detail and tap 'Cancel Booking'. Cancellations made less than 2 hours before the scheduled time may incur a small fee."),
    _Faq('Bookings', "What if the artisan doesn't show up?",
        "Contact our support team immediately. We will help you reschedule at no extra cost or issue a full refund if the artisan fails to show."),
    // Payments
    _Faq('Payments', 'What payment methods are accepted?',
        'We accept Visa, Mastercard, Verve, and bank transfers. You can save multiple payment methods under Profile → Payment Methods.'),
    _Faq('Payments', 'When am I charged?',
        'Payment is only processed after the job is marked complete. Your card is held on file but not charged until you confirm the work is done.'),
    _Faq('Payments', 'How do I request a refund?',
        'Refund requests must be submitted within 48 hours of job completion. Open the booking detail and tap Contact Support to start the process.'),
    // Account
    _Faq('Account', 'How do I update my profile?',
        'Go to Profile → Edit Profile to update your name, phone number, profile photo, and other personal details.'),
    _Faq('Account', 'Can I use FixConnect on multiple devices?',
        'Yes. Your account syncs across all devices. Simply log in with your email and password on any device.'),
    _Faq('Account', 'How do I delete my account?',
        'To delete your account, contact us at support@fixconnect.ng. Note that deletion is permanent and cannot be undone.'),
  ];

  List<_Faq> get _filtered {
    if (_searchQuery.isEmpty) return _faqs;
    final q = _searchQuery.toLowerCase();
    return _faqs
        .where((f) =>
            f.question.toLowerCase().contains(q) ||
            f.answer.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
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
            icon:
                Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Help & Support',
              style: AppTextStyles.header4Bold(color: textColor)),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 24),
          children: [
            // ── Search bar ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.custom16,
                  AppSpacing.custom8, AppSpacing.custom16, AppSpacing.custom16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14)),
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
                        color: textColor.withValues(alpha: 0.4)),
                    prefixIcon: Icon(Icons.search, color: primary, size: 20),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // ── Empty state ──────────────────────────────────────────────
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.search_off_rounded,
                      size: 48, color: primary.withValues(alpha: 0.3)),
                  AppGaps.h10,
                  Text('No results for "$_searchQuery"',
                      style: AppTextStyles.bodyMediumRegular(
                          color: textColor.withValues(alpha: 0.5))),
                ]),
              )
            else
              // ── FAQ sections ──────────────────────────────────────────
              ...categories.map((cat) {
                final items =
                    filtered.where((f) => f.category == cat).toList();
                final startIdx = filtered.indexOf(items.first);
                return Padding(
                  padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
                      AppSpacing.custom16, AppSpacing.custom16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.custom8),
                        child: Text(cat,
                            style: AppTextStyles.bodySmallSemibold(
                                color: textColor.withValues(alpha: 0.5))),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16)),
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
                              onTap: () => setState(() => _expandedIndex =
                                  isExpanded ? null : globalIdx),
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
                child: Column(children: [
                  Icon(Icons.support_agent_rounded, color: primary, size: 32),
                  AppGaps.h10,
                  Text('Still need help?',
                      style: AppTextStyles.bodyLargeBold(color: textColor)),
                  AppGaps.h4,
                  Text(
                    'Our team is available Mon–Sat, 8 AM–8 PM.',
                    style: AppTextStyles.bodySmallRegular(
                        color: textColor.withValues(alpha: 0.6)),
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
                ]),
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
    return Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))
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
          padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
              AppSpacing.custom16, AppSpacing.custom16),
          child: Text(
            faq.answer,
            style: AppTextStyles.bodySmallRegular(
                    color: textColor.withValues(alpha: 0.7))
                .copyWith(height: 1.6),
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
          child:
              Divider(height: 1, color: textColor.withValues(alpha: 0.08)),
        ),
    ]);
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
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon,
              size: 16, color: filled ? Colors.white : textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodySmallSemibold(
                color: filled ? Colors.white : textColor),
          ),
        ]),
      ),
    );
  }
}
""".lstrip())


# ══════════════════════════════════════════════════════════════════════════════
# 2. Terms & Privacy page
# ══════════════════════════════════════════════════════════════════════════════
write(f'{BASE}/features/support/presentation/pages/terms_privacy_page.dart', """
import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;

    return DefaultTabController(
      length: 2,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
              icon: Icon(Icons.arrow_back_ios_rounded,
                  size: 20, color: textColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Terms & Privacy',
                style: AppTextStyles.header4Bold(color: textColor)),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.custom16, 0,
                    AppSpacing.custom16, AppSpacing.custom8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(12)),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: textColor.withValues(alpha: 0.55),
                    labelStyle: AppTextStyles.bodySmallSemibold(),
                    unselectedLabelStyle: AppTextStyles.bodySmallRegular(),
                    tabs: const [
                      Tab(text: 'Terms of Service'),
                      Tab(text: 'Privacy Policy'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _TermsTab(textColor: textColor, primary: primary),
              _PrivacyTab(textColor: textColor, primary: primary),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Terms of Service tab ──────────────────────────────────────────────────────
class _TermsTab extends StatelessWidget {
  final Color textColor, primary;

  const _TermsTab({required this.textColor, required this.primary});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.custom16,
          AppSpacing.custom16,
          AppSpacing.custom16,
          MediaQuery.of(context).padding.bottom + AppSpacing.custom24),
      children: [
        Text('Last updated: 1 January 2025',
            style: AppTextStyles.bodySmallRegular(
                color: textColor.withValues(alpha: 0.45))),
        AppGaps.h16,
        _LegalSection(
          title: '1. Acceptance of Terms',
          body: 'By accessing or using FixConnect, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app. These terms apply to all users, including customers and artisans.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '2. Description of Services',
          body: 'FixConnect is a marketplace platform that connects customers with skilled artisans for home services. We do not employ artisans directly — they are independent service providers. FixConnect facilitates bookings and payments but is not responsible for the quality of work performed.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '3. User Accounts',
          body: 'You must provide accurate, current, and complete information when creating an account. You are responsible for maintaining the confidentiality of your account credentials. You must be at least 18 years old to use FixConnect.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '4. Bookings & Payments',
          body: 'When you book an artisan, you agree to pay the quoted price plus any applicable platform fees. Payments are held securely and released only after job completion. Cancellation fees may apply for late cancellations within 2 hours of the scheduled time.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '5. User Responsibilities',
          body: 'You agree not to use FixConnect for any unlawful purpose, to provide a safe working environment for artisans, to give accurate descriptions of work needed, and not to engage artisans outside the platform to avoid platform fees.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '6. Ratings & Reviews',
          body: 'Reviews must be honest, accurate, and based on your actual experience. We reserve the right to remove reviews that violate our guidelines, including fraudulent, harassing, or inappropriate content.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '7. Limitation of Liability',
          body: 'FixConnect is not liable for any indirect, incidental, or consequential damages arising from use of the platform. Our total liability shall not exceed the amount paid for the specific booking giving rise to the claim.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '8. Changes to Terms',
          body: 'We may update these terms from time to time. We will notify you of significant changes via email or in-app notification. Continued use of FixConnect after changes constitutes acceptance of the new terms.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '9. Governing Law',
          body: 'These terms are governed by the laws of the Federal Republic of Nigeria. Any disputes shall be resolved through binding arbitration in Lagos State.',
          textColor: textColor,
          primary: primary,
        ),
        _ContactNote(
            textColor: textColor, primary: primary, email: 'legal@fixconnect.ng'),
      ],
    );
  }
}

// ── Privacy Policy tab ────────────────────────────────────────────────────────
class _PrivacyTab extends StatelessWidget {
  final Color textColor, primary;

  const _PrivacyTab({required this.textColor, required this.primary});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.custom16,
          AppSpacing.custom16,
          AppSpacing.custom16,
          MediaQuery.of(context).padding.bottom + AppSpacing.custom24),
      children: [
        Text('Last updated: 1 January 2025',
            style: AppTextStyles.bodySmallRegular(
                color: textColor.withValues(alpha: 0.45))),
        AppGaps.h16,
        _LegalSection(
          title: '1. Information We Collect',
          body: 'We collect information you provide directly (name, email, phone, address), usage data (features used, pages visited), device information (device type, OS version, app version), and location data when you enable location-based features.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '2. How We Use Your Data',
          body: 'We use your data to provide and improve our services, process bookings and payments, send notifications and service updates, verify artisan identities, resolve disputes, and comply with our legal obligations.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '3. Data Sharing',
          body: 'We share your information with artisans you book (name, address, contact details for job completion), payment processors, and service providers that help us operate. We do not sell your personal data to third parties for marketing purposes.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '4. Data Security',
          body: 'We use industry-standard encryption and security measures to protect your data. Payment information is processed by PCI-compliant providers and is never stored on our servers.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '5. Your Rights',
          body: 'You have the right to access, correct, or delete your personal data at any time. You can manage your data through your profile settings or by contacting our support team. You may also opt out of marketing communications at any time.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '6. Cookies & Tracking',
          body: 'We use cookies and similar technologies to remember your preferences, analyze app usage, and deliver a personalised experience. You can adjust your device settings to limit data collection.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: '7. Data Retention',
          body: 'We retain your data for as long as your account is active or as needed to provide services. Booking history is kept for 3 years for dispute resolution. Accounts that are deleted are fully purged within 30 days.',
          textColor: textColor,
          primary: primary,
        ),
        _LegalSection(
          title: "8. Children's Privacy",
          body: 'FixConnect is not intended for users under 18 years of age. We do not knowingly collect personal data from minors. If you believe a child has provided us with their information, please contact us immediately.',
          textColor: textColor,
          primary: primary,
        ),
        _ContactNote(
            textColor: textColor,
            primary: primary,
            email: 'privacy@fixconnect.ng'),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _LegalSection extends StatelessWidget {
  final String title, body;
  final Color textColor, primary;

  const _LegalSection({
    required this.title,
    required this.body,
    required this.textColor,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
                color: primary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title,
                  style: AppTextStyles.bodyMediumBold(color: textColor))),
        ]),
        const SizedBox(height: 8),
        Text(
          body,
          style: AppTextStyles.bodySmallRegular(
                  color: textColor.withValues(alpha: 0.7))
              .copyWith(height: 1.65),
        ),
      ]),
    );
  }
}

class _ContactNote extends StatelessWidget {
  final Color textColor, primary;
  final String email;

  const _ContactNote(
      {required this.textColor, required this.primary, required this.email});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = context.surfaceColor;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(AppSpacing.custom16),
      decoration: BoxDecoration(
          color: surfaceColor, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Icon(Icons.mail_outline_rounded, color: primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Questions or concerns?',
                style: AppTextStyles.bodySmallSemibold(color: textColor)),
            const SizedBox(height: 2),
            Text(email,
                style: AppTextStyles.bodySmallRegular(color: primary)),
          ]),
        ),
      ]),
    );
  }
}
""".lstrip())

print('\nAll files written successfully!')
