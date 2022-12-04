import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/shared_manager.dart';
import 'package:note_app/core/styles/theme.dart';
import 'package:note_app/core/widgets/no_internet_connection.dart';
import 'package:note_app/views/auth/login_view.dart';
import 'package:note_app/views/auth/password_login_view.dart';
import 'package:note_app/views/notes/notes_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.instance.initalize();
  await fbhelper.initalize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    fbhelper.startListeningAuthStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesController>(
        create: (context) => NotesController(),
        builder: (context, w) {
          return DoubleBack(
            message: AppStrings.doubleBack,
            child: MaterialApp(
                title: AppStrings.appName,
                theme: themeData,
                navigatorKey: navigatorKey,
                navigatorObservers: [firebaseObserver],
                debugShowCheckedModeBanner: false,
                home: SharedManager.instance.hasLastLogin
                    ? const PasswordLoginView()
                    : const LoginView(),
                builder: (context, child) {
                  return MainBuilder(
                    child ?? const SizedBox.shrink(),
                  );
                }),
          );
        });
  }
}

class MainBuilder extends StatefulWidget {
  const MainBuilder(
    this.c, {
    Key? key,
  }) : super(key: key);

  final Widget c;

  @override
  State<MainBuilder> createState() => _MainBuilderState();
}

class _MainBuilderState extends State<MainBuilder> {
  @override
  void didUpdateWidget(covariant MainBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print("main builder");
    return SizedBox(
      width: context.width(1),
      height: context.height(1),
      child: Stack(
        children: [widget.c, const NoInternetConnectionAlert()],
      ),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: analytics);
