import 'package:intl/intl.dart';
import 'package:note_app/core/import_barrel.dart';

class NoteModel {
  late String? docId;
  late String title;
  late String content;
  late String? imageUrl;
  late double aspectRatio;

  late int createDateTimestamp;
  late int updateDateTimestamp;

  String get createTimeFormated {
    return DateFormat("dd/MM/yyyy HH:mm").format(
      DateTime.fromMillisecondsSinceEpoch(createDateTimestamp),
    );
  }

  bool get hasUpdateTime {
    return updateDateTimestamp != createDateTimestamp;
  }

  String get updateTimeFormated {
    return DateFormat("dd/MM/yyyy HH:mm").format(
      DateTime.fromMillisecondsSinceEpoch(updateDateTimestamp),
    );
  }

  //to map
  Map<String, dynamic> toMap() {
    return {
      "uid": fbhelper.uid,
      "title": title,
      "content": content,
      "imageUrl": imageUrl,
      "createDateTimestamp": createDateTimestamp,
      "updateDateTimestamp": updateDateTimestamp,
      "aspectRatio": aspectRatio,
    };
  }

  //from map
  NoteModel.fromMap(Map<String, dynamic> map, this.docId)
      : title = map["title"],
        content = map["content"],
        imageUrl = map["imageUrl"],
        createDateTimestamp = map["createDateTimestamp"],
        updateDateTimestamp = map["updateDateTimestamp"],
        aspectRatio = ((map["aspectRatio"] ?? 1) as num).toDouble();

  //create
  NoteModel.create({
    required this.title,
    required this.content,
    this.imageUrl,
     this.aspectRatio = 1,
  }) {
    createDateTimestamp = DateTime.now().millisecondsSinceEpoch;
    updateDateTimestamp = createDateTimestamp;
  }

  //copy from
  factory NoteModel.copyFrom(NoteModel noteModel) {
    return NoteModel.fromMap(noteModel.toMap(), noteModel.docId);
  }
}
