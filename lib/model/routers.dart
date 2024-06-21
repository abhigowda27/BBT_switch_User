import 'contacts.dart';

class RouterDetails {
  late String switchID;
  late String name;
  late String password;
  late String iPAddress;
  late String switchPasskey;
  late ContactsModel contactsModel;

  RouterDetails(
      {required this.switchID,
        required this.name,
        required this.password,
        required this.contactsModel,
        required this.iPAddress,
        required this.switchPasskey});

  RouterDetails.fromJson(Map<String, dynamic> json) {
    switchID = json['SwitchId'];
    name = json['SwitchSSID'];
    password = json['SwitchPassword'];
    switchPasskey = json['SwitchPassKey'];
    iPAddress = json['IPAddress'];
    contactsModel = ContactsModel.fromJson(json['contactsModel']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SwitchId'] = switchID;
    data['SwitchSSID'] = name;
    data['SwitchPassword'] = password;
    data['contactsModel'] = contactsModel.toJson();
    data['SwitchPassKey'] = switchPasskey;
    data['IPAddress'] = iPAddress;
    return data;
  }

  String toRouterQR() {
    return "$switchID,$name,$password,$switchPasskey,$iPAddress";
  }
}
