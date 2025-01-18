import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/group.dart';
import '../model/routers.dart';
import '../model/switches.dart';
import '../widgets/toast.dart';

class StorageController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> loadGroupSwitchState(groupName) async {
    String? value = await storage.read(key: groupName);
    return value != null && value.toLowerCase() == 'true';
  }

  Future<void> saveGroupSwitchState(String groupName, bool value) async {
    await storage.delete(key: groupName);
    await storage.write(key: groupName, value: value.toString());
  }

  deleteGroups() async {
    await storage.delete(key: "groups");
  }

  deleteRouters() async {
    await storage.delete(key: "routers");
  }

  deleteSwitches() async {
    await storage.delete(key: "switches");
  }

  Future<List<SwitchDetails>> readSwitches() async {
    String? switches = await storage.read(key: "switches");
    List<SwitchDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "switches", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      print(jsonContacts);
      for (var element in jsonContacts) {
        _model.add(SwitchDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneSwitch(SwitchDetails switchDetails) async {
    List<SwitchDetails> switchList = await readSwitches();
    switchList.removeWhere(
        (element) => element.switchSSID == switchDetails.switchSSID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    await deleteSwitches();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  Future<void> updateSwitch(
      String idOfSwitch, SwitchDetails switchDetails) async {
    List<SwitchDetails> switchesList = await readSwitches();
    List<RouterDetails> routersList = await readRouters();

    print("-------------");
    print(
        "Switches before update: ${switchesList.map((e) => e.toJson()).toList()}");
    print(
        "Routers before update: ${routersList.map((e) => e.toJson()).toList()}");

    // Update switch details in the list
    for (var element in switchesList) {
      if (element.switchld == idOfSwitch) {
        element.switchld = switchDetails.switchld;
        element.switchPassword = switchDetails.switchPassword;
        element.switchSSID = switchDetails.switchSSID;
        element.switchPassKey = switchDetails.switchPassKey;
        break;
      }
    }

    print(
        "Switches after update: ${switchesList.map((e) => e.toJson()).toList()}");

    // Update the storage for switches
    await deleteSwitches();
    await storage.write(
        key: "switches",
        value: json.encode(switchesList.map((e) => e.toJson()).toList()));

    for (var element in routersList) {
      if (element.switchID == idOfSwitch) {
        element.switchID = switchDetails.switchld;
        element.switchName = switchDetails.switchSSID;
        element.switchPasskey = switchDetails.switchPassKey!;
        // Keep the name, password, and ipAddress the same
        element.name = element.name;
        element.password = element.password;
        element.iPAddress = element.iPAddress;
        break;
      }
    }

    print(
        "Routers after update: ${routersList.map((e) => e.toJson()).toList()}");

    // Update the storage for routers
    await deleteRouters();
    await storage.write(
        key: "routers",
        value: json.encode(routersList.map((e) => e.toJson()).toList()));
  }

  getSwitchBySSID(switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var element in switchesList) {
      if (element.switchSSID == switchSSID) return element;
    }
    return null;
  }

  getRouterByName(switchName) async {
    List<RouterDetails> routerList = await readRouters();
    for (var element in routerList) {
      if ("${element.name}_${element.switchName}" == switchName) return element;
    }
    return null;
  }

  getGroupByName(groupName) async {
    List<GroupDetails> groupList = await readAllGroups();
    for (var element in groupList) {
      if (element.groupName == groupName) return element;
    }
    return null;
  }

  Future<bool> isSwitchSSIDExists(String switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var switchDetails in switchesList) {
      if (switchDetails.switchSSID == switchSSID) {
        return true;
      }
    }
    return false;
  }

  void addSwitches(BuildContext context, SwitchDetails switchDetails) async {
    bool exists = await isSwitchSSIDExists(switchDetails.switchSSID);
    if (exists) {
      showToast(context, "Switch Name already exists.");
      return;
    }
    List<SwitchDetails> switchesList = await readSwitches();
    switchesList.add(switchDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  Future<List<RouterDetails>> readRouters() async {
    String? switches = await storage.read(key: "routers");
    List<RouterDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "routers", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      for (var element in jsonContacts) {
        _model.add(RouterDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneRouter(RouterDetails switchDetails) async {
    List<RouterDetails> switchList = await readRouters();
    switchList
        .removeWhere((element) => element.switchID == switchDetails.switchID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<bool> isSwitchIDExists(String switchID) async {
    List<RouterDetails> RouterList = await readRouters();
    for (var switchDetails in RouterList) {
      if (switchDetails.switchID == switchID) {
        return true;
      }
    }
    return false;
  }

  void addRouters(BuildContext context, RouterDetails routerDetails) async {
    bool exists = await isSwitchIDExists(routerDetails.switchID);
    if (exists) {
      showToast(context, "Router Switch ID already exists.");
      return;
    }
    List<RouterDetails> switchesList = await readRouters();
    switchesList.add(routerDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  Future<void> saveGroupDetails(
      BuildContext context, GroupDetails groupDetails) async {
    bool exists = await groupExists(groupDetails.groupName);
    if (exists) {
      showToast(context, "Group Name already exists.");
      return;
    }
    List<GroupDetails> groups = await readAllGroups();
    groups.add(groupDetails);
    List listContectsInJson = groups.map((e) {
      return e.toJson();
    }).toList();
    await storage.write(key: "groups", value: json.encode(listContectsInJson));
  }

  Future<List<GroupDetails>> readAllGroups() async {
    String? groupsJson = await storage.read(key: 'groups');
    if (groupsJson == null) return [];
    List<dynamic> groupsList = jsonDecode(groupsJson);
    return groupsList.map((json) => GroupDetails.fromJson(json)).toList();
  }

  Future<bool> groupExists(String groupName) async {
    List<GroupDetails> allGroups = await readAllGroups();

    return allGroups.any((group) => group.groupName == groupName);
  }

  Future<void> deleteOneGroup(GroupDetails groupDetails) async {
    List<GroupDetails> groups = await readAllGroups();
    groups.removeWhere((group) => group.groupName == groupDetails.groupName);
    await storage.write(
      key: 'groups',
      value: jsonEncode(groups.map((group) => group.toJson()).toList()),
    );
  }
}
