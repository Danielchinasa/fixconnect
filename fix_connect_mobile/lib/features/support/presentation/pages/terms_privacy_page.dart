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
