import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../feature/data/model/auth_user.dart';
import '../../../feature/presentation/provider/auth_notifier.dart';
import 'package:user_login_project/feature/data/LocalStorage/local_storage_service.dart';

class ProfileTab extends ConsumerWidget {
  final AuthUser user;
  
  const ProfileTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            radius: 50,
          ),
          const SizedBox(height: 20,),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '@${user.username}',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text('Email: ${user.email}'),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8)
            ),
            child: SelectableText(
              'Token: ${user.accessToken}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 45)
            ),
              onPressed: () {
                LocalStorageService.clearAll();
                ref.read(authControllerProvider.notifier).logout();
              },
              child: const Text('Log out', style: TextStyle(color: Colors.white),))
        ],
      ),
    );
  }
}