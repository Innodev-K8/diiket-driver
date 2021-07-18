import 'dart:async';
import 'package:driver/data/notification/notification_topic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:diiket_models/all.dart';
import 'package:driver/data/network/auth_service.dart';
import 'package:driver/data/providers/firebase_provider.dart';

import 'token_provider.dart';

final authLoadingProvider = StateProvider<bool>((_) => true);

final authProvider = StateNotifierProvider<AuthState, User?>((ref) {
  return AuthState(
    ref.read(authServiceProvider),
    ref.read,
  );
});

final authExceptionProvider = StateProvider<CustomException?>((_) => null);

class AuthState extends StateNotifier<User?> {
  AuthService _authService;
  Reader _read;

  AuthState(
    this._authService,
    this._read,
  ) : super(null) {
    this.refreshProfile();
  }

  // Komunikasi ke laravel
  Future<void> updateUserName(String name) async {
    try {
      await _authService.updateProfile({
        'name': name,
      });

      await refreshProfile();
    } on CustomException catch (error) {
      _read(authExceptionProvider).state = error;
    }
  }

  Future<void> refreshProfile() async {
    try {
      state = await _authService.me();

      await subscribeToMarketDriverNotificationTopic(state);
    } on CustomException catch (error) {
      _read(authExceptionProvider).state = error;
    } finally {
      _read(authLoadingProvider).state = false;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _read(authLoadingProvider).state = true;

      final fcmToken = await _read(messagingProvider).getToken();

      final AuthResponse response =
          await _authService.loginWithEmailPassword(email, password, fcmToken);

      if (response.token != null && response.user != null) {
        await _read(tokenProvider.notifier).setToken(response.token!);
        await _read(crashlyticsProvider)
            .setUserIdentifier('${response.user!.id}#${response.user!.name}');

        state = response.user;

        await subscribeToMarketDriverNotificationTopic(state);
      } else {
        await signOut();
      }
    } on CustomException catch (error) {
      _read(authExceptionProvider).state = error;
    } finally {
      _read(authLoadingProvider).state = false;
    }
  }

  Future<void> signOut() async {
    try {
      _read(authLoadingProvider).state = true;

      await _authService.logout().onError((error, stackTrace) => null);
      await _read(tokenProvider.notifier).clearToken();
      await unSubscribeToMarketDriverNotificationTopic(state);

      state = null;

      _read(authLoadingProvider).state = false;
    } on CustomException catch (error) {
      _read(authExceptionProvider).state = error;
    }
  }
}
