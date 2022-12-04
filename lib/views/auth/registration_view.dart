import 'package:email_validator/email_validator.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/views/auth/auth_helper.dart';


class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();

  bool obsecurePassword = true;

  bool registrationLoading = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.register),
      ),
      body: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Spacer(),
            buildRegistrationForm(context),
            Spaces.vertical20,
            if (registrationLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                  onPressed: () async {
                    if (registrationLoading) {
                      return;
                    }

                    if (_formKey.currentState!.validate()) {
                      registrationLoading = true;
                      setState(() {});
                      await authHelper.registration(
                          _emailController.text.trim(),
                          _passwordController.text.trim());
                      registrationLoading = false;
                      setState(() {});
                    }
                  },
                  child: const Text(AppStrings.register)),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Form buildRegistrationForm(BuildContext context) {
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
              autofocus: true,
              controller: _emailController,
              onFieldSubmitted: (value) {
                _passwordFocusNode.requestFocus();
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
