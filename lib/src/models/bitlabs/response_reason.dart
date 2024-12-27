class RestrictionReason {
  final bool? notVerified;
  final bool? usingVpn;
  final String? bannedUntil;
  final String? reason;
  final String? unsupportedCountry;

  RestrictionReason(Map<String, dynamic> json)
      : notVerified =
            json.containsKey('not_verified') ? json['not_verified'] : null,
        usingVpn = json.containsKey('using_vpn') ? json['using_vpn'] : null,
        bannedUntil =
            json.containsKey('banned_until') ? json['banned_until'] : null,
        reason = json.containsKey('reason') ? json['reason'] : null,
        unsupportedCountry = json.containsKey('unsupported_country')
            ? json['unsupported_country']
            : null;

  Map<String, dynamic> toJson() => {
        'not_verified': notVerified,
        'using_vpn': usingVpn,
        'banned_until': bannedUntil,
        'reason': reason,
        'unsupported_country': unsupportedCountry
      };

  String prettyPrint() {
    if (notVerified == true) {
      return "The publisher account that owns this app has not been verified and therefore cannot receive surveys.";
    }

    if (usingVpn == true) {
      return "The user is using a VPN and cannot access surveys.";
    }

    if (bannedUntil != null) {
      return "The user is banned until $bannedUntil";
    }

    if (unsupportedCountry != null) {
      return "Unsupported Country: $unsupportedCountry";
    }

    return reason ?? "Unknown Reason";
  }
}
