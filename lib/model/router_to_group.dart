import 'contacts.dart';

class RouterGDetails {
  late String switchID;
  late String switchName;
  late String switchPasskey;
  late int switchTypes;
  late String? selectedFan;
  late String? iPAddress;
  ContactsModel? contactsModel;

  RouterGDetails({
    required this.switchID,
    required this.switchName,
    this.iPAddress,
    required this.selectedFan,
    required this.switchTypes,
    required this.switchPasskey,
    this.contactsModel,
  });

  RouterGDetails.fromJson(Map<String, dynamic> json) {
    switchID = json['MSwitchId'];
    switchName = json['MSwitchName'];
    selectedFan = json['SelectedFan'];
    switchTypes = json['MSwitchTypes'];
    switchPasskey = json['MSwitchPassKey'];
    iPAddress = json['MIPAddress'];

    if (json['contactsModel'] != null) {
      contactsModel = ContactsModel.fromJson(json['contactsModel']);
    } else {
      contactsModel = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MSwitchId'] = switchID;
    data['MSwitchName'] = switchName;
    data['MSwitchTypes'] = switchTypes;
    data['SelectedFan'] = selectedFan;
    data['MSwitchPassKey'] = switchPasskey;
    data['MIPAddress'] = iPAddress;
    data['contactsModel'] = contactsModel?.toJson();
    return data;
  }
}
