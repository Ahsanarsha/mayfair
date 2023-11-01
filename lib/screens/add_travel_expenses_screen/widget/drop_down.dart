import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownTravel extends StatefulWidget {
  DropDownTravel(
      {this.key,
      this.hintName,
      this.fontSize,
      this.isExpanded,
      this.list,
      this.onChange})
      : super(key: key);

  var key;
  String? hintName;
  Function(dynamic?)? onChange;
  List<dynamic>? list = [];
  double? fontSize;
  bool? isExpanded = false;

  @override
  _DropDownTravelState createState() => _DropDownTravelState();
}

class _DropDownTravelState extends State<DropDownTravel> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: widget.key,
      iconSize: 30,
      iconEnabledColor: Colors.black,
      isDense: true,
      decoration: const InputDecoration(
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      hint: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintName!,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: widget.fontSize),
          ),
        ),
      ),

      // Not necessary for Option 1
      onChanged: widget.onChange,
      isExpanded: widget.isExpanded!,
      items: widget.list!.map((instance) {
        return DropdownMenuItem(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.bottomLeft,
            child: Text(
              instance.cityTo.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          value: instance,
        );
      }).toList(),
    );
  }
}

class DropDownStation extends StatefulWidget {
  DropDownStation({
    this.key,
    this.hintName,
    this.fontSize,
    this.isExpanded,
    this.list,
    this.onChange,
  }) : super(key: key);

  var key;
  String? hintName;
  Function(dynamic?)? onChange;
  List<dynamic>? list = [];
  double? fontSize;
  bool? isExpanded = false;

  @override
  _DropDownStationState createState() => _DropDownStationState();
}

class _DropDownStationState extends State<DropDownStation> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      key: widget.key,
      iconSize: 30,
      iconEnabledColor: Colors.black,
      isDense: true,
      decoration: const InputDecoration(
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      hint: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.hintName!,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: widget.fontSize),
          ),
        ),
      ),

      // Not necessary for Option 1
      onChanged: widget.onChange,
      isExpanded: widget.isExpanded!,
      items: widget.list!.map((instance) {
        return DropdownMenuItem(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.bottomLeft,
            child: Text(
              instance.name.toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          value: instance,
        );
      }).toList(),
    );
  }
}
