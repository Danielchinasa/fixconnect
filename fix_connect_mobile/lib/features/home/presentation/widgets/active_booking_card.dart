import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ActiveBookingCard extends StatelessWidget {
  final Color primary;
  final Color textColor;
  final bool isDark;

  const ActiveBookingCard({
    super.key,
    required this.primary,
    required this.textColor,
    required this.isDark,
  });

  // Job status progression
  static const _steps = ['Confirmed', 'En Route', 'In Progress', 'Done'];
  static const _currentStep = 1; // 0-based: "En Route"

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Active Job',
                            style: AppTextStyles.bodySmallBold(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'View details',
                        style: AppTextStyles.bodySmallMedium(
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Artisan info row
                Row(
                  children: [
                    // Avatar
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            'EO',
                            style: AppTextStyles.bodyMediumBold(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ADE80),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emeka Okafor',
                            style: AppTextStyles.bodyMediumBold(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Master Plumber · Pipe leakage repair',
                            style: AppTextStyles.bodySmallRegular(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chat button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Call button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.call_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Progress stepper
                Row(
                  children: List.generate(_steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      // Connector line
                      final stepIndex = i ~/ 2;
                      final isCompleted = stepIndex < _currentStep;
                      return Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                        ),
                      );
                    }
                    final stepIndex = i ~/ 2;
                    final isCompleted = stepIndex <= _currentStep;
                    final isCurrent = stepIndex == _currentStep;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isCurrent ? 22 : 16,
                          height: isCurrent ? 22 : 16,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: isCurrent
                                ? Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: isCompleted
                              ? Icon(
                                  isCurrent
                                      ? Icons.directions_walk_rounded
                                      : Icons.check,
                                  color: primary,
                                  size: isCurrent ? 13 : 10,
                                )
                              : null,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _steps[stepIndex],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isCurrent
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isCompleted
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
