import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/shared_manager.dart';
import 'package:note_app/views/auth/auth_helper.dart';
import 'package:note_app/views/auth/login_view.dart';

class PasswordLoginView extends StatefulWidget {
  const PasswordLoginView({super.key});

  @override
  State<PasswordLoginView> createState() => _PasswordLoginViewState();
}

class _PasswordLoginViewState extends State<PasswordLoginView> {
  final TextEditingController _passwordController = TextEditingController();

  bool loginLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PagePadding(
          child: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: Card(
              child: Padding(
                padding: Paddings.padding20,
                child: Column(children: [
                  Text(
                    AppStrings.passwordLogin,
                    style: context.textTheme.headline6,
                  ),
                  const Spacer(),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: AppStrings.email,
                    ),
                  ),
                  const Spacer(flex: 1),
                  if (loginLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                        onPressed: () async {
                          if (loginLoading) {
                            return;
                          }
                          loginLoading = true;
                          setState(() {});
                          try {
                            await authHelper.login(
                                SharedManager.instance.lastEmail,
                                _passwordController.text.trim());
                          } catch (e) {
                            loginLoading = false;
                            setState(() {});
                            return;
                          }
                          loginLoading = false;
                          setState(() {});
                        },
                        child: const Text(AppStrings.loginButtonText)),
                  const Spacer(flex: 1),
                  mevcuthesap(),
                  Spaces.vertical20,
                  goToEmailLoginButton(context),
                ]),
              ),
            ),
          ),
          const Spacer()
        ],
      )),
    );
  }

  TextButton goToEmailLoginButton(BuildContext context) {
    return TextButton(
        onPressed: () {
          nextScreenCloseOthersAnimated(
              context, const LoginView(), "login", RouteFrom.BOTTOM);
          SharedManager.instance.clearLastLogin();
        },
        child: const Text(AppStrings.anotherEmail));
  }

  Row mevcuthesap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.currentEmail,
            style: TextStyle(color: Colors.black54)),
        Text(
            "${SharedManager.instance.lastEmail.substring(0, 3)}****@${SharedManager.instance.lastEmail.split('@')[1]}"),
      ],
    );
  }
}
