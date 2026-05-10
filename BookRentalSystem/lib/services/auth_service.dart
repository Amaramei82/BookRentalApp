class User {
  final String fullName;
  final String email;
  final String password;

  User({required this.fullName, required this.email, required this.password});
}

class AuthService {
  final Map<String, User> _users = {};
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<String> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (_users.containsKey(email)) {
      return 'Email already exists. Please use a different email.';
    }
    _users[email] = User(fullName: fullName, email: email, password: password);
    return 'Success';
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    if (_users.containsKey(email) && _users[email]!.password == password) {
      return _users[email];
    }
    return null;
  }
}
