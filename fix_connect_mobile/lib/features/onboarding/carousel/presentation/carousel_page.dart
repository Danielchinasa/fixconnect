import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/core/constants/integer_constants.dart';
import 'package:fix_connect_mobile/core/widgets/button_primary.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/data/carousel_model.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/presentation/carousel_item.dart';
import 'package:flutter/material.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key, required this.pages});

  final List<CarouselModel> pages;

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // void onNextPage() {
  //   AppNavigator.of(context).pushReplacement(AppRoutes.loginScreen());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * AppSpacing.xxxs,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return CarouselItem(
                  carouselModel: widget.pages[index],
                  color: Theme.of(context).colorScheme.surface,
                );
              },
            ),
          ),
          // Static bottom section
          AppGaps.hSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              widget.pages.length,
              (int index) => Container(
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: IntegerConstants.duration300,
                  ),
                  height: AppSpacing.sm,
                  width: _currentPage == index ? AppSpacing.lg : AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withOpacity(
                            IntegerConstants.opacity25,
                          ),
                    borderRadius: BorderRadius.circular(AppSpacing.xs),
                  ),
                ),
              ),
            ),
          ),
          AppGaps.hXl,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: ButtonPrimary(
              bgColor: Theme.of(context).primaryColor,
              text: 'next',
              onTap: () {},
            ),
          ),
          AppGaps.hMd,
        ],
      ),
    );
  }
}
