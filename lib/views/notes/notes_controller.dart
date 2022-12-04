import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/core/load_state.dart';
import 'package:note_app/core/toast_helper.dart';
import 'package:note_app/main.dart';
import 'package:note_app/views/notes/note_model.dart';

part 'notes_service.dart';

class NotesController extends ChangeNotifier {
  final List<NoteModel> notes = [];

  LoadState _loadState = LoadState.notInitalized;

  double _selectedAspectRatio = 3 / 4;

  double get selectedAspectRatio => _selectedAspectRatio;

  set selectedAspectRatio(double selectedAspectRatio) {
    _selectedAspectRatio = selectedAspectRatio;

    Future.microtask(() => notifyListeners());
  }

  LoadState get loadState => _loadState;

  set loadState(LoadState loadState) {
    _loadState = loadState;
    notifyListeners();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  NoteModel? editingNote;

  bool get onNetworkImage =>
      editingNote != null && imageFile == null && editingNote!.imageUrl != null;

  bool get hasImage => imageFile != null || editingNote?.imageUrl != null;

  Future<void> initalize() async {
    if (loadState.isInitalized) {
      return;
    }
    await Future.microtask(() {});
    loadState = LoadState.loading;
    print(fbhelper.uid);
    notes.addAll(await _noteService.getNotes());
    loadState = LoadState.loaded;
  }

  //load more
  Future<void> loadMore() async {
    if (loadState.isLoading) {
      return;
    }
    loadState = LoadState.loading;
    notes.addAll(await _noteService.getNotes(lastDoc: notes.last));
    loadState = LoadState.loaded;
  }

  bool saveLoading = false;
  Future<bool> saveNote() async {
    if (saveLoading) {
      return false;
    }
    saveLoading = true;
    notifyListeners();
    bool success = false;
    if (editingNote != null) {
      success = await updateNote();
    } else {
      success = await createNote();
    }
    saveLoading = false;
    notifyListeners();
    await Future.microtask(() {});
    if (success) {
      showSuccessToast(AppStrings.saveSuccess);
      resetFields();
      Navigator.pop(navigatorKey.currentContext!);
    } else {
      showErrorToast(AppStrings.saveError);
    }

    return success;
  }

  resetFields() {
    editingNote = null;
    titleController.text = "";
    contentController.text = "";
    imageFile = null;
    selectedAspectRatio = 1;
  }

  Future<void> deleteNote({
    required NoteModel noteModel,
  }) async {
    try {
      await _noteService.deleteNote(docId: noteModel.docId!);
      notes.remove(noteModel);
      notifyListeners();
      showSuccessToast(AppStrings.deleteSuccess);
    } catch (e) {
      showErrorToast(AppStrings.deleteError);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _noteService.deleteAll();
      notes.clear();
      notifyListeners();
      showSuccessToast(AppStrings.deleteSuccess);
    } catch (e) {
      showErrorToast(AppStrings.deleteError);
    }
  }

  File? imageFile;

  final _imagePicker = ImagePicker();
  Future pickImageFromGallery() async {
    final imagepicked =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (imagepicked != null) {
      imageFile = File(imagepicked.path);
      notifyListeners();
    }
  }

  Future pickImageFromCamera() async {
    final imagepicked =
        await _imagePicker.pickImage(source: ImageSource.camera);

    if (imagepicked != null) {
      imageFile = File(imagepicked.path);
      notifyListeners();
    }
  }

  Future<void> initEditingNote(NoteModel noteModel) async {
    resetFields();
    editingNote = noteModel;
    titleController.text = noteModel.title;
    contentController.text = noteModel.content;
    _selectedAspectRatio = noteModel.aspectRatio;

    await Future.microtask(() {});

    notifyListeners();
  }

  Future<bool> updateNote() async {
    editingNote!.aspectRatio = _selectedAspectRatio;
    editingNote!.title = titleController.text;
    editingNote!.content = contentController.text;

    if (imageFile != null) {
      editingNote!.imageUrl = await fbhelper.uploadImage(imageFile!);
    }

    NoteModel? resultNote = await _noteService.updateNote(editingNote!);
    if (resultNote != null) {
      int index = notes.indexOf(
          notes.where((element) => element.docId == editingNote!.docId).first);
      notes[index] = resultNote;
      return true;
    }
    return false;
  }

  createNote() async {
    NoteModel? resultNote = await _noteService.createNote(
        title: titleController.text.trim(),
        content: contentController.text,
        imageFile: imageFile,
        aspectRatio: selectedAspectRatio);

    if (resultNote != null) {
      notes.insert(0, resultNote);
      return true;
    }
    return false;
  }
}
