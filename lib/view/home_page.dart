import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_task/controller/home_provider.dart';
import 'package:totalx_task/view/loginscreens/login_page.dart';
import 'package:totalx_task/view/widget/alertbox.dart';
import 'package:totalx_task/view/widget/sort_age.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                actions: [
                  IconButton(
                      tooltip: "Logout",
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      },
                      icon: const Icon(
                        Icons.logout_outlined,
                        color: Color.fromARGB(255, 146, 144, 144),
                      ))
                ],
              ),
              backgroundColor: const Color.fromARGB(255, 233, 233, 233),
              body: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: homeProvider.searchController,
                            onChanged: (value) {
                              homeProvider.search(value);
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search by name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 200,
                                  child: Consumer<HomeProvider>(
                                    builder: (context, value, child) {
                                      return SortAge();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.filter_list_sharp,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "User Lists",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.separated(
                        controller: homeProvider.scrollController,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: homeProvider.isSorting
                            ? homeProvider.sorteddata.length
                            : homeProvider.userslist.length + 1,
                        itemBuilder: (context, index) {
                          final condition = homeProvider.isSorting
                              ? homeProvider.sorteddata.length
                              : homeProvider.userslist.length;
                          if (index < condition) {
                            final data = homeProvider.isSorting
                                ? homeProvider.sorteddata[index]
                                : homeProvider.userslist[index];
                            return Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: const [BoxShadow(blurRadius: .2)],
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 15),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage:
                                                      NetworkImage(data.image)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      "Age : ${data.age}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(255, 239, 127, 119),
                                    ),
                                    onPressed: () {
                                      homeProvider.deleteUser(data.name);
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else if (homeProvider.userslist.length !=
                              homeProvider.alldata.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertBoxWidget();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
