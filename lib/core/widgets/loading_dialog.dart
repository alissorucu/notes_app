import 'package:note_app/core/import_barrel.dart';

showLoadingDialog(
  BuildContext context, {
  String? subtitle,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        return LoadingDialog(
          subtitle: subtitle,
        );
      });
}

class LoadingDialog extends StatelessWidget {
  final String? subtitle;
  const LoadingDialog({
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      return false;
    }, child: StatefulBuilder(builder: (context, ss) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        content: Row(
          children: [
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                )),
            Spaces.horizontal15,
            SizedBox(
              width: context.width(1) - 120,
              child: Text(
                "${subtitle ?? ""} ${AppStrings.plsWait}",
              ),
            )
          ],
        ),
      );
    }));
  }
}
