import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voxai_quest/core/utils/speech_service.dart';
import 'package:voxai_quest/core/utils/injection_container.dart';
import 'package:voxai_quest/features/speaking/domain/entities/conversation_quest.dart';

class ConversationQuestWidget extends StatefulWidget {
  final ConversationQuest quest;
  final Function(String) onSubmit;

  const ConversationQuestWidget({
    super.key,
    required this.quest,
    required this.onSubmit,
  });

  @override
  State<ConversationQuestWidget> createState() =>
      _ConversationQuestWidgetState();
}

class _ConversationQuestWidgetState extends State<ConversationQuestWidget> {
  final SpeechService _speechService = sl<SpeechService>();
  bool _isAiSpeaking = false;
  bool _isUserRecording = false;
  String _recognizedText = "";

  @override
  void initState() {
    super.initState();
    _playAiPrompt();
  }

  void _playAiPrompt() async {
    setState(() => _isAiSpeaking = true);
    await _speechService.speak(widget.quest.aiPrompt);
    if (mounted) {
      setState(() => _isAiSpeaking = false);
    }
  }

  void _toggleRecording() async {
    if (_isUserRecording) {
      await _speechService.stop();
      setState(() => _isUserRecording = false);
      return;
    }

    bool initialized = await _speechService.initializeStt();
    if (!initialized) return;

    setState(() {
      _isUserRecording = true;
      _recognizedText = "Listening...";
    });

    _speechService.listen(
      onResult: (text) {
        if (mounted) {
          setState(() => _recognizedText = text);
        }
      },
      onDone: () {
        if (mounted) {
          setState(() => _isUserRecording = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Roleplay Character Card
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.indigo,
                  size: 32.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                widget.quest.roleName,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  widget.quest.aiPrompt,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12.h),
              if (_isAiSpeaking) const LinearProgressIndicator(minHeight: 2),
            ],
          ),
        ),

        SizedBox(height: 40.h),

        // User Response Section
        if (_recognizedText.isNotEmpty)
          Text(
            _recognizedText,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.indigo[800],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

        const Spacer(),

        // Control Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: _isAiSpeaking ? null : _playAiPrompt,
              icon: const Icon(Icons.replay_rounded),
            ),
            SizedBox(width: 24.w),
            GestureDetector(
              onTap: _isAiSpeaking ? null : _toggleRecording,
              child: Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: _isUserRecording ? Colors.red : Colors.indigo,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isUserRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
            SizedBox(width: 24.w),
            IconButton.filledTonal(
              onPressed: _recognizedText.isEmpty
                  ? null
                  : () => widget.onSubmit(_recognizedText),
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          _isUserRecording ? "Listening..." : "Tap to record your response",
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _speechService.stop();
    super.dispose();
  }
}
