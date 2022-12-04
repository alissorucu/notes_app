import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/views/notes/notes_controller.dart';
import 'package:provider/provider.dart';

extension ContextExtension on BuildContext {
  double width(double val) => MediaQuery.of(this).size.width * val;
  double height(double val) => MediaQuery.of(this).size.height * val;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;


  NotesController get notesState => read<NotesController>();

}
