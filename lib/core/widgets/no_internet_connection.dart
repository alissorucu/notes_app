import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:note_app/core/import_barrel.dart';

class NoInternetConnectionAlert extends StatelessWidget {
  const NoInternetConnectionAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snap) {
          bool hasConnection = snap.data != ConnectivityResult.none;
          return AnimatedPositioned(
              right: 0,
              left: 0,
              bottom: hasConnection ? -100 : 30,
              duration: const Duration(milliseconds: 300),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.wifi_off, color: Colors.white),
                            SizedBox(width: 10),
                            Text(AppStrings.noInternetConnection,
                                style: TextStyle(color: Colors.white)),
                          ],
                        )),
                  ],
                ),
              ));
        });
  }
}
