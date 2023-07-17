import 'package:bitlabs/bitlabs.dart';
import 'package:bitlabs/src/ui/simple_survey_widget.dart';
import 'package:flutter/widgets.dart';

import '../api/bitlabs_repository.dart';
import '../utils/notifiers.dart' as notifiers;
import 'compact_survey_widget.dart';
import 'full_width_survey_widget.dart';

class SurveyWidget extends StatefulWidget {
  final String loi;
  final int rating;
  final List<Color> color;
  final String reward;
  final WidgetType type;

  const SurveyWidget(
      {Key? key,
      required this.reward,
      required this.loi,
      required this.color,
      required this.rating,
      required this.type})
      : super(key: key);

  @override
  State<SurveyWidget> createState() => _SurveyWidgetState();
}

class _SurveyWidgetState extends State<SurveyWidget> {
  var opacity = 1.0;
  Widget? image;

  void _updateImageWidget() {
    BitLabsRepository.getCurrencyIcon(notifiers.currencyIconURL.value,
        (imageData) => setState(() => image = imageData));
  }

  @override
  void initState() {
    super.initState();
    if (notifiers.currencyIconURL.value.isNotEmpty) {
      _updateImageWidget();
    } else {
      notifiers.currencyIconURL.addListener(_updateImageWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Start onTap Animation
        setState(() => opacity = .5);
        await Future.delayed(const Duration(milliseconds: 50));
        setState(() => opacity = 1.0);
        await Future.delayed(const Duration(milliseconds: 40));
        // End onTap Animation

        if (!mounted) return;
        BitLabs.instance.launchOfferWall(context);
      },
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 50),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.color.map((c) => c.withOpacity(opacity)).toList(),
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        width: getWidgetWidth(widget.type, context),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: getWidgetWithType(
          widget.type,
          widget.rating,
          widget.reward,
          widget.loi,
          widget.color.first,
          image,
        ),
      ),
    );
  }

  @override
  void dispose() {
    notifiers.currencyIconURL.removeListener(_updateImageWidget);
    super.dispose();
  }
}

double getWidgetWidth(WidgetType type, BuildContext context) {
  switch (type) {
    case WidgetType.simple:
      return MediaQuery.of(context).size.width * .7;
    case WidgetType.fullWidth:
      return MediaQuery.of(context).size.width * 1.05;
    case WidgetType.compact:
      return MediaQuery.of(context).size.width * .7;
  }
}

Widget getWidgetWithType(WidgetType type, int rating, String reward, String loi,
    Color color, Widget? image) {
  switch (type) {
    case WidgetType.simple:
      return SimpleSurveyWidget(
          reward: reward, loi: loi, color: color, image: image);
    case WidgetType.fullWidth:
      return FullWidthSurveyWidget(
          rating: rating, reward: reward, loi: loi, color: color, image: image);
    case WidgetType.compact:
      return CompactSurveyWidget(
          rating: rating, reward: reward, loi: loi, color: color, image: image);
  }
}
