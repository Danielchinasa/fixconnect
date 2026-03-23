import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class PromoBannerCarousel extends StatefulWidget {
  final Color primary;
  final bool isDark;

  const PromoBannerCarousel({
    super.key,
    required this.primary,
    required this.isDark,
  });

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  int _currentPage = 0;
  final _controller = PageController();

  static const _banners = [
    _BannerData(
      headline: 'Get 20% off your\nfirst booking!',
      subtitle: 'New users only. Use code FIRST20',
      gradient: [Color(0xFF0dd0f0), Color(0xFF0066CC)],
      icon: Icons.discount_rounded,
    ),
    _BannerData(
      headline: 'Need an electrician\nfast?',
      subtitle: 'Connect with top pros in under 10 mins',
      gradient: [Color(0xFF22C55E), Color(0xFF15803D)],
      icon: Icons.bolt_rounded,
    ),
    _BannerData(
      headline: 'Safe & Secure\nPayments',
      subtitle: 'Escrow holds your money until the job is done',
      gradient: [Color(0xFFFF6B35), Color(0xFFCC3300)],
      icon: Icons.lock_outlined,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final b = _banners[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                ),
                child: _BannerCard(data: b),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? widget.primary : AppColors.grey300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background decorative circle
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.headline,
                        style: AppTextStyles.bodyLargeBold(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle,
                        style: AppTextStyles.bodySmallRegular(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Book Now',
                          style: AppTextStyles.bodySmallBold(
                            color: data.gradient.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerData {
  final String headline;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  const _BannerData({
    required this.headline,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });
}
