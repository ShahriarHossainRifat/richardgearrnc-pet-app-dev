import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/core/network/api_client.dart';
import 'package:petzy_app/features/home/data/repositories/community_repository_remote.dart';
import 'package:petzy_app/features/home/domain/repositories/community_repository.dart';

/// Provides an instance of [CommunityRepository].
final communityRepositoryProvider = Provider<CommunityRepository>((final ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CommunityRepositoryRemote(apiClient: apiClient);
});
