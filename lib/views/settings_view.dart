import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/widgets/areyousure_dialog.dart';
import 'package:note_app/core/widgets/loading_dialog.dart';
import 'package:note_app/main.dart';
import 'package:note_app/views/auth/auth_helper.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.settingsTitle),
      ),
      body: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoutButton(),
            Spaces.vertical20,
            const DeleteAllNotesButton()
          ],
        ),
      ),
    );
  }
}

class DeleteAllNotesButton extends StatelessWidget {
  const DeleteAllNotesButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          showAreYouSureDialog(context, AppStrings.areYouSureDeleteAllNotes,
              () async {
            showLoadingDialog(context,
                subtitle: AppStrings.deleteAllNotesLoading);
            await context.notesState.deleteAll();
            Navigator.pop(navigatorKey.currentContext!);
          });
        },
        icon: const Icon(Icons.delete),
        label: const Text(AppStrings.deleteAllNotes));
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          showAreYouSureDialog(context, AppStrings.areYouSureSignOut, () async {
            showLoadingDialog(context, subtitle: AppStrings.logoutloading);
            await authHelper.logout();
          });
        },
        label: const Text(AppStrings.logout),
        icon: const Icon(Icons.logout));
  }
}
