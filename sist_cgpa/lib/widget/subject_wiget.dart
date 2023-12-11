import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubjectItem extends StatefulWidget {
  SubjectItem({
    Key? key,
    required this.subCode,
    required this.tec,
    required this.subName,
    required this.subMaxMarks,
    required this.checkToCalculate,
  }) : super(key: key);

  final String subCode;
  final String subName;
  final String subMaxMarks;
  final void Function() checkToCalculate;
  final TextEditingController tec;

  @override
  State<SubjectItem> createState() => _SubjectItemState();
}

class _SubjectItemState extends State<SubjectItem> {
  bool validate = false;

  void validateField(String? txt) {
    print("validating");
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

    if (!validate) {
      widget.checkToCalculate();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: width * 0.7),
            child: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              widget.subName,
            ),
          ),
          SizedBox(
            width: 60,
            height: 40,
            child: TextField(
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
                hintText: widget.subMaxMarks,
                errorText: validate ? null : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
