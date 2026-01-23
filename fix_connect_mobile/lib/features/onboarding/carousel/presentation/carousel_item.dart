import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/features/onboarding/carousel/data/carousel_model.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.carouselModel,
    required this.color,
  });

  final CarouselModel carouselModel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;

          return Column(
            children: <Widget>[
              Container(
                height: screenHeight * AppSpacing.xxxxs,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
                child: carouselModel.image,
              ),
              SizedBox(height: screenHeight * AppSpacing.xxs),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * AppSpacing.xxs,
                  ),
                  child: Column(
                    children: [
                      Text(
                        carouselModel.title,
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      AppGaps.hMd,
                      Text(
                        carouselModel.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
