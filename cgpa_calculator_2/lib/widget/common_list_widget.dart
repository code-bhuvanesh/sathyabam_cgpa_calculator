import 'package:flutter/material.dart';

class CommonListWidget extends StatefulWidget {
  const CommonListWidget({
    super.key,
    required this.nextPage,
    required this.whatToSelect,
    required this.allItems,
    required this.totalHeight,
    required this.data,
    required this.argumentsGenerator,
  });

  final String nextPage;
  final String whatToSelect;
  final List<String> allItems;
  final double totalHeight;
  final Map<String, dynamic> data;
  final Function(String index) argumentsGenerator;

  @override
  State<CommonListWidget> createState() => _CommonListWidgetState();
}

class _CommonListWidgetState extends State<CommonListWidget> {
  TextEditingController searchedCourse = TextEditingController();
  late List<String> filteredItems = widget.allItems;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: searchedCourse,
                onChanged: (value) {
                  filteredItems = widget.allItems;
                  setState(() {
                    if (searchedCourse.text.isNotEmpty) {
                      for (var s = 0; s < searchedCourse.text.length; s++) {
                        filteredItems = filteredItems
                            .where(
                              (element) => element.toLowerCase().contains(
                                  searchedCourse.text.toLowerCase()[s]),
                            )
                            .toList();
                      }
                    } else {
                      filteredItems = widget.allItems;
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search ${widget.whatToSelect}",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                  widget.nextPage,
                  arguments: widget.argumentsGenerator(filteredItems[index]),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        filteredItems[index],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
