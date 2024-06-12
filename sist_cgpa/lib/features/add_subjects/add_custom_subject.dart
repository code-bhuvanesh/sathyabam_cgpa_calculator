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
              SizedBox(
                width: 150,
                child: DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(20),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                width: 70,
                controller: subcredit,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              customTextField(
                hintText: "max Mark",
                width: 100,
                controller: maxMarks,
              ),
              const SizedBox(
                width: 20,
              ),
              customTextField(
                hintText: "your Mark",
                width: 100,
                controller: totalMarks,
              )
            ],
          ),
          ElevatedButton(
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
          )
        ],
      ),
    );
  }

  Widget customTextField({
    required String hintText,
    required TextEditingController controller,
    double? width,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: width,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: hintText,
            // hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
