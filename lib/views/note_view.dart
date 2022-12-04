import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/views/notes/note_model.dart';

class NoteView extends StatefulWidget {
  const NoteView(this.note, {super.key});

  final NoteModel note;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    var note = widget.note;
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: Paddings.padding20,
          child: Column(
            children: [
              dateTimeItem(
                Icons.timelapse_rounded,
                AppStrings.createDate,
                note.createTimeFormated,
              ),
              Spaces.vertical5,
              if (note.hasUpdateTime)
                dateTimeItem(
                  Icons.edit,
                  AppStrings.updateDate,
                  note.updateTimeFormated,
                ),
              Spaces.vertical20,
              if (note.imageUrl != null) image(context, note),
              content(context, note),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )),
    );
  }

  Widget content(BuildContext context, NoteModel note) {
    return Container(
      width: context.width(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        note.content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Container image(BuildContext context, NoteModel note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
              image: NetworkImage(
                widget.note.imageUrl!,
              ),
              fit: BoxFit.cover)),
      width: context.width(1),
      height: (context.width(1)) * note.aspectRatio,
    );
  }

  Row dateTimeItem(IconData icon, String label, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          icon,
          color: context.theme.unselectedWidgetColor,
          size: 10,
        ),
        Spaces.horizontal3,
        Text(
          label,
          style: TextStyle(
              color: context.theme.unselectedWidgetColor,
              fontSize: 10,
              fontWeight: FontWeight.w300),
        ),
        Text(text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
