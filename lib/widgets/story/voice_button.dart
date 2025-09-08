import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/constants/app_colors.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_fonts.dart';
import 'package:storifuel/core/utils/toast.dart';
import 'package:storifuel/view_model/story/story_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    try {
      _isInitialized = await _speech.initialize(
        onStatus: (status) {
          print('Speech status: $status');
          if (mounted && (status == 'done' || status == 'notListening')) {
            final provider = context.read<StoryProvider>();
            provider.setListening(false);
          }
        },
        onError: (error) {
          print('Speech error: $error');
          if (mounted) {
            final provider = context.read<StoryProvider>();
            provider.setListening(false);
            showErrorToast(context, 'Speech recognition error: ${error.errorMsg}');
          }
        },
        debugLogging: true,
      );
      
      print('Speech initialized: $_isInitialized');
      
      if (!_isInitialized && mounted) {
        showErrorToast(context, 'Speech recognition not available. Please check microphone permissions.');
      }
    } catch (e) {
      print('Failed to initialize speech: $e');
      _isInitialized = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StoryProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => _toggleListening(provider),
          child: SizedBox(
            height: 48,
            child: Container(
              decoration: BoxDecoration(
                color: provider.isListening ? secondaryColor : primaryColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: secondaryColor, width: 1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.isListening ? 'Listening...' : 'Voice to text', 
                    style: outfit16w500.copyWith(
                      color: provider.isListening ? Colors.white : secondaryColor
                    )
                  ),
                  const SizedBox(width: 8),
                  provider.isListening 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Image.asset(AppImages.voiceIcon, width: 20, height: 20),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void _toggleListening(StoryProvider provider) async {
    print('Toggle listening called. Initialized: $_isInitialized, isListening: ${provider.isListening}');
    
    if (!_isInitialized) {
      // Try to initialize again
      await _initializeSpeech();
      if (!_isInitialized) {
        showErrorToast(context, 'Speech recognition is not available');
        return;
      }
    }

    if (!provider.isListening) {
      // Check if speech is available before starting
      bool available = await _speech.isAvailable;
      print('Speech available: $available');
      
      if (!available) {
        showErrorToast(context, 'Microphone not available. Please check permissions.');
        return;
      }
      
      provider.setListening(true);
      
      try {
        await _speech.listen(
          onResult: (result) {
            print('Result: ${result.recognizedWords}, Final: ${result.finalResult}');
            if (result.recognizedWords.isNotEmpty) {
              // Append to existing text instead of replacing
              String currentText = provider.storyController.text;
              if (result.finalResult && currentText.isNotEmpty) {
                provider.storyController.text = '$currentText ${result.recognizedWords}';
              } else if (result.finalResult || currentText.isEmpty) {
                provider.storyController.text = result.recognizedWords;
              }
              
              // If this is the final result, stop listening
              if (result.finalResult) {
                provider.setListening(false);
              }
            }
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          localeId: 'en_US', // Specify locale
        );
        print('Started listening successfully');
      } catch (e) {
        print('Error starting speech recognition: $e');
        provider.setListening(false);
        showErrorToast(context, 'Failed to start listening: $e');
      }
    } else {
      print('Stopping speech recognition');
      await _speech.stop();
      provider.setListening(false);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }
}





