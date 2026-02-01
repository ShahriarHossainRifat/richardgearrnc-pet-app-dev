import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:petzy_app/features/home/domain/entities/post_user.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

/// Represents a comment on a community post.
///
/// Uses Freezed for immutability and JSON serialization.
@freezed
abstract class Comment with _$Comment {
  /// Creates a [Comment] instance.
  const factory Comment({
    required final String id,
    required final String text,
    required final PostUser user,
    @JsonKey(name: 'createdAt') required final DateTime createdAt,
    @Default(0) final int likeCount,
    @Default(false) final bool isLiked,
  }) = _Comment;

  /// Creates a [Comment] instance from JSON.
  factory Comment.fromJson(final Map<String, dynamic> json) => _$CommentFromJson(json);
}
