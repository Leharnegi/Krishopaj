import 'package:flutter/material.dart';

/// Port of components/SimpleDropDown.js
class SimpleDropdown extends StatefulWidget {
  const SimpleDropdown({super.key});

  @override
  State<SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<SimpleDropdown> {
  bool _show = false;
  String _selected = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Punjabi'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _show = !_show),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('$_selected ▼', style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
            ),
          ),
          if (_show)
            Container(
              constraints: const BoxConstraints(minWidth: 80),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFDDDDDD)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _languages.map((item) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selected = item;
                      _show = false;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(item, style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
