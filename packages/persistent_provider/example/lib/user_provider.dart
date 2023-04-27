import 'package:persistent_provider/persistent_provider.dart';

class UserProvider extends PersistentProvider {
  String _name = '';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  @override
  void fromJson(Map<String, dynamic> data) {
    _name = data['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {"name": _name};
  }
}
