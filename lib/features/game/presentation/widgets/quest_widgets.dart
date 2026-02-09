import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';

class ReadingQuestWidget extends StatelessWidget {
  final ReadingQuest quest;
  final Function(int) onOptionSelected;

  const ReadingQuestWidget({
    super.key,
    required this.quest,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Text(
            quest.passage,
            style: TextStyle(fontSize: 16.sp, height: 1.5),
          ),
        ),
        SizedBox(height: 24.h),
        ...quest.options.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: QuestOptionButton(
              label: entry.value,
              onPressed: () => onOptionSelected(entry.key),
            ),
          );
        }),
      ],
    );
  }
}

class WritingQuestWidget extends StatelessWidget {
  final WritingQuest quest;
  final Function(String) onSubmit;

  const WritingQuestWidget({
    super.key,
    required this.quest,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      children: [
        Text(
          quest.prompt,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        ElevatedButton(
          onPressed: () => onSubmit(controller.text),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50.h),
          ),
          child: const Text('SUBMIT'),
        ),
      ],
    );
  }
}

class SpeakingQuestWidget extends StatelessWidget {
  final SpeakingQuest quest;
  final VoidCallback onStartRecording;

  const SpeakingQuestWidget({
    super.key,
    required this.quest,
    required this.onStartRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.mic_none_rounded, size: 80.r, color: Colors.blue),
        SizedBox(height: 16.h),
        Text(
          'Repeat this phrase:',
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          quest.textToSpeak,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),
        GestureDetector(
          onTap: onStartRecording,
          child: Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(Icons.mic, color: Colors.white, size: 40.r),
          ),
        ),
      ],
    );
  }
}

class GrammarQuestWidget extends StatelessWidget {
  final GrammarQuest quest;
  final Function(int) onOptionSelected;

  const GrammarQuestWidget({
    super.key,
    required this.quest,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          quest.question,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        ...quest.options.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: QuestOptionButton(
              label: entry.value,
              onPressed: () => onOptionSelected(entry.key),
            ),
          );
        }),
      ],
    );
  }
}

class QuestOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const QuestOptionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
