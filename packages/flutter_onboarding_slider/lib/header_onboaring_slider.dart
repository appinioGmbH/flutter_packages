import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class HeaderOnBoaringSlider extends StatelessWidget {
  final int currentPage;
  final Function()? onSkip;
  final bool isLightMode;
  final double spacing;
  final double heightHeader;
  final String textButtonSkip;
  final List<SlideOnBoarding> slides;
  HeaderOnBoaringSlider({
    required this.currentPage,
    required this.onSkip,
    required this.slides,
    this.textButtonSkip = '',
    this.isLightMode = false,
    this.spacing = 4,
    this.heightHeader = 55,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: heightHeader,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: slides.map((e) {
                int i = slides.indexOf(e);
                return Expanded(
                    child: Container(
                  decoration: BoxDecoration(color: colorUnderlined(i), borderRadius: BorderRadius.circular(4)),
                  margin: EdgeInsets.only(left: i == 0 ? 0 : spacing),
                  height: 2,
                ));
              }).toList(),
            ),
            SizedBox(
              height: 14,
            ),
            if (textButtonSkip != '')
              SizedBox(
                height: 36,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    textButtonSkip,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: isLightMode ? Colors.black : Colors.white),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (Set<MaterialState> states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ); // Defer to the widget's default.
                      },
                    ),
                    padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                      (Set<MaterialState> states) {
                        return EdgeInsets.symmetric(vertical: 6, horizontal: 16);
                      },
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.white.withOpacity(0.1); // Defer to the widget's default.
                      },
                    ),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        width: isLightMode ? 1 : 0,
                        color: isLightMode ? Color(0xffDDDDDD) : Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }

  Color colorUnderlined(int i) {
    if (isLightMode) {
      return i == currentPage ? Colors.black : Color(0xffDDDDDD);
    } else {
      return i == currentPage ? Colors.white : Colors.white.withOpacity(0.4);
    }
  }
}
