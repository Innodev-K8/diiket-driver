import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:driver/data/secure_storage.dart';

final tokenProvider =
    StateNotifierProvider<TokenState, String?>((_) => TokenState());

class TokenState extends StateNotifier<String?> {
  TokenState() : super(null);

  Future<void> setToken(String token) async {
    await SecureStorage.setToken(token);
    state = token;
  }

  Future<void> clearToken() async {
    await SecureStorage.clearToken();
    state = null;
  }
}
