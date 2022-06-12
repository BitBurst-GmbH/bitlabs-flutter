import 'package:bitlabs/src/models/serializable.dart';

import 'offer.dart';

class GetOffersResponse extends Serializable {
  final List<Offer> offers;

  GetOffersResponse(Map<String, dynamic> json)
      : offers = List<Offer>.from(json['offers'].map((offer) => Offer(offer)));
}
