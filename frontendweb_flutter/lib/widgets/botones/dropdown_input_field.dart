import 'package:flutter/material.dart';

class DropdownInputField extends StatefulWidget {
  final String label;
  final List<Map<String, dynamic>> items;
  final int? selectedValue;
  final void Function(int?)? onChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double width;
  final double height;

  const DropdownInputField({
    Key? key,
    required this.label,
    required this.items,
    this.selectedValue,
    this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.width = 550.0,
    this.height = 50.0,
  }) : super(key: key);

  @override
  _DropdownInputFieldState createState() => _DropdownInputFieldState();
}

class _DropdownInputFieldState extends State<DropdownInputField> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(color: widget.textColor ?? Colors.white)),
        const SizedBox(height: 5),
        Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: widget.borderColor ?? Colors.grey[600]!,
              width: 1.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedValue,
              items: widget.items.map((item) {
                return DropdownMenuItem<int>(
                  value: item['id'],
                  child: Text(
                    item['nombre'],
                    style: TextStyle(color: widget.textColor ?? Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              dropdownColor: widget.backgroundColor ?? Colors.grey[300],
            ),
          ),
        ),
      ],
    );
  }
}
