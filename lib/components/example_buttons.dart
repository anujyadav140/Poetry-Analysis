// import 'package:flutter/material.dart';
// import 'package:group_button/group_button.dart';

// class Examples extends StatelessWidget {
//   final double width;
//   // final dynamic Function(String, int, bool)? onButtonSelect;
//   late String selectedTitle;
//   late String selectedPoem;
//   final bool isSelected;
//   Examples(
//       {Key? key,
//       required this.width,
//       required this.selectedTitle,
//       required this.selectedPoem,
//       required this.isSelected})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> poems = [
//       {
//         'title': 'Dust of Snow by Robert Frost',
//         'poem': 'The way a crow\n'
//             'Shook down on me\n'
//             'The dust of snow\n'
//             'From a hemlock tree\n'
//             '\n'
//             'Has given my heart\n'
//             'A change of mood\n'
//             'And saved some part\n'
//             'Of a day I had rued.'
//       },
//       // Add more poems in a similar format
//       {
//         'title': 'My Papa’s Waltz by Theodore Roethke',
//         'poem': 'The whiskey on your breath\n'
//             'Could make a small boy dizzy;\n'
//             'But I hung on like death:\n'
//             'Such waltzing was not easy.\n'
//             '\n'
//             'We romped until the pans\n'
//             'Slid from the kitchen shelf;\n'
//             'My mother’s countenance\n'
//             'Could not unfrown itself.\n'
//             '\n'
//             'The hand that held my wrist\n'
//             'Was battered on one knuckle;\n'
//             'At every step you missed\n'
//             'My right ear scraped a buckle.\n'
//             '\n'
//             'You beat time on my head\n'
//             'With a palm caked hard by dirt,\n'
//             'Then waltzed me off to bed\n'
//             'Still clinging to your shirt.'
//       },
//       {
//         'title': 'The Only News I know by Emily Dickinson',
//         'poem': 'The Only News I know\n'
//             'Is Bulletins all Day\n'
//             'From Immortality.\n'
//             '\n'
//             'The Only Shows I see —\n'
//             'Tomorrow and Today —\n'
//             'Perchance Eternity —\n'
//             '\n'
//             'The Only One I meet\n'
//             'Is God — The Only Street —\n'
//             'Existence — This traversed\n'
//             '\n'
//             'If Other News there be —\n'
//             'Or Admirable Show —\n'
//             'I\'ll tell it You —'
//       },
//     ];

//     List<String> poemTitles = poems.map((poem) => poem['title']!).toList();

//     return SizedBox(
//       height: 50,
//       width: width,
//       child: ListView(scrollDirection: Axis.horizontal, children: [
//         GroupButton(
//           isRadio: true,
//           onSelected: (value, index, isSelected) {
//             print(value);
//             print(index);
//             print(isSelected);
//             isSelected = isSelected;
//             selectedTitle = poemTitles[index];
//             selectedPoem = poems[index]['poem']!;
//             // print('Selected Title: $selectedTitle');
//             // print('Selected Poem: $selectedPoem');
//           },
//           // onSelected: onButtonSelect,
//           buttons: poemTitles,
//         ),
//       ]),
//     );
//   }
// }
