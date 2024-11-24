// lib/models/git_commit.dart
class GitCommit {
  final String title;
  final String repository_url;
  final String author_name;
  final String timestamp;
  final String content;

  GitCommit({
    required this.title,
    required this.repository_url,
    required this.author_name,
    required this.timestamp,
    required this.content,
  });

  factory GitCommit.fromJson(Map<String, dynamic> json) {
    return GitCommit(
      title: json['title'] ?? '',
      repository_url: json['repository_url'] ?? '',
      author_name: json['author_name'] ?? '',
      timestamp: json['timestamp'] ?? '',
      content: json['content'] ?? '',
    );
  }
}