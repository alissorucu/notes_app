import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/load_state.dart';
import 'package:note_app/core/widgets/areyousure_dialog.dart';
import 'package:note_app/core/widgets/loading_dialog.dart';
import 'package:note_app/main.dart';
import 'package:note_app/views/note_view.dart';
import 'package:note_app/views/notes/note_create_view.dart';
import 'package:note_app/views/notes/note_model.dart';
import 'package:note_app/views/notes/notes_controller.dart';
import 'package:note_app/views/settings_view.dart';
import 'package:provider/provider.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final scrollCont = ScrollController();
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.notesState.initalize();
      scrollCont.addListener(() {
        if (scrollCont.position.pixels == scrollCont.position.maxScrollExtent) {
          context.notesState.loadMore();
          print("load more");
        }
      });
    });
  }

  @override
  void dispose() {
    scrollCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nextScreen(context, const NoteCreateView(), "new_note");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(AppStrings.notesTitle),
        actions: [
          //Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              nextScreenAnimated(
                  context, const SettingsView(), "settings", RouteFrom.RIGHT);
            },
          ),
        ],
      ),
      body: PagePadding(
          child: Consumer<NotesController>(builder: (context, state, ch) {
        return Column(
          children: [
            if (state.loadState.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                  controller: scrollCont,
                  itemCount: state.notes.length,
                  itemBuilder: (c, i) {
                    return NoteListItem(item: state.notes[i]);
                  }),
            ),
          ],
        );
      })),
    );
  }
}

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final NoteModel item;
  final double tileHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(item.createDateTimestamp.toString()),
      closeOnScroll: true,
      endActionPane: ActionPane(
          extentRatio: 120 / (context.width(1) - 40),
          dragDismissible: true,
          motion: Row(
            children: [
              GestureDetector(
                onTap: () {
                  nextScreen(
                      context,
                      NoteCreateView(note: NoteModel.copyFrom(item)),
                      "edit_note");
                },
                child: Container(
                    height: tileHeight,
                    width: 60,
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: const Icon(Icons.edit, color: Colors.white)),
              ),
              GestureDetector(
                onTap: () {
                  showAreYouSureDialog(context, AppStrings.areYouSureDeleteNote,
                      () async {
                    showLoadingDialog(context);
                    await context.notesState.deleteNote(noteModel: item);
                    Navigator.pop(navigatorKey.currentState!.context);
                  });
                },
                child: Container(
                    height: tileHeight,
                    width: 60,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        color: Colors.red),
                    child: const Icon(Icons.delete, color: Colors.white)),
              ),
            ],
          ),
          children: const []),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          height: tileHeight,
          child: ListTile(
            onTap: () {
              nextScreenAnimated(
                  context, NoteView(item), "note_details", RouteFrom.RIGHT);
            },
            tileColor: Colors.white,
            title: Text(item.title),
            subtitle: Text(item.createTimeFormated),
          ),
        ),
      ),
    );
  }
}
