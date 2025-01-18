import 'contacts.dart';

class RouterMDetails {
  late String switchID;
  late String switchName;
  late String routerName;
  late String routerPassword;
  late String? selectedFan;
  late List<String> switchTypes;
  late String? iPAddress;
  late String switchPasskey;
  ContactsModel? contactsModel;

  RouterMDetails({
    required this.switchID,
    required this.routerName,
    required this.routerPassword,
    this.iPAddress,
    required this.selectedFan,
    required this.switchTypes,
    required this.switchPasskey,
    required this.switchName,
    this.contactsModel,
  });

  RouterMDetails.fromJson(Map<String, dynamic> json) {
    switchID = json['MSwitchId'];
    switchName = json['MSwitchName'];
    routerName = json['MRouterName'];
    routerPassword = json['MRouterPassword'];
    selectedFan = json['SelectedFan'];
    switchTypes = List<String>.from(json['MSwitchTypes'] ?? []);
    switchPasskey = json['MSwitchPassKey'];
    iPAddress = json['MIPAddress'];

    // Check if contactsModel exists and is not null
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
    data['MRouterName'] = routerName;
    data['MRouterPassword'] = routerPassword;
    data['MSwitchTypes'] = switchTypes;
    data['SelectedFan'] = selectedFan;
    data['MSwitchPassKey'] = switchPasskey;
    data['MIPAddress'] = iPAddress;
    data['contactsModel'] = contactsModel?.toJson();
    return data;
  }

  String toRouterQR() {
    return "$switchID,$switchName,$routerName,$switchTypes,$routerPassword,$switchPasskey,$iPAddress";
  }
}
