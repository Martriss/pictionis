class MessageEvent {
  String user;
  String message;

  MessageEvent({
    required this.user,
    required this.message
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'message': message
    };
  }

  factory MessageEvent.fromJson(Map<String, dynamic> json) {
    return MessageEvent(
      user: json['user'] as String,
      message: json['message'] as String
    );
  }
}