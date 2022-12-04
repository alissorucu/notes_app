import 'package:note_app/core/import_barrel.dart';

class PagePadding extends StatelessWidget {
  const PagePadding({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: Paddings.padding20,
        child: SizedBox(
            width: context.width(1), height: context.height(1), child: child),
      ),
    );
  }
}
