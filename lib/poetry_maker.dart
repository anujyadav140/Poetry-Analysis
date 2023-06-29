import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:poetry_maker/api/api.dart';
import 'package:poetry_maker/components/rive_display.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

class PoetryMaker extends StatefulWidget {
  const PoetryMaker({Key? key}) : super(key: key);

  @override
  State<PoetryMaker> createState() => _PoetryMakerState();
}

class _PoetryMakerState extends State<PoetryMaker> {
  quill.QuillController controller = quill.QuillController.basic();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  late StateMachineController? _riveController;
  SMIInput<bool>? isClicked;
  bool isPressed = false;
  late String url;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      int ind = controller.selection.baseOffset;
      int len = controller.selection.extentOffset - ind;
      print(ind);
      print(len);
    });
    super.initState();
  }

  Map<String, String> wordsWithSyllablesCount = {};
  void findSyllableCount(String word) async {
    var data = await getSyllableCount(url);
    var decodedData = jsonDecode(data);
    setState(() {
      var x = decodedData['count'];
      wordsWithSyllablesCount.addAll({word: x.toString()});
      print(wordsWithSyllablesCount);
    });
    // displayMetre();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(28, 28);
    double blur = isPressed ? 5.0 : 30.0;
    bool showText = true;
    if (screenWidth <= 500 || screenWidth <= 700) {
      showText = false;
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // title: AutoSizeText(
        //   "Poetry Analysis",
        //   style: GoogleFonts.farro(
        //       fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),
        // ),
        title: SizedBox(
          width: 600.0,
          child: DefaultTextStyle(
            // style: const TextStyle(
            //   fontSize: 30.0,
            //   fontFamily: 'Agne',
            // ),
            style: GoogleFonts.farro(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.w700),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText("Poetry Analysis"),
                TypewriterAnimatedText(
                    "Write poetical lines in the word editor below"),
                TypewriterAnimatedText(
                    "Click the button in the corner to analyze your work"),
                TypewriterAnimatedText("Let's be creative!"),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
            // child: Text('$screenWidth'),
          ),
        ),
        backgroundColor: Colors.white,
        // shape: const Border(
        //   bottom: BorderSide(
        //     color: Colors.black,
        //     width: 5,
        //   ),
        // ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        leading: GestureDetector(
          onTap: () {
            if (isClicked == null) return;
            final isClick = isClicked?.value ?? false;
            isClicked?.change(!isClick);
          },
          child: const Padding(
            padding: EdgeInsets.only(bottom: 18.0, left: 15.0),
            child: SizedBox(
              width: 400,
              height: 400,
              child: RiveAnimation.asset(
                'rive_homepage_icon.riv',
                fit: BoxFit.contain,
                antialiasing: false,
                // stateMachines: const ['State Machine 1'],
                // onInit: (artboard) {
                //   _riveController = StateMachineController.fromArtboard(
                //       artboard, "State Machine 1");
                //   if (_riveController == null) return;
                //   artboard.addController(_riveController!);
                //   isClicked = _riveController?.findInput<bool>("Hover/Press");
                // },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            quill.QuillToolbar.basic(
              controller: controller,
              toolbarIconSize: 15,
              showQuote: false,
              showIndent: false,
              showDividers: false,
              customButtons: [
                quill.QuillCustomButton(
                    icon: Icons.ac_unit,
                    tooltip: "Find Metre",
                    onTap: () {
                      int len = controller.document.length;
                      String plainText =
                          controller.document.getPlainText(0, len);
                      List<String> lines = plainText.split('\n');
                      List<String> trimmedLines = [];
                      for (int i = 0; i < lines.length; i++) {
                        String line = lines[i].trim();
                        if (line.isNotEmpty) {
                          trimmedLines.add(line);
                        }
                      }
                      print(trimmedLines);
                      List<List<String>> wordsList = [];

                      for (int i = 0; i < trimmedLines.length; i++) {
                        List<String> words = trimmedLines[i].split(' ');
                        wordsList.add(words);
                      }

                      print(wordsList);
                      for (int i = 0; i < wordsList.length; i++) {
                        for (int j = 0; j < wordsList[i].length; j++) {
                          var word = wordsList[i][j];
                          setState(() {
                            url = 'http://127.0.0.1:5000/sylcount?query=$word';
                            findSyllableCount(word);
                          });
                          print(wordsList[i][j]);
                        }
                      }
                      // setState(() {
                      //   url = 'http://127.0.0.1:5000/sylcount?query=';
                      //   findSyllableCount();
                      // });
                      // const BackgroundAttribute background =
                      //     BackgroundAttribute("red");
                      // const BackgroundAttribute normalBackground =
                      //     BackgroundAttribute("white");
                      // if (trimmedLines.isNotEmpty) {
                      //   for (var element in trimmedLines) {
                      //     if (element.length > 10) {
                      //       // Find the index of the line within the document
                      //       var startIndex = plainText.indexOf(element);

                      //       // Find the index of the end of the line
                      //       var endIndex = startIndex + element.length;

                      //       // Apply the red color attribute to the selected characters
                      //       controller.formatText(
                      //           startIndex, endIndex, background);
                      //       print("RED ALERT!$element");
                      //     } else if (element.length <= 10) {
                      //       // Find the index of the line within the document
                      //       var startIndex = plainText.indexOf(element);

                      //       // Find the index of the end of the line
                      //       var endIndex = startIndex + element.length;

                      //       // Apply the normal background color to the selected characters
                      //       controller.formatText(
                      //           startIndex, endIndex, normalBackground);
                      //       print("Back to normal: $element");
                      //     }
                      //   }
                      // }
                    }),
              ],
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: quill.QuillEditor(
                    controller: controller,
                    focusNode: focusNode,
                    scrollController: scrollController,
                    scrollable: true,
                    padding: const EdgeInsets.all(15.0),
                    autoFocus: true,
                    readOnly: false,
                    expands: true,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     if (isClicked == null) return;
      //     final isClick = isClicked?.value ?? false;
      //     isClicked?.change(!isClick);
      //   },
      //   // icon: const Icon(Icons.save),
      //   label: Padding(
      //     padding: const EdgeInsets.only(top: 4.0),
      //     child: Text("Analyze Poem",
      //         style: GoogleFonts.farro(
      //             fontSize: 22,
      //             color: Colors.black,
      //             fontWeight: FontWeight.w700)),
      //   ),
      //   icon: DisplayRive(
      //     rive: RiveAnimation.asset(
      //       'document_icon.riv',
      //       fit: BoxFit.cover,
      //       stateMachines: const ['State Machine 1'],
      //       onInit: (artboard) {
      //         _riveController = StateMachineController.fromArtboard(
      //             artboard, "State Machine 1");
      //         if (_riveController == null) return;
      //         artboard.addController(_riveController!);
      //         isClicked = _riveController?.findInput<bool>("Pressed/Hover");
      //       },
      //     ),
      //     riveHeight: 50,
      //     riveWidth: 50,
      //   ),
      // ),
      floatingActionButton: GestureDetector(
        onTap: () => setState(() {
          isPressed = !isPressed;
          if (isClicked == null) return;
          final isClick = isClicked?.value ?? false;
          isClicked?.change(!isClick);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("XYZ"),
                    IconButton(
                      iconSize: 50,
                      icon: const SizedBox(
                        width: 100,
                        height: 50,
                        child: RiveAnimation.asset(
                          'little_icons.riv',
                          fit: BoxFit.contain,
                          antialiasing: false,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          if (isClicked == null) return;
                          final isClick = isClicked?.value ?? false;
                          isClicked?.change(!isClick);
                          isPressed = false;
                        });
                      },
                    ),
                  ],
                ),
                content: Container(
                  width: 700,
                  height: 800,
                  child: Text("xyz"),
                ),
                contentPadding: EdgeInsets.fromLTRB(
                    24, 20, 24, 24), // Adjust the padding as needed
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey[200],
              boxShadow: [
                inset.BoxShadow(
                  blurRadius: blur,
                  offset: -distance,
                  color: Colors.white,
                  inset: isPressed,
                ),
                inset.BoxShadow(
                  blurRadius: blur,
                  offset: distance,
                  color: const Color(0xFFA7A9AF),
                  inset: isPressed,
                )
              ]),
          child: SizedBox(
            height: showText ? 80 : 60,
            width: showText ? 200 : 60,
            child: Row(
              children: [
                Padding(
                  padding: showText
                      ? const EdgeInsets.all(0.0)
                      : const EdgeInsets.only(left: 6.0),
                  child: DisplayRive(
                    rive: RiveAnimation.asset(
                      'document_icon.riv',
                      fit: BoxFit.cover,
                      stateMachines: const ['State Machine 1'],
                      onInit: (artboard) {
                        _riveController = StateMachineController.fromArtboard(
                            artboard, "State Machine 1");
                        if (_riveController == null) return;
                        artboard.addController(_riveController!);
                        isClicked =
                            _riveController?.findInput<bool>("Pressed/Hover");
                      },
                    ),
                    riveHeight: 50,
                    riveWidth: 50,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: showText
                      ? Text('Analyze Poem',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.farro(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.w700))
                      : const Text(''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
