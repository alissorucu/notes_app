part of 'notes_controller.dart';

final _noteService = _NotesService._();

class _NotesService {
  _NotesService._();

  Future<List<NoteModel>> getNotes({NoteModel? lastDoc}) async {
    List<NoteModel> notes = [];

    var query = fbhelper.notesReference
        .where("uid", isEqualTo: fbhelper.uid)
        .orderBy("createDateTimestamp", descending: true)
        .limit(10);
    QuerySnapshot<Map<String, dynamic>> response;
    if (lastDoc != null) {
      query = query.startAfter([lastDoc.createDateTimestamp]);
    }
    response = await query.get();
    if (response.docs.isNotEmpty) {
      notes.addAll(response.docs.map((e) => NoteModel.fromMap(e.data(), e.id)));
    }
    return notes;
  }

  //delete note
  Future<void> deleteNote({
    required String docId,
  }) async {
    await fbhelper.notesReference.doc(docId).delete();
  }

  Future<void> deleteAll() async {
    var response = await fbhelper.notesReference.get();
    for (DocumentSnapshot<Map<String, dynamic>> doc in response.docs) {
      await doc.reference.delete();
    }
  }

  Future<NoteModel?> updateNote(NoteModel noteModel) async {
    noteModel.updateDateTimestamp = DateTime.now().millisecondsSinceEpoch;
    try {
      await fbhelper.notesReference
          .doc(noteModel.docId)
          .update(noteModel.toMap());
      return noteModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<NoteModel?> createNote({
    required File? imageFile,
    required String title,
    required String content,
    required double aspectRatio,
  }) async {
    try {
      final noteModel = NoteModel.create(
          title: title, content: content, aspectRatio: aspectRatio);
      if (imageFile != null) {
        noteModel.imageUrl = await fbhelper.uploadImage(imageFile);
      }
      var result = await fbhelper.notesReference.add(noteModel.toMap());
      noteModel.docId = result.id;
      return noteModel;
    } catch (e) {
      print(e);
    }
    return null;
  }

 
}
