class ScannedImageModel {
  int? _id;
  String? _imageText;
  String? _imagePath;
  String? _date;
  String? _bookmark;

  ScannedImageModel(
    this._imageText,
    this._imagePath,
      this._date,
      this._bookmark
  );

  ScannedImageModel.withId(
    this._id,
    this._imageText,
    this._imagePath,
      this._date,
      this._bookmark
  );

  int? get id => _id;

  String? get imageText => _imageText;

  String? get imagePath => _imagePath;

  String? get date => _date;

  String? get bookmark => _bookmark;

  set imageText(String? newImageText) {
    if (newImageText != null) {
      _imageText = newImageText;
    }
  }

  set imagePath(String? newImagePath) {
    if (newImagePath != null) {
      _imagePath = newImagePath;
    }
  }

  set date(String? newDate) {
    if (newDate != null) {
      _date = newDate;
    }
  }

  set bookmark(String? newBookmark) {
    if (newBookmark != null) {
      _bookmark = newBookmark;
    }
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['imageText'] = _imageText;
    map['imagePath'] = _imagePath;
    map['date'] = _date;
    map['bookmark'] = _bookmark;

    return map;
  }

  // Extract a Note object from a Map object
  ScannedImageModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _imageText = map['imageText'];
    _imagePath = map['imagePath'];
    _date = map['date'];
    _bookmark = map['bookmark'];
  }
}
