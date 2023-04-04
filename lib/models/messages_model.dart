class MessagesModel {
  final String username;
  final String profilePicture;
  final String chatId;
  final DateTime timeSent;
  final String lastMessage;

  MessagesModel({
    required this.username,
    required this.profilePicture,
    required this.chatId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'profilePicture': profilePicture,
      'chatId': chatId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory MessagesModel.fromMap(Map<String, dynamic> map) {
    return MessagesModel(
      username: map['username'] as String,
      profilePicture: map['profilePicture'] as String,
      chatId: map['chatId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
