import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalx_task/model/user_model.dart';

class HomeProvider extends ChangeNotifier {
  String selectedAgeOption = "All";
  TextEditingController searchController = TextEditingController();
  HomeProvider() {
    selectedAgeOption = '';
    getdata();
    fetchalldata();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        scrolldata();
      }
    });
  }

  final ScrollController scrollController = ScrollController();
  List<UserModel> userslist = [];
  List<UserModel> alldata = [];
  List<UserModel> sorteddata = [];
  bool isSorting = false;
  var lastdocument;

// lazy loading
  Future<void> getdata() async {
    final data = await FirebaseFirestore.instance
        .collection("Upload_Items")
        .limit(7)
        .get();
    lastdocument = data.docs.last;
    userslist = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
    notifyListeners();
  }

  Future<void> scrolldata() async {
    final data = await FirebaseFirestore.instance
        .collection("Upload_Items")
        .startAfterDocument(lastdocument)
        .limit(2)
        .get();
    lastdocument = data.docs.last;
    userslist
        .addAll(data.docs.map((e) => UserModel.fromMap(e.data())).toList());
    notifyListeners();
  }

  Future<void> fetchalldata() async {
    final data =
        await FirebaseFirestore.instance.collection("Upload_Items").get();
    alldata.clear();
    alldata.addAll(data.docs.map((e) => UserModel.fromMap(e.data())).toList());
    notifyListeners();
  }

// sorting by age

  List<UserModel> filterItems(String option) {
    selectedAgeOption = option;

    if (selectedAgeOption == 'Elder') {
      isSorting = true;
      sorteddata.clear();
      sorteddata = alldata.where((item) => item.age >= 60).toList();
    } else if (selectedAgeOption == 'Younger') {
      isSorting = true;
      sorteddata.clear();
      sorteddata = alldata.where((item) => item.age < 60).toList();
    } else if (selectedAgeOption == 'All') {
      isSorting = false;
      sorteddata.clear();
    }
    notifyListeners();
    return sorteddata;
  }

// delete user with name

  Future<void> deleteUser(String name) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Upload_Items")
          .where("name", isEqualTo: name)
          .get();
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
      });
      getdata();
      fetchalldata();
      notifyListeners();
    } catch (e) {
      log("Error deleting user: $e");
    }
  }

  int selectedValue = 1;
  void search(String search) {
    userslist.clear();
    selectedValue = 1;
    isSorting = false;
    userslist.addAll(alldata.where((user) =>
        user.name.toLowerCase().contains(search.toLowerCase()) ||
        user.age.toString().toLowerCase().contains(search.toLowerCase())));
    notifyListeners();
  }
}
