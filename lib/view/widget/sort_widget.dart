import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalx_task/controller/home_provider.dart';

class Sort extends StatelessWidget {
  const Sort({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, left: 20),
          child: Text(
            "Sort",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        RadioListTile<String>(
            value: "All",
            title: const Text("All"),
            groupValue: homeProvider.selectedAgeOption,
            onChanged: (value) {
              homeProvider.filterItems(value!);
            }),
        RadioListTile<String>(
            value: "Younger",
            title: const Text("Younger"),
            groupValue: homeProvider.selectedAgeOption,
            onChanged: (value) {
              homeProvider.filterItems(value!);
            }),
        RadioListTile<String>(
            value: "Elder",
            title: const Text("Elder"),
            groupValue: homeProvider.selectedAgeOption,
            onChanged: (value) {
              homeProvider.filterItems(value!);
            }),
      ],
    );
  }
}
