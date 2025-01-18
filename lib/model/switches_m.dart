import 'contacts.dart';

class SwitchMDetails {
  late String switchId;
  late String switchSSID;
  late String switchPassword;
  late String iPAddress;
  String? switchPassKey;
  late String? selectedFan;
  late List<String> switchTypes;
  late ContactsModel contactsModel;

  SwitchMDetails(
      {required this.switchId,
      this.switchPassKey,
      required this.switchSSID,
      required this.switchTypes,
      required this.selectedFan,
      required this.switchPassword,
      required this.iPAddress,
      required this.contactsModel});

  SwitchMDetails.fromJson(Map<String, dynamic> json) {
    switchId = json['MSwitchId'];
    switchSSID = json['MSwitchSSID'];
    switchPassword = json['MSwitchPassword'];
    selectedFan = json["selectedFan"];
    switchTypes = List<String>.from(json['SwitchTypes']);
    contactsModel = ContactsModel.fromJson(json['contactsModel']);
    iPAddress = json['IPAddress'];
    switchPassKey = json['MSwitchPasskey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MSwitchId'] = switchId;
    data['MSwitchSSID'] = switchSSID;
    data['SwitchTypes'] = switchTypes;
    data["selectedFan"] = selectedFan;
    data['MSwitchPassword'] = switchPassword;
    data['IPAddress'] = iPAddress;
    data['contactsModel'] = contactsModel.toJson();
    data['MSwitchPasskey'] = switchPassKey;
    return data;
  }
}
