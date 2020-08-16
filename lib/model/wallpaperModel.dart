class wallpaperModel {
  String photographer;
  String photographer_url;
  int photographer_id;
  SrcModel src;

  wallpaperModel(
      {this.photographer,
      this.photographer_url,
      this.photographer_id,
      this.src});
// factory methods are there to handle bulk data, for example we are getting a map object as input for this wallpaperModel we need to fill our data fields with the incoming data
// to create an object with the data
  factory wallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return wallpaperModel(
        src: SrcModel.fromMap(jsonData["src"]),
        photographer_url: jsonData["photographer_url"],
        photographer: jsonData["photographer"],
        photographer_id: jsonData["photographer_id"]);
  }
}

class SrcModel {
  String original;
  String small;
  String portrait;
  SrcModel({
    this.original,
    this.portrait,
    this.small,
  });

  factory SrcModel.fromMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData["original"],
      small: jsonData["small"],
      portrait: jsonData["portrait"],
    );
  }
}
