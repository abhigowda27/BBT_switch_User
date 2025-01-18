import 'contacts.dart';

class RouterDetails {
  late String switchID;
  late String name;
  late String password;
  late String iPAddress;
  late String switchPasskey;
  late String switchName;
  ContactsModel? contactsModel;

  RouterDetails(
      {required this.switchID,
      required this.name,
      required this.password,
      this.contactsModel,
      required this.iPAddress,
      required this.switchName,
      required this.switchPasskey});

  RouterDetails.fromJson(Map<String, dynamic> json) {
    switchID = json['SwitchId'];
    switchName = json['SwitchName'];
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
    data['contactsModel'] = contactsModel?.toJson();
    data['SwitchPassKey'] = switchPasskey;
    data['SwitchName'] = switchName;
    data['IPAddress'] = iPAddress;
    return data;
  }

  String toRouterQR() {
    return "$switchID,$switchName,$name,$password,$switchPasskey,$iPAddress";
  }
}
