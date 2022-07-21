import 'dart:convert';

class Visual {
  final String backgroundColor;
  final int colorRatingThreshold;
  final String customLogoUrl;
  final String elementBorderRadius;
  final bool hideRewardValue;
  final String interactionColor;
  final String navigationColor;
  final String offerwallWidth;
  final String screenoutReward;
  final String surveyIconColor;

  Visual(Map<String, dynamic> json)
      : backgroundColor = json['background_color'],
        colorRatingThreshold = json['color_rating_threshold'],
        customLogoUrl = json['custom_logo_url'],
        elementBorderRadius = json['element_border_radius'],
        hideRewardValue = json['hide_reward_value'],
        interactionColor = json['interaction_color'],
        navigationColor = json['navigation_color'],
        offerwallWidth = json['offerwall_width'],
        screenoutReward = json['screenout_reward'],
        surveyIconColor = json['survey_icon_color'];

  Map<String, dynamic> toJson() => {
        'background_color': backgroundColor,
        'color_rating_threshold': colorRatingThreshold,
        'custom_logo_url': customLogoUrl,
        'element_border_radius': elementBorderRadius,
        'hide_reward_value': hideRewardValue,
        'interaction_color': interactionColor,
        'navigation_color': navigationColor,
        'offerwall_width': offerwallWidth,
        'screenout_reward': screenoutReward,
        'survey_icon_color': surveyIconColor
      };

  @override
  String toString() => jsonEncode(this);
}
