import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalx_task/model/userlist_model.dart';

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
// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:totalx_task/model/userlist_model.dart';

// class HomeProvider extends ChangeNotifier {
//   String selectedAgeOption = "All";
//   TextEditingController searchController = TextEditingController();
//   HomeProvider() {
//     selectedAgeOption = '';
//     getData();
//     fetchAllData();

//     scrollController.addListener(() {
//       if (scrollController.position.pixels ==
//           scrollController.position.maxScrollExtent) {
//         scrollData();
//       }
//     });
//   }

//   final ScrollController scrollController = ScrollController();
//   List<UserModel> usersList = [];
//   List<UserModel> allData = [];
//   List<UserModel> sortedData = [];
//   bool isSorting = false;
//   DocumentSnapshot? lastDocument;

//   // Fetch initial data with lazy loading
//   Future<void> getData() async {
//     try {
//       final data = await FirebaseFirestore.instance
//           .collection("Upload_Items")
//           .limit(7)
//           .get();
//       if (data.docs.isNotEmpty) {
//         lastDocument = data.docs.last;
//         usersList = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       log("Error fetching initial data: $e");
//     }
//   }

//   // Fetch more data when scrolling
//   Future<void> scrollData() async {
//     if (lastDocument == null) return;
//     try {
//       final data = await FirebaseFirestore.instance
//           .collection("Upload_Items")
//           .startAfterDocument(lastDocument!)
//           .limit(2)
//           .get();
//       if (data.docs.isNotEmpty) {
//         lastDocument = data.docs.last;
//         usersList
//             .addAll(data.docs.map((e) => UserModel.fromMap(e.data())).toList());
//         notifyListeners();
//       }
//     } catch (e) {
//       log("Error fetching more data: $e");
//     }
//   }

//   // Fetch all data for sorting and searching
//   Future<void> fetchAllData() async {
//     try {
//       final data =
//           await FirebaseFirestore.instance.collection("Upload_Items").get();
//       allData.clear();
//       allData
//           .addAll(data.docs.map((e) => UserModel.fromMap(e.data())).toList());
//       notifyListeners();
//     } catch (e) {
//       log("Error fetching all data: $e");
//     }
//   }

//   // Filter data based on selected age option
//   List<UserModel> filterItems(String option) {
//     selectedAgeOption = option;

//     if (selectedAgeOption == 'Elder') {
//       isSorting = true;
//       sortedData = allData.where((item) => item.age >= 60).toList();
//     } else if (selectedAgeOption == 'Younger') {
//       isSorting = true;
//       sortedData = allData.where((item) => item.age < 60).toList();
//     } else if (selectedAgeOption == 'All') {
//       isSorting = false;
//       sortedData.clear();
//     }
//     notifyListeners();
//     return sortedData;
//   }

//   // Delete user by name
//   Future<void> deleteUser(String name) async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection("Upload_Items")
//           .where("name", isEqualTo: name)
//           .get();
//       for (var doc in querySnapshot.docs) {
//         await doc.reference.delete();
//       }
//       // Refresh data after deletion
//       await getData();
//       await fetchAllData();
//       notifyListeners();
//     } catch (e) {
//       log("Error deleting user: $e");
//     }
//   }

//   // Search for users by name or age
//   void search(String searchQuery) {
//     if (searchQuery.isEmpty) {
//       usersList = List.from(allData);
//     } else {
//       usersList = allData
//           .where((user) =>
//               user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//               user.age.toString().contains(searchQuery))
//           .toList();
//     }
//     isSorting = false;
//     notifyListeners();
//   }
// }
