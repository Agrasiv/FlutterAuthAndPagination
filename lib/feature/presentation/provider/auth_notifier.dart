
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:user_login_project/feature/data/LocalStorage/local_storage_service.dart';
import '../../../feature/data/model/login_request.dart';
import '../../../feature/data/model/auth_user.dart';
import '../../../feature/data/datasource/api_client.dart';

final dioProvider = Provider((ref) => Dio());
final apiClientProvider = Provider((ref) => ApiClient(ref.watch(dioProvider)));

class AuthNotifier extends AutoDisposeAsyncNotifier<AuthUser?>{

  @override
  Future<AuthUser?> build() async {
    return await LocalStorageService.getUserData();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final client = ref.read(apiClientProvider);
      final request = LoginRequest(username: username, password: password);
      final user = await client.login(request);
      await LocalStorageService.saveAuthData(user);
      return user;

    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await LocalStorageService.clearAll();
    state = const AsyncData(null);
  }
}

final authControllerProvider = AsyncNotifierProvider.autoDispose<AuthNotifier, AuthUser?>(
    () => AuthNotifier()
);