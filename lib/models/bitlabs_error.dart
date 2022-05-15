import 'error_details.dart';

class BitLabsError {
  final ErrorDetails details;

  BitLabsError(Map<String, dynamic> json) : details = json["details"];

  Map<String, ErrorDetails> toJson() => {'details': details};
}
