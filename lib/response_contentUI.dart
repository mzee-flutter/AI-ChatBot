import 'dart:async';
import 'package:chat_wave/model_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'chat_page.dart';

class ResponseContentUI extends StatefulWidget {
  final PromptResponseModelClass content;

  const ResponseContentUI({super.key, required this.content});
  @override
  State<ResponseContentUI> createState() => ResponseContentUIState();
}

class ResponseContentUIState extends State<ResponseContentUI> {
  final FlutterTts _flutterTts = FlutterTts();
  bool isSpeaking = false;
  bool isCopied = false;
  bool isUnliked = false;
  bool isLiked = false;
  String textWithoutHash = '';

  Future<void> toggleSpeak(String text) async {
    if (isSpeaking) {
      await _flutterTts.stop();
    } else {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
    }

    setState(() {
      isSpeaking = !isSpeaking;
    });
  }

  static void copyContent(String contentToBeCopy) {
    Clipboard.setData(
      ClipboardData(text: contentToBeCopy),
    );
  }

  static List<InlineSpan> processText(String inputText) {
    String textWithoutHash = inputText;
    if (textWithoutHash.startsWith('##')) {
      textWithoutHash = textWithoutHash.replaceAll('##', '').trim();
    }

    List<InlineSpan> spans = [];
    RegExp exp = RegExp(r"(```[\s\S]*?```)|(\*\*.+?\*\*)|(\*.+?\*)|([^*`]+)");
    // RegExp exp = RegExp(r"(\*\*.+?\*\*)|(\*.+?\*)|([^*]+)");
    Iterable<RegExpMatch> matches = exp.allMatches(textWithoutHash);

    for (var match in matches) {
      String matchText = match.group(0)!;

      if (matchText.startsWith("```") && matchText.endsWith("```")) {
        spans.add(
          WidgetSpan(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.grey.shade800,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        matchText.replaceAll("```", "").trim(),
                        style: const TextStyle(
                          fontFamily: 'Fir Code',
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (matchText.startsWith("**") && matchText.endsWith("**")) {
        spans.add(
          TextSpan(
            text: matchText.replaceAll("**", "").trim(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        );
      } else if (matchText.startsWith("*") && matchText.endsWith("*")) {
        spans.add(
          TextSpan(
            text: matchText.replaceAll("*", "").trim(),
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: matchText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 + 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Text(
              '${widget.content.prompt}?',
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade700,
                ),
                image: const DecorationImage(
                  image: AssetImage('images/gemini.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: processText(widget.content.response),
                      ),
                      textHeightBehavior: const TextHeightBehavior(
                        applyHeightToFirstAscent: false,
                        applyHeightToLastDescent: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ChatPageState.isWaiting
                        ? Container()
                        : Container(
                            height: 30,
                            child: Row(
                              children: [
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    toggleSpeak(widget.content.response);
                                  },
                                  child: isSpeaking
                                      ? Container(
                                          height: 19,
                                          width: 19,
                                          decoration: BoxDecoration(
                                            color: isSpeaking
                                                ? Colors.white70
                                                : null,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.square,
                                            size: 9,
                                            color: Colors.grey.shade900,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.volume_up_rounded,
                                          size: 19,
                                          color: Colors.white70,
                                        ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    copyContent(widget.content.response);
                                    setState(() {
                                      isCopied = true;
                                      Future.delayed(
                                        const Duration(seconds: 3),
                                        () {
                                          setState(() {
                                            isCopied = false;
                                          });
                                        },
                                      );
                                    });
                                  },
                                  child: ResponseBelowIcons(
                                    icon: isCopied
                                        ? Icons.check
                                        : Icons.content_copy_rounded,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                      isUnliked = false;
                                    });
                                  },
                                  child: ResponseBelowIcons(
                                    icon: isLiked
                                        ? Icons.thumb_up_alt_rounded
                                        : Icons.thumb_up_alt_outlined,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      isUnliked = !isUnliked;
                                      isLiked = false;
                                    });
                                  },
                                  child: ResponseBelowIcons(
                                    icon: isUnliked
                                        ? Icons.thumb_down_alt_rounded
                                        : Icons.thumb_down_alt_outlined,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const ResponseBelowIcons(
                                  icon: Icons.autorenew_rounded,
                                ),
                                const SizedBox(width: 10),
                                const ResponseBelowIcons(
                                  icon: Icons.auto_awesome,
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ResponseBelowIcons extends StatelessWidget {
  final IconData icon;
  const ResponseBelowIcons({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white70,
      size: 18,
    );
  }
}
