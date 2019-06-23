class RedditPost {
  final String name;
  final String title;
  final int score;
  final String author;
  final String thumbnail;
  final String url;

  RedditPost({this.name, this.title, this.score, this.author, this.thumbnail, this.url});

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
        name: json['name'],
        title: json['title'],
        score: json['score'],
        author: json['author'],
        thumbnail: json['thumbnail'],
        url: json['url']
    );
  }

}