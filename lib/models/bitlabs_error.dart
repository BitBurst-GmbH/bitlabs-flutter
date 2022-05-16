import 'dart:developer';

import 'error_details.dart';

class BitLabsError {
  final ErrorDetails details;

  BitLabsError(Map<String, dynamic> json)
      : details = ErrorDetails(json["details"]);

  Map<String, ErrorDetails> toJson() => {'details': details};
}
