import 'contacts.dart';

class SwitchDetails {
  late String switchld;
  late String switchSSID;
  late String switchPassword;
  late String iPAddress;
  late String switchPassKey;
  late bool isAutoSwitch;
  late String privatePin;
  late ContactsModel contactsModel;

  SwitchDetails(
      {required this.switchld,
      required this.switchPassKey,
      required this.switchSSID,
      required this.contactsModel,
      required this.isAutoSwitch,
      required this.privatePin,
      required this.switchPassword,
      required this.iPAddress});

  SwitchDetails.fromJson(Map<String, dynamic> json) {
    switchld = json['SwitchId'];
    switchSSID = json['SwitchSSID'];
    switchPassword = json['SwitchPassword'];
    contactsModel = ContactsModel.fromJson(json['contactsModel']);
    privatePin = json['privatePin'];
    isAutoSwitch = json['isAutoSwitch'];
    iPAddress = json['IPAddress'];
    switchPassKey = json['SwitchPasskey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SwitchId'] = switchld;
    data['SwitchSSID'] = switchSSID;
    data['isAutoSwitch'] = isAutoSwitch;
    data['privatePin'] = privatePin;
    data['SwitchPassword'] = switchPassword;
    data['IPAddress'] = iPAddress;
    data['contactsModel'] = contactsModel.toJson();
    data['SwitchPasskey'] = switchPassKey;
    return data;
  }

  String toSwitchQR() {
    return "$switchld,$switchSSID,$switchPassKey,$switchPassword";
  }
}
