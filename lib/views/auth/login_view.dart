import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/views/auth/auth_helper.dart';
import 'package:note_app/views/auth/registration_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  double logoScale = 0.5;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool obsecurePassword = true;

  bool loginLoading = false;
  @override
  void dispose() {
    _passwordFocusNode.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        logoScale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PagePadding(
          child: Column(
        children: [
          Spaces.vertical20,
          _AnimatedAppLogo(logoScale: logoScale),
          Spaces.vertical20,
          buildLoginForm(context),
          Spaces.vertical25,
          if (loginLoading)
            const CircularProgressIndicator()
          else
            loginButton(),
        
          const Spacer(),
          const _DontHaveAccountButton(),
          Spaces.vertical20,
        ],
      )),
    );
  }

  Align loginButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
          onPressed: () async {
            if (loginLoading) {
              return;
            }
            if (_formKey.currentState!.validate()) {
              loginLoading = true;
              setState(() {});
              await authHelper.login(_emailController.text.trim(),
                  _passwordController.text.trim());
              loginLoading = false;
              setState(() {});
            }
          },
          label: const Text(AppStrings.loginButtonText),
          icon: const Icon(Icons.login)),
    );
  }

  Form buildLoginForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                value ??= "";
                if (!EmailValidator.validate(value)) {
                  return AppStrings.invalidEmail;
                }
                return null;
              },
              controller: _emailController,
              onFieldSubmitted: (value) {
                _passwordFocusNode.nextFocus();
              },
              decoration: const InputDecoration(
                  labelText: AppStrings.email,
                  hintText: AppStrings.inputEmail,
                  border: OutlineInputBorder()),
            ),
            Spaces.vertical15,
            TextFormField(
              validator: (value) {
                value ??= "";
                if (value.isEmpty || value.length < 6) {
                  return AppStrings.minPasswordLength;
                }
                return null;
              },
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              obscureText: obsecurePassword,
              decoration: InputDecoration(
                  labelText: AppStrings.password,
                  hintText: AppStrings.inputPassword,
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obsecurePassword = !obsecurePassword;
                        });
                      },
                      child: Icon(obsecurePassword
                          ? Icons.lock_rounded
                          : Icons.lock_open_rounded)),
                  border: const OutlineInputBorder()),
            ),
          ],
        ));
  }
}

class _DontHaveAccountButton extends StatelessWidget {
  const _DontHaveAccountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: AppStrings.dontHaveAccount,
            style: context.textTheme.bodyText2,
            children: [
          TextSpan(
              text: AppStrings.register,
              style: context.textTheme.bodyText2!
                  .copyWith(color: context.theme.colorScheme.primary),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  nextScreenAnimated(context, const RegistrationView(),
                      "registration", RouteFrom.RIGHT);
                })
        ]));
  }
}

class _AnimatedAppLogo extends StatelessWidget {
  const _AnimatedAppLogo({
    Key? key,
    required this.logoScale,
  }) : super(key: key);

  final double logoScale;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 300),
      scale: logoScale,
      curve: Curves.easeInOut,
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.book_rounded,
            size: context.width(0.3),
            color: context.theme.colorScheme.primary,
          ),
          Spaces.vertical20,
          Text(AppStrings.appName, style: context.textTheme.headline5),
        ],
      ),
    );
  }
}
