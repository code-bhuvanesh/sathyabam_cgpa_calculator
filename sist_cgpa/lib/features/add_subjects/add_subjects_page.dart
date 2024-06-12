import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sist_cgpa/models/sem_subject.dart';
import 'package:sist_cgpa/models/subject.dart';
import '../../utilites/theme.dart';
import './bloc/add_page_bloc.dart';
import 'add_custom_subject.dart';

class AddSubjectsPage extends StatefulWidget {
  const AddSubjectsPage({super.key});
  static const routeName = "/addsubjects";

  @override
  State<AddSubjectsPage> createState() => _AddSubjectsPageState();
}

class _AddSubjectsPageState extends State<AddSubjectsPage> {
  var addTextController = TextEditingController();
  List<Subject> subjectsList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<AddSubjectBloc>().add(SearchSubjectEvent(searchText: ""));
  }

  late ScrollController _scrollController;
  Color _containerColor = Colors.transparent;
  void _onScroll() {
    double offset = _scrollController.offset;
    setState(() {
      debugPrint(offset.toString());
      if (offset > 0) {
        _containerColor = scrollContainerColor;
      } else {
        _containerColor = backgroundColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Subject",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocListener<AddSubjectBloc, AddSubjectState>(
          listener: (context, state) {
            if (state is SearchResultState) {
              setState(() {
                subjectsList = state.subjectsList;
              });
            }
          },
          child: Container(
            color: backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: _containerColor,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: addTextController,
                    onChanged: (s) => context.read<AddSubjectBloc>().add(
                          SearchSubjectEvent(searchText: s),
                        ),
                    decoration: InputDecoration(
                      hintText: "Search by Subject name or subject code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    controller: _scrollController,
                    itemBuilder: (_, index) {
                      if (index == 0) {
                        return addCustomSubjectButtton(context);
                      }
                      return AddSubjectTile(
                        subject: subjectsList[index],
                      );
                    },
                    itemCount: subjectsList.length + 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addCustomSubjectButtton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var result = await showDialog(
          context: context,
          builder: (context) => const Dialog(
            child: AddCustomSubjectDialog(),
          ),
        );
        // ignore: use_build_context_synchronously
        if (result != null) Navigator.of(context).pop(result);
      },
      child: Card(
        elevation: 5,
        color: Theme.of(context).primaryColor,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Add Custom Subject",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddSubjectTile extends StatefulWidget {
  const AddSubjectTile({
    super.key,
    required this.subject,
  });
  final Subject subject;

  @override
  State<AddSubjectTile> createState() => _AddSubjectTileState();
}

class _AddSubjectTileState extends State<AddSubjectTile> {
  var validate = false;

  void validateField(String? txt) {
    debugPrint("validating");
    if (txt != null && txt.isNotEmpty) {
      final int mark = int.parse(txt);
      if (mark > 100) {
        setState(() {
          validate = true;
        });
      } else {
        setState(() {
          validate = false;
        });
      }
    } else {
      setState(() {
        validate = false;
      });
    }

    // if (!validate) {
    //   widget.checkToCalculate();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
      fontSize: 18,
    );
    return GestureDetector(
      onTap: () async {
        var scoreController = TextEditingController();
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Whats your score in",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    widget.subject.subCode,
                    style: textStyle,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    widget.subject.subName,
                    style: textStyle,
                  ),
                  Container(
                    margin: const EdgeInsets.all(
                      20,
                    ),
                    width: 100,
                    // child: TextField(
                    //   controller: ScoreController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(20),
                    //       borderSide: const BorderSide(color: Colors.blue),
                    //     ),
                    //   ),
                    // ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: scoreController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: validateField,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: widget.subject.maxMarks.toString(),
                        errorText: validate ? null : null,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (scoreController.text.isNotEmpty) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        );
        if (scoreController.text.isNotEmpty) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop(
            SemSubject(
              sub: widget.subject,
              mark: int.parse(scoreController.text),
            ),
          );
        }
      },
      child: Card(
        color: Theme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.subject.subCode,
                style: const TextStyle(
                  // color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.subject.subName,
                style: const TextStyle(
                    // color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
