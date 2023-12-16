class UserData {
  bool isLoggedIn;
  String username;
  int uid;

  UserData({required this.isLoggedIn, required this.username, required this.uid});
}

UserData biguname = UserData(isLoggedIn: false, username: "Guest", uid: -1);
