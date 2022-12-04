import '../import_barrel.dart';

showPopupAlert(BuildContext context, Widget dialog) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return ScaleTransition(
        scale: Tween<double>(begin: .5, end: 1).animate(animation),
        child: dialog,
      );
    },
  );
}
