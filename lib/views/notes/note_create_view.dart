import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/main.dart';
import 'package:note_app/views/notes/note_model.dart';
import 'package:note_app/views/notes/notes_controller.dart';
import 'package:provider/provider.dart';

class NoteCreateView extends StatefulWidget {
  const NoteCreateView({super.key, this.note});
  final NoteModel? note;
  @override
  State<NoteCreateView> createState() => _NoteCreateViewState();
}

class _NoteCreateViewState extends State<NoteCreateView> {
  final _formKey = GlobalKey<FormState>();

  final _contentFocusNode = FocusNode();

  @override
  void initState() {
    if (widget.note != null) {
      context.notesState.initEditingNote(widget.note!);
    }
    super.initState();
  }

  //dispose
  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      navigatorKey.currentContext!.notesState.editingNote = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(AppStrings.createNote),
      ),
      body: PagePadding(
          child: Consumer<NotesController>(builder: (context, state, ch) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            addPhotoTitle(context),
            Spaces.vertical15,
            photoPick(state, context),
            Spaces.vertical25,
            buildTitleAndContentForm(state),
            const Spacer(),
            if (state.saveLoading)
              const Align(
                  alignment: Alignment.bottomRight,
                  child: CircularProgressIndicator())
            else
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      state.saveNote();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(AppStrings.saveButton),
                ),
              ),
            Spaces.vertical25,
          ],
        );
      })),
    );
  }

  Form buildTitleAndContentForm(NotesController state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.header,
            style: context.textTheme.headline6,
          ),
          Spaces.vertical15,
          TextFormField(
            controller: state.titleController,
            onFieldSubmitted: (v) {
              _contentFocusNode.requestFocus();
            },
            decoration: const InputDecoration(
              hintText: AppStrings.headerHint,
            ),
            validator: (value) {
              value ??= "";
              if (value.isEmpty || value.length < 3) {
                return AppStrings.headerRequired;
              }
              return null;
            },
          ),
          //!content
          Spaces.vertical25, Spaces.vertical25,
          Text(
            AppStrings.content,
            style: context.textTheme.headline6,
          ),
          Spaces.vertical15,
          TextFormField(
            minLines: 3,
            maxLines: 6,
            controller: state.contentController,
            focusNode: _contentFocusNode,
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                hintText: AppStrings.contentHint,
                border: OutlineInputBorder()),
            validator: (value) {
              value ??= "";
              if (value.isEmpty || value.length < 10) {
                return AppStrings.contentRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Row photoPick(NotesController state, BuildContext context) {
    return Row(
      children: [
        if (state.imageFile == null && !state.onNetworkImage)
          GestureDetector(
            onTap: showPickImageDialog,
            child: SizedBox(
              width: context.width(0.3),
              height: context.width(0.3) * state.selectedAspectRatio,
              child: Card(
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: context.width(0.1),
                  color: context.theme.primaryColor,
                ),
              ),
            ),
          )
        else
          GestureDetector(
            onTap: showPickImageDialog,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image(
                image: ((state.onNetworkImage)
                    ? NetworkImage(state.editingNote!.imageUrl!)
                    : FileImage(state.imageFile!)) as ImageProvider,
                width: context.width(0.3),
                fit: BoxFit.cover,
                height: context.width(0.3) * state.selectedAspectRatio,
              ),
            ),
          ),
        Spaces.horizontal10,
        if (state.hasImage)
          GestureDetector(
            onTap: () {
              state.imageFile = null;
              state.editingNote?.imageUrl = null;
              state.selectedAspectRatio = 3 / 4;
            },
            child: const Icon(Icons.delete),
          ),
        const Spacer(),
        if (state.hasImage) ...[
          Text(
            AppStrings.photoAspectRatio,
            style: context.textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
          Spaces.horizontal10,
          Column(
            children: [
              IconButton(
                  onPressed: () => state.selectedAspectRatio = 3 / 4,
                  icon: Text("3:4",
                      style: TextStyle(
                          fontWeight: state.selectedAspectRatio == 3 / 4
                              ? FontWeight.bold
                              : FontWeight.normal))),
              IconButton(
                  onPressed: () => state.selectedAspectRatio = 9 / 16,
                  icon: Text("9:16",
                      style: TextStyle(
                          fontWeight: state.selectedAspectRatio == 9 / 16
                              ? FontWeight.bold
                              : FontWeight.normal))),
            ],
          )
        ]
      ],
    );
  }

  Future<dynamic> showPickImageDialog() {
    return showModalBottomSheet(
        context: context,
        builder: (c) {
          return SizedBox(
            height: 140,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  onTap: () async {
                    Navigator.pop(context);
                    context.read<NotesController>().pickImageFromCamera();
                  },
                  title: const Text(AppStrings.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  onTap: () async {
                    Navigator.pop(context);
                    context.read<NotesController>().pickImageFromGallery();
                  },
                  title: const Text(AppStrings.gallery),
                ),
              ],
            ),
          );
        });
  }

  Row addPhotoTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.addPhoto,
          style: context.textTheme.headline6,
        ),
        Spaces.horizontal10,
        Text(
          AppStrings.optional,
          style: context.textTheme.caption,
        ),
      ],
    );
  }
}
