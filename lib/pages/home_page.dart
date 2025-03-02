import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "SpeechDemo",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _speechToText.isListening
                      ? "listening..."
                      : _speechEnabled
                          ? "Tap the microphone to start listening..."
                          : "Speech not available",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
              )),
              if (_speechToText.isNotListening && _confidenceLevel > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(
                    "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
                  ),
                )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              _speechToText.isListening ? _stopListening : _startListening,
          tooltip: "Listen",
          child: Icon(
            _speechToText.isListening ? Icons.mic_off : Icons.mic,
            color: Colors.white,
          ),
        ));
  }
}
