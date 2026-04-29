import 'package:uuid/uuid.dart';

class CommandRequest {
  final String id;
  final String category;
  final String action;
  final Map<String, dynamic> payload;
  final String timestamp;

  CommandRequest({
    required this.category,
    required this.action,
    this.payload = const {},
  })  : id = const Uuid().v4(),
        timestamp = DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'action': action,
        'payload': payload,
        'timestamp': timestamp,
      };
}

class CommandResponse {
  final String? requestId;
  final String status;
  final dynamic data;
  final String? error;

  CommandResponse({
    this.requestId,
    required this.status,
    this.data,
    this.error,
  });

  factory CommandResponse.fromJson(Map<String, dynamic> json) {
    return CommandResponse(
      requestId: json['request_id'],
      status: json['status'],
      data: json['data'],
      error: json['error'],
    );
  }
}
