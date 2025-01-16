import 'dart:async';
import 'package:chat_wave/model_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_wave/chatWaveDropDown.dart';
import 'package:chat_wave/app_drawer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chat_wave/intial_ui.dart';
import 'package:chat_wave/response_contentUI.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'speechToText_services.dart';

String secureApiKey = dotenv.env['API_KEY'] ?? '';

class ChatPage extends StatefulWidget {
  static const String id = 'chat_page';
  static int? listLength;

  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final SpeechToTextServices speechToTextServices = SpeechToTextServices();
  final fireStore = FirebaseFirestore.instance;
  final TextEditingController textFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //if you are not using the key property in the Scaffold then
  //we have to wrap the InkWell through Builder Widget using context
  //for calling the Drawer we write(Scaffold.of(context).openDrawer(),)

  final List<String> promptTitleList = [];
  final List<PromptResponseModelClass> promptResponseContentList = [];
  List<String> promptTitles() {
    promptTitleList
        .add(prompt ?? 'There is no prompt entered in the textField');
    return promptTitleList;
  }

  String? promptResponse;
  String? prompt;
  String? speechContent;
  bool isTextFieldEmpty = true;
  static bool isWaiting = false;

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      speechContent = result.recognizedWords;
      textFieldController.text = speechContent!;
      prompt = speechContent;
    });
  }

  XFile? image;
  ImagePicker imagePicker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await imagePicker.pickImage(source: source);
    setState(() {
      image = pickedImage;
    });
  }

  void showImageSources(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectImageSource(
              icon: Icons.camera_alt,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            SelectImageSource(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    speechToTextServices.initializeSpeech();
    textFieldController.addListener(() {
      setState(() {
        isTextFieldEmpty = textFieldController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  Future<void> generateContent() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: secureApiKey,
    );
    final geminiPrompt = prompt;

    try {
      setState(() {
        isWaiting = true;
        promptResponse = '';
      });

      promptResponseContentList.add(
        PromptResponseModelClass(prompt: prompt!, response: ''),
      );
      final responseStream =
          model.generateContentStream([Content.text(geminiPrompt!)]);

      int currentLength = promptResponseContentList.length - 1;
      await for (var chunk in responseStream) {
        List<String> words = chunk.text!.split(' ');
        for (var word in words) {
          setState(() {
            promptResponse = '${promptResponse!}$word ';
            promptResponseContentList[currentLength].response = promptResponse!;
          });
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }

      fireStore.collection('promptResponseContent').add({
        'prompt': prompt,
        'response': promptResponse,
        'timestamp': FieldValue.serverTimestamp()
      });

      setState(() {
        isWaiting = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isWaiting = false;
      });
      return;
    }
  }

  void scrollButton() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    scrollButton();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff212121),
      key: _scaffoldKey,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 115.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white70,
                    ),
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return ChatWaveDropDown();
                      },
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Prime AI',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    height: 50,
                    child: FocusScope(
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        onChanged: (value) {
                          prompt = textFieldController.text;
                        },
                        controller: textFieldController,
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                            hintText: 'Enter your prompt',
                            hintStyle: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: const Color(0xff2F2F2F),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                            ),
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showImageSources(context);
                                });
                              },
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 20,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                margin: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isWaiting
                                      ? Colors.white
                                      : isTextFieldEmpty
                                          ? Colors.grey.shade700
                                          : Colors.white,
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    ///this function is used when we tap on the upload button then the keyBoard become dismissed
                                    ///FocusScope.of(context).unfocus();
                                    if (textFieldController.text.isNotEmpty ==
                                        true) {
                                      setState(() {
                                        promptTitles();
                                      });

                                      await generateContent();
                                      textFieldController.clear();
                                    }
                                  },
                                  child: isWaiting
                                      ? const Icon(
                                          Icons.square_rounded,
                                          color: Colors.black,
                                          size: 15,
                                        )
                                      : const Icon(
                                          Icons.upload,
                                        ),
                                ),
                              ),
                            ),
                            prefixIconColor: Colors.grey,
                            suffixIconColor: const Color(0xff212121)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onLongPressStart: (value) {
                    speechToTextServices.listenSpeech(_onSpeechResult);
                  },
                  onLongPressEnd: (value) {
                    speechToTextServices.stopListening();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade800,
                    ),
                    child: const Icon(
                      Icons.keyboard_voice_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'AI Assistant can make mistake.Check important info',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        backgroundColor: const Color(0xff2F2F2F),
        automaticallyImplyLeading: false,
        title: const Text(
          'Prime AI Assistant',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      drawer: const Padding(
        padding: EdgeInsets.only(
          top: 92,
        ),
        child: AppDrawer(),
      ),
      body: promptResponse == null
          ? const IntialUI()
          : SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 50),
                child: Container(
                  child: ListView.builder(
                    ///this property is used when the ListView is scrolling then dismiss the KeyBoard
                    /// keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const ScrollPhysics(),
                    itemCount: promptResponseContentList.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      return ResponseContentUI(
                          content: promptResponseContentList[index]);
                    },
                  ),
                ),
              ),
            ),
    );
  }
}

class SelectImageSource extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;

  const SelectImageSource({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
