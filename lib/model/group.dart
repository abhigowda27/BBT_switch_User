import 'contacts.dart';
import 'routers.dart';

class GroupDetails {
  late String groupName;
  late String selectedRouter;
  late List<RouterDetails> selectedSwitches;
  late ContactsModel contactsModel;

  GroupDetails({
    required this.groupName,
    required this.selectedRouter,
    required this.selectedSwitches,
    required this.contactsModel,
  });

  GroupDetails.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    selectedRouter = json['selectedRouter'] ;
    contactsModel = ContactsModel.fromJson(json['contactsModel']);
    var switchList = json['selectedSwitches'] as List;
    selectedSwitches = switchList.map((e) => RouterDetails.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['groupName'] = groupName;
    data['selectedRouter'] = selectedRouter;
    data['contactsModel'] = contactsModel.toJson();
    data['selectedSwitches'] = selectedSwitches.map((e) => e.toJson()).toList();
    return data;
  }

  String toGroupQR() {
    String switchesQR = selectedSwitches.map((switchDetails) => switchDetails.toRouterQR()).join(",");
    return "$groupName,$selectedRouter,[$switchesQR]";
  }

}