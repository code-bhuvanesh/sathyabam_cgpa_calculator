import 'package:flutter/material.dart';
import 'package:sist_cgpa/models/sem_subject.dart';
import 'package:sist_cgpa/models/subject.dart';

class AddCustomSubjectDialog extends StatefulWidget {
  const AddCustomSubjectDialog({super.key});

  @override
  State<AddCustomSubjectDialog> createState() => _AddCustomSubjectDialogState();
}

class _AddCustomSubjectDialogState extends State<AddCustomSubjectDialog> {
  var subjectTypes = ["THEROY", "PRACTICAL"];
  var subName = TextEditingController();
  var subCode = TextEditingController();
  var subcredit = TextEditingController();
  var subType = "THEROY";
  var maxMarks = TextEditingController();
  var totalMarks = TextEditingController();

  var border = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.black,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(
      20,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Custom Subject",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          customTextField(
            hintText: "Subject code",
            controller: subCode,
          ),
          customTextField(
            hintText: "Subject name",
            controller: subName,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                constraints: const BoxConstraints(
                  minWidth: 140,
                ),
                child: DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(
                    enabledBorder: border,
                    border: border,
                  ),
                  value: subjectTypes[0],
                  items: subjectTypes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    subType = (value != null) ? value : subType;
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              customTextField(
                hintText: "credit",
                isSmall: true,
                controller: subcredit,
                inputType: TextInputType.number,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              customTextField(
                hintText: "max\nMark",
                isSmall: true,
                controller: maxMarks,
                inputType: TextInputType.number,
              ),
              const SizedBox(
                width: 20,
              ),
              customTextField(
                hintText: "your\nMark",
                isSmall: true,
                controller: totalMarks,
                inputType: TextInputType.number,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              onPressed: () {
                var sub = Subject(
                  semester: 0,
                  subCode: subCode.text,
                  subName: subName.text,
                  subType: subType,
                  credit: int.parse(subcredit.text),
                  maxMarks: int.parse(maxMarks.text),
                );
                var semsub = SemSubject(
                  sub: sub,
                  mark: int.parse(totalMarks.text),
                );
                Navigator.of(context).pop(semsub);
              },
              child: const Text("Submit"),
            ),
          )
        ],
      ),
    );
  }

  Widget customTextField({
    required String hintText,
    required TextEditingController controller,
    bool isSmall = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          // width: isSmall
          //     ? MediaQuery.of(context).size.width * 0.27
          //     : MediaQuery.of(context).size.width * 0.6,
          constraints: BoxConstraints(
            maxWidth: isSmall ? 240 : 500,
            minWidth: isSmall ? 80 : 200,
          ),
          child: TextField(
            keyboardType: inputType,
            controller: controller,
            decoration: InputDecoration(
              labelText: hintText,
              // hintText: hintText,
              enabledBorder: border,
              border: border,
            ),
          ),
        ),
      ),
    );
  }
}
