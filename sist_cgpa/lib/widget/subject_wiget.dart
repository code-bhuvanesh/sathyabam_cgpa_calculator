import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sist_cgpa/models/subject.dart';

class SubjectItem extends StatefulWidget {
  const SubjectItem({
    Key? key,
    required this.subject,
    required this.tec,
    required this.onDelete,
  }) : super(key: key);

  final Subject subject;
  final TextEditingController tec;
  final void Function() onDelete;

  @override
  State<SubjectItem> createState() => _SubjectItemState();
}

class _SubjectItemState extends State<SubjectItem> {
  bool validate = false;

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
    var width = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    "${widget.subject.subCode} ${widget.subject.credit}",
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    widget.subject.subName,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 40,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      controller: widget.tec,
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
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
