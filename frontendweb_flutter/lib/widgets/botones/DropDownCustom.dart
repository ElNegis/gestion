import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String hintText;
  final ValueChanged<int?>? onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 550,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedId,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem<int>(
              value: item['id'], // Envía el ID como valor
              child: Text(
                item['nombre'], // Muestra el nombre en el menú
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedId = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          dropdownColor: Colors.black,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.hintText,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          selectedItemBuilder: (context) {
            return widget.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  item['nombre'],
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
