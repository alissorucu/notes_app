import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:note_app/core/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  SharedManager._internal();
  static final SharedManager _sharedManager = SharedManager._internal();

  static SharedManager get instance => _sharedManager;

  late SharedPreferences _prefs;
  late EncryptedSharedPreferences _encryptedSharedPreferences;

  Future<void> initalize() async {
    _prefs = await SharedPreferences.getInstance();

    _encryptedSharedPreferences = EncryptedSharedPreferences(prefs: _prefs);
    lastEmail = await encryptedEmail;
    if (lastEmail == "") {
      lastEmail = "-";
    }
  }

  bool get hasLastLogin => lastEmail != "-";
  String lastEmail = "-";

  //email
  Future<String> get encryptedEmail async =>
      await _encryptedSharedPreferences.getString("email");

  int _emailSaveTryCount = 0;
  Future<void> saveEmailEncrypted(String value) async {
    lastEmail = value;
    bool result = await _encryptedSharedPreferences.setString("email", value);
    if (!result) {
      if (_emailSaveTryCount < 3) {
        _emailSaveTryCount++;
        await saveEmailEncrypted(value);
      }
      if (_emailSaveTryCount == 3) {
        _emailSaveTryCount = 0;
        throw Exception(AppStrings.emailNotSaved);
      }
    }
  }

  void clearLastLogin() {
    saveEmailEncrypted("-");
  }
}
