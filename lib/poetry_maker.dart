import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:poetry_maker/api/api.dart';
import 'package:poetry_maker/components/example_buttons.dart';
import 'package:poetry_maker/components/poems.dart';
import 'package:poetry_maker/components/rive_display.dart';
import 'package:rive/rive.dart';
import 'package:group_button/group_button.dart';
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
  bool isCloseButtonPressed = false;
  late String url;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isAndroid() {
    if (kIsWeb) {
      // Running on the web
      return false;
    } else {
      // Running on Android
      return true;
    }
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
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String selectedPoem = '';
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(28, 28);
    double blur = isPressed ? 5.0 : 30.0;
    Offset distances =
        isCloseButtonPressed ? const Offset(5, 5) : const Offset(14, 14);
    double blurs = isCloseButtonPressed ? 5.0 : 30.0;
    bool showText = true;
    if (screenWidth <= 500 || screenWidth <= 700) {
      showText = false;
    }
    String plainText = "";
    late var data;

    Map<String, String> formData = {};
    void findForm() async {
      url = 'http://127.0.0.1:5000/poetry-analysis';
      data = await postForm(url, jsonEncode(plainText));
      var decodeData = jsonDecode(data);
      setState(() {
        Map form = decodeData['form'];
        print(form);
        setState(() {
          form.forEach((key, value) {
            formData[key] = value;
          });
        });
      });
      print(formData);
    }

    List<String> poemTitles = poems.map((poem) => poem['title']!).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: SizedBox(
          width: 700.0,
          child: DefaultTextStyle(
            style: GoogleFonts.cardo(
                fontSize: showText ? 24 : 20,
                color: Colors.black,
                fontWeight: FontWeight.w700),
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText("Poetry Analysis"),
                TypewriterAnimatedText(
                    "Write poetical lines in the word editor below"),
                TypewriterAnimatedText(
                    "Click the button in the corner to analyze the poem"),
                TypewriterAnimatedText("Let's be creative!"),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
        backgroundColor: Colors.white,
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
                'assets/rive_homepage_icon.riv',
                fit: BoxFit.contain,
                antialiasing: false,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: screenWidth,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                GroupButton(
                  isRadio: true,
                  onSelected: (value, index, isSelected) {
                    controller.document.delete(0, controller.document.length);
                    print(value);
                    print(index);
                    print(isSelected);
                    setState(() {
                      selectedPoem = poems[index]['poem']!;
                      controller.document.insert(0, selectedPoem);
                    });
                    // print('Selected Title: $selectedTitle');
                    // print('Selected Poem: $selectedPoem');
                  },
                  // onSelected: onButtonSelect,
                  buttons: poemTitles,
                ),
              ]),
            ),
            quill.QuillToolbar.basic(
              controller: controller,
              toolbarIconSize: 15,
              showQuote: false,
              showIndent: false,
              showDividers: false,
              showSubscript: false,
              showSuperscript: false,
              showListBullets: false,
              showListNumbers: false,
              showHeaderStyle: false,
              showListCheck: false,
              showInlineCode: false,
              showSearchButton: false,
              showLink: false,
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
      floatingActionButton: GestureDetector(
        onTap: () => setState(() {
          isPressed = !isPressed;
          if (isClicked == null) return;
          final isClick = isClicked?.value ?? false;
          isClicked?.change(!isClick);
          int len = controller.document.length;
          plainText = controller.document.getPlainText(0, len - 1);
          if (plainText.isEmpty) {
            print("fill something up!");
          } else {
            findForm();
          }
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Poetry Analysis',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cardo(
                            fontSize: isAndroid() ? 21 : 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    Listener(
                      onPointerUp: (_) => setState(() {
                        isCloseButtonPressed = false;
                      }),
                      onPointerDown: (_) => setState(() {
                        isCloseButtonPressed = true;
                        setState(() {
                          Navigator.pop(context);
                          if (isClicked == null) return;
                          final isClick = isClicked?.value ?? false;
                          isClicked?.change(!isClick);
                          isPressed = false;
                        });
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        decoration: inset.BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.grey[200],
                            boxShadow: [
                              inset.BoxShadow(
                                blurRadius: blurs,
                                offset: -distances,
                                color: Colors.white,
                                inset: isCloseButtonPressed,
                              ),
                              inset.BoxShadow(
                                blurRadius: blurs,
                                offset: distances,
                                color: const Color(0xFFA7A9AF),
                                inset: isCloseButtonPressed,
                              )
                            ]),
                        child: SizedBox(
                          height: showText
                              ? 60
                              : isAndroid()
                                  ? 50
                                  : 60,
                          width: showText
                              ? 140
                              : isAndroid()
                                  ? 50
                                  : 60,
                          child: Row(
                            children: [
                              Padding(
                                padding: showText
                                    ? const EdgeInsets.all(0.0)
                                    : const EdgeInsets.only(left: 6.0),
                                child: DisplayRive(
                                  rive: const RiveAnimation.asset(
                                    'assets/little_icons.riv',
                                    fit: BoxFit.cover,
                                    antialiasing: false,
                                  ),
                                  riveHeight: isAndroid() ? 40 : 50,
                                  riveWidth: isAndroid() ? 40 : 50,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: showText
                                      ? Text('Close',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cardo(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700))
                                      : const Text('')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: isAndroid() ? 300 : 700,
                  height: isAndroid() ? 400 : 800,
                  child: Column(
                    children: [
                      const Divider(),
                      DisplayRive(
                        rive: const RiveAnimation.asset(
                          'assets/note_book_demo.riv',
                          fit: BoxFit.cover,
                          antialiasing: false,
                        ),
                        riveHeight: isAndroid() ? 130 : 200,
                        riveWidth: 300,
                      ),
                      FutureBuilder(
                        future: plainText.isNotEmpty
                            ? postForm(url, plainText)
                            : null,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return formData.isNotEmpty
                                ? Column(
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Closest metre: ",
                                                style: GoogleFonts.cardo(
                                                  fontSize:
                                                      isAndroid() ? 18 : 22,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:
                                                    "${formData["Closest metre"]}",
                                                style: GoogleFonts.cardo(
                                                    fontSize:
                                                        isAndroid() ? 18 : 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Closest rhyme: ",
                                                style: GoogleFonts.cardo(
                                                  fontSize:
                                                      isAndroid() ? 18 : 22,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:
                                                    "${formData["Closest rhyme"]}",
                                                style: GoogleFonts.cardo(
                                                    fontSize:
                                                        isAndroid() ? 18 : 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                      RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 12,
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "Closest rhyme scheme: ",
                                                    style: GoogleFonts.cardo(
                                                      fontSize:
                                                          isAndroid() ? 18 : 22,
                                                      color: Colors.black,
                                                    )),
                                                TextSpan(
                                                    text:
                                                        "${formData["Rhyme scheme"]}",
                                                    style: GoogleFonts.cardo(
                                                        fontSize: isAndroid()
                                                            ? 18
                                                            : 22,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Closest stanza type: ",
                                                style: GoogleFonts.cardo(
                                                  fontSize:
                                                      isAndroid() ? 18 : 22,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:
                                                    "${formData["Closest stanza type"]}",
                                                style: GoogleFonts.cardo(
                                                    fontSize:
                                                        isAndroid() ? 18 : 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Guessed form: ",
                                                style: GoogleFonts.cardo(
                                                  fontSize:
                                                      isAndroid() ? 18 : 22,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:
                                                    "${formData["Guessed form"]}",
                                                style: GoogleFonts.cardo(
                                                    fontSize:
                                                        isAndroid() ? 18 : 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: isAndroid() ? 18 : 22,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: "Closest stanza length: ",
                                                style: GoogleFonts.cardo(
                                                  fontSize:
                                                      isAndroid() ? 18 : 22,
                                                  color: Colors.black,
                                                )),
                                            TextSpan(
                                                text:
                                                    "${formData["Stanza lengths"]}",
                                                style: GoogleFonts.cardo(
                                                    fontSize:
                                                        isAndroid() ? 18 : 22,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ])),
                                    ],
                                  )
                                : const Text("Form is empty ...");
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
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
                      'assets/document_icon.riv',
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
                          style: GoogleFonts.cardo(
                              fontSize: 18,
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
