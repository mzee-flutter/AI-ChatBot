import 'package:flutter/material.dart';
import 'package:chat_wave/response_contentUI.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ShowResponseDialog extends StatefulWidget {
  final String prompt;
  final String response;
  const ShowResponseDialog({
    super.key,
    required this.prompt,
    required this.response,
  });
  @override
  State<ShowResponseDialog> createState() => ShowResponseDialogState();
}

class ShowResponseDialogState extends State<ShowResponseDialog> {
  final FlutterTts _flutterTts = FlutterTts();
  bool isCopied = false;
  bool isLiked = false;
  bool isUnliked = false;
  bool isSpeaking = false;

  Future<void> startAndStopSpeaking(String text) async {
    if (isSpeaking) {
      await _flutterTts.stop();
    } else {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 60,
        bottom: 35,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 + 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                child: Text(
                  '${widget.prompt}?',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: ResponseContentUIState.processText(
                                widget.response),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (widget.response.isEmpty) return;
                                  startAndStopSpeaking(widget.response);
                                  setState(() {
                                    isSpeaking = !isSpeaking;
                                  });
                                },
                                child: isSpeaking
                                    ? Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                          color:
                                              isSpeaking ? Colors.white : null,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.square_rounded,
                                          size: 9,
                                          color: Colors.grey.shade900,
                                        ),
                                      )
                                    : ResponseBelowIcons(
                                        icon: Icons.volume_up_rounded,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  ResponseContentUIState.copyContent(
                                      widget.response);
                                  setState(() {
                                    isCopied = true;
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        isCopied = false;
                                      });
                                    });
                                  });
                                },
                                child: ResponseBelowIcons(
                                  icon: isCopied
                                      ? Icons.done
                                      : Icons.content_copy_rounded,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
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
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isUnliked = !isUnliked;
                                    isLiked = false;
                                  });
                                },
                                child: ResponseBelowIcons(
                                  icon: isUnliked
                                      ? Icons.thumb_down_alt_rounded
                                      : Icons.thumb_down_outlined,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ResponseBelowIcons(
                                icon: Icons.autorenew_rounded,
                              ),
                              const SizedBox(width: 10),
                              ResponseBelowIcons(
                                icon: Icons.auto_awesome,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              child: const Text(
                                'close',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
