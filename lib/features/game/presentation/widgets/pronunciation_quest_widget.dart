import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart';
import 'package:voxai_quest/features/speaking/domain/entities/pronunciation_quest.dart';

class PronunciationQuestWidget extends StatefulWidget {
  final PronunciationQuest quest;
  final Function(String) onSubmit;

  const PronunciationQuestWidget({
    super.key,
    required this.quest,
    required this.onSubmit,
  });

  @override
  State<PronunciationQuestWidget> createState() =>
      _PronunciationQuestWidgetState();
}

class _PronunciationQuestWidgetState extends State<PronunciationQuestWidget> {
  final SpeechService _speechService = sl<SpeechService>();
  bool _isListening = false;
  String _recognizedText = "";

  void _toggleRecording() async {
    if (_isListening) {
      await _speechService.stop();
      setState(() => _isListening = false);
      return;
    }

    bool initialized = await _speechService.initializeStt();
    if (!initialized) return;

    setState(() {
      _isListening = true;
      _recognizedText = "";
    });

    _speechService.listen(
      onResult: (text) {
        if (mounted) {
          setState(() => _recognizedText = text);
        }
      },
      onDone: () {
        if (mounted) {
          setState(() => _isListening = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const roseColor = Color(0xFFF43F5E);

    return Column(
      children: [
        Text(
          'PRONUNCIATION MASTER',
          style: GoogleFonts.outfit(
            color: roseColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 24.h),

        // Word Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 48.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.quest.word,
                style: GoogleFonts.outfit(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.quest.phonetic,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: roseColor,
                  fontFamily: 'Roboto', // IPA characters
                ),
              ),
              SizedBox(height: 32.h),
              IconButton.filledTonal(
                onPressed: () => _speechService.speak(widget.quest.word),
                icon: const Icon(Icons.volume_up_rounded),
                iconSize: 32.sp,
                style: IconButton.styleFrom(
                  backgroundColor: roseColor.withValues(alpha: 0.1),
                  foregroundColor: roseColor,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 48.h),

        if (_recognizedText.isNotEmpty)
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              _recognizedText,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: roseColor,
              ),
            ),
          ),

        const Spacer(),

        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: 90.r,
            height: 90.r,
            decoration: BoxDecoration(
              color: _isListening ? Colors.black : roseColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? Colors.black : roseColor).withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              _isListening ? Icons.stop : Icons.mic_rounded,
              color: Colors.white,
              size: 40.sp,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          _isListening ? "Listening..." : "Tap the mic and speak",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),

        if (_recognizedText.isNotEmpty && !_isListening) ...[
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => widget.onSubmit(_recognizedText),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 56.h),
              backgroundColor: roseColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: const Text('CHECK PRONUNCIATION'),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _speechService.stop();
    super.dispose();
  }
}
