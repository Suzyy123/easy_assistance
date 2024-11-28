class FriendRequest {
  String senderId;
  String receiverId;
  String status; // 'pending', 'accepted', 'rejected'

  FriendRequest({required this.senderId, required this.receiverId, required this.status});

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
    };
  }
}
