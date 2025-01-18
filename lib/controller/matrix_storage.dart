import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/groups_m.dart';
import '../model/routers_m.dart';
import '../model/switches_m.dart';
import '../widgets/toast.dart';

class MatrixStorageController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> loadGroupSwitchState(key) async {
    String? value = await storage.read(key: key);
    return value != null && value.toLowerCase() == 'true';
  }

  Future<void> saveGroupSwitchState(key, value) async {
    await storage.delete(key: key);
    await storage.write(key: key, value: value.toString());
  }

  deleteGroups() async {
    await storage.delete(key: "Mgroups");
  }

  deleteRouters() async {
    await storage.delete(key: "Mrouters");
  }

  deleteSwitches() async {
    await storage.delete(key: "Mswitches");
  }

  Future<List<SwitchMDetails>> readSwitches() async {
    String? switches = await storage.read(key: "Mswitches");
    List<SwitchMDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "Mswitches", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      print(jsonContacts);
      for (var element in jsonContacts) {
        _model.add(SwitchMDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneSwitch(SwitchMDetails switchDetails) async {
    List<SwitchMDetails> switchList = await readSwitches();
    switchList.removeWhere(
        (element) => element.switchSSID == switchDetails.switchSSID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    await deleteSwitches();
    storage.write(key: "Mswitches", value: json.encode(listContectsInJson));
  }

  Future<void> updateSwitch(
      String idOfSwitch, SwitchMDetails switchDetails) async {
    List<SwitchMDetails> switchesList = await readSwitches();
    List<RouterMDetails> routersList = await readRouters();

    print("-------------");
    print(
        "Switches before update: ${switchesList.map((e) => e.toJson()).toList()}");
    print(
        "Routers before update: ${routersList.map((e) => e.toJson()).toList()}");

    // Update switch details in the list
    for (var element in switchesList) {
      if (element.switchId == idOfSwitch) {
        element.switchId = switchDetails.switchId;
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
        key: "Mswitches",
        value: json.encode(switchesList.map((e) => e.toJson()).toList()));

    // Update router details if the router is associated with the switch
    for (var element in routersList) {
      if (element.switchID == idOfSwitch) {
        element.switchID = switchDetails.switchId;
        element.switchName = switchDetails.switchSSID;
        element.switchPasskey = switchDetails.switchPassKey!;
        // Keep the name, password, and ipAddress the same
        element.routerName = element.routerName;
        element.routerPassword = element.routerPassword;
        element.iPAddress = element.iPAddress;
        break;
      }
    }

    print(
        "Routers after update: ${routersList.map((e) => e.toJson()).toList()}");

    await deleteRouters();
    await storage.write(
        key: "Mrouters",
        value: json.encode(routersList.map((e) => e.toJson()).toList()));
  }

  getSwitchBySSID(switchSSID) async {
    List<SwitchMDetails> switchesList = await readSwitches();
    for (var element in switchesList) {
      if (element.switchSSID == switchSSID) return element;
    }
    return null;
  }

  getRouterByName(switchName) async {
    List<RouterMDetails> routerList = await readRouters();
    for (var element in routerList) {
      if ("${element.routerName}_${element.switchName}" == switchName)
        return element;
    }
    return null;
  }

  getGroupByName(groupName) async {
    List<GroupMDetails> groupList = await readAllGroups();
    for (var element in groupList) {
      if (element.groupName == groupName) return element;
    }
    return null;
  }

  Future<bool> isSwitchSSIDExists(String switchSSID) async {
    List<SwitchMDetails> switchesList = await readSwitches();
    for (var switchDetails in switchesList) {
      if (switchDetails.switchSSID == switchSSID) {
        return true;
      }
    }
    return false;
  }

  void addSwitches(BuildContext context, SwitchMDetails switchDetails) async {
    bool exists = await isSwitchSSIDExists(switchDetails.switchSSID);
    if (exists) {
      showToast(context, "Switch Name already exists.");
      return;
    }
    List<SwitchMDetails> switchesList = await readSwitches();
    switchesList.add(switchDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "Mswitches", value: json.encode(listContectsInJson));
  }

  Future<List<RouterMDetails>> readRouters() async {
    String? switches = await storage.read(key: "Mrouters");
    List<RouterMDetails> _model = [];
    if (switches == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "Mrouters", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(switches);
      for (var element in jsonContacts) {
        _model.add(RouterMDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneRouter(RouterMDetails switchDetails) async {
    List<RouterMDetails> switchList = await readRouters();
    switchList
        .removeWhere((element) => element.switchID == switchDetails.switchID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "Mrouters", value: json.encode(listContectsInJson));
  }

  Future<bool> isSwitchIDExists(String switchID) async {
    List<RouterMDetails> RouterList = await readRouters();
    for (var switchDetails in RouterList) {
      if (switchDetails.switchID == switchID) {
        return true;
      }
    }
    return false;
  }

  void addRouters(BuildContext context, RouterMDetails routerDetails) async {
    bool exists = await isSwitchIDExists(routerDetails.switchID);
    if (exists) {
      showToast(context, "Router Switch ID already exists.");
      return;
    }
    List<RouterMDetails> switchesList = await readRouters();
    switchesList.add(routerDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "Mrouters", value: json.encode(listContectsInJson));
  }

  Future<void> saveGroupDetails(
      BuildContext context, GroupMDetails groupDetails) async {
    bool exists = await groupExists(groupDetails.groupName);
    if (exists) {
      showToast(context, "Group Name already exists.");
      return;
    }
    List<GroupMDetails> groups = await readAllGroups();
    groups.add(groupDetails);
    List listContectsInJson = groups.map((e) {
      return e.toJson();
    }).toList();
    await storage.write(key: "Mgroups", value: json.encode(listContectsInJson));
  }

  Future<List<GroupMDetails>> readAllGroups() async {
    String? groupsJson = await storage.read(key: 'Mgroups');
    if (groupsJson == null) return [];
    List<dynamic> groupsList = jsonDecode(groupsJson);
    return groupsList.map((json) => GroupMDetails.fromJson(json)).toList();
  }

  Future<bool> groupExists(String groupName) async {
    List<GroupMDetails> allGroups = await readAllGroups();

    return allGroups.any((group) => group.groupName == groupName);
  }

  Future<void> deleteOneGroup(GroupMDetails groupDetails) async {
    List<GroupMDetails> groups = await readAllGroups();
    groups.removeWhere((group) => group.groupName == groupDetails.groupName);
    await storage.write(
      key: 'Mgroups',
      value: jsonEncode(groups.map((group) => group.toJson()).toList()),
    );
  }
}
