import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/widgets/show_popup_alert.dart';

showAreYouSureDialog(
  BuildContext context,
  String msg,
  VoidCallback onAccepted,
) async {
  showPopupAlert(
      context,
      AlertDialog(
        title: Text(msg),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(AppStrings.no)),
          TextButton(
              onPressed: () async {
                onAccepted();
                Navigator.pop(context);
              },
              child: const Text(AppStrings.yes)),
        ],
      ));
}
