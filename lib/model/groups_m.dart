import 'package:BBTS/model/router_to_group.dart';

import 'contacts.dart';

class GroupMDetails {
  late String groupName;
  late String selectedRouter;
  late String routerPassword;
  late List<RouterGDetails> selectedSwitches;
  late ContactsModel contactsModel;

  GroupMDetails({
    required this.groupName,
    required this.selectedRouter,
    required this.routerPassword,
    required this.selectedSwitches,
    required this.contactsModel,
  });

  GroupMDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError("The JSON data for GroupMDetails cannot be null");
    }

    groupName = json['MGroupName'] ?? '';
    selectedRouter = json['MSelectedRouter'] ?? '';
    routerPassword = json['MRouterPassword'] ?? '';
    contactsModel = ContactsModel.fromJson(json['contactsModel'] ?? {});

    var switchList = json['MSelectedSwitches'] as List? ?? [];
    selectedSwitches =
        switchList.map((e) => RouterGDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MGroupName'] = groupName;
    data['MSelectedRouter'] = selectedRouter;
    data['MRouterPassword'] = routerPassword;
    data['contactsModel'] = contactsModel.toJson();
    data['MSelectedSwitches'] =
        selectedSwitches?.map((e) => e.toJson()).toList();
    return data;
  }
}
