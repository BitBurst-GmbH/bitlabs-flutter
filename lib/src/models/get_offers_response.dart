import 'package:bitlabs/src/models/serializable.dart';

import 'offer.dart';

class GetOffersResponse extends Serializable {
  final List<Offer>? offers;

  GetOffersResponse(Map<String, dynamic> json)
      : offers = json.containsKey('offers') && json['offers'] != null
            ? List<Offer>.from(json['offers'].map((offer) => Offer(offer)))
            : null;
}
