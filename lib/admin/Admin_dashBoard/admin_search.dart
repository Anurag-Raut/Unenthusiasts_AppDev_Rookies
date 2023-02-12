import 'package:flutter/material.dart';

void main() => runApp(const AdminSearch());

class AdminSearch extends StatelessWidget {
  const AdminSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF222431),
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            const Text(
              "Search",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            AutocompleteBasicExample()
          ],
        ),
      ),
    );
  }
}

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({super.key});

  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width*0.8,
      // padding: const EdgeInsets.only(left: 40, right: 40),
      child: Center(
        //  pa: EdgeInsets.only(left: 20,right: 20),
        // widthFactor: MediaQuery.of(context).size.width*0.8,

          // padding: const EdgeInsets.only(left: 40, right: 40),
          child: Container(
            color: Colors.white,
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _kOptions.where((String option) {
                  return option.contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                debugPrint('You just selected $selection');
              },
            ),
          ),
        
      ),
    );
  }
}
