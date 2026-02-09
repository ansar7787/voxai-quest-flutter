import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAddQuestScreen extends StatefulWidget {
  const AdminAddQuestScreen({super.key});

  @override
  State<AdminAddQuestScreen> createState() => _AdminAddQuestScreenState();
}

class _AdminAddQuestScreenState extends State<AdminAddQuestScreen> {
  String _selectedType = 'reading'; // reading, writing, speaking, grammar
  final _formKey = GlobalKey<FormState>();

  // Common controllers
  final _levelController = TextEditingController();
  final _instructionController = TextEditingController();

  // Reading specific
  final _passageController = TextEditingController();
  final _readingQuestionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  int _correctOptionIndex = 0;

  // Writing specific
  final _promptController = TextEditingController();
  final _expectedAnswerController = TextEditingController();

  // Speaking specific
  final _textToSpeakController = TextEditingController();

  // Grammar specific
  final _grammarQuestionController = TextEditingController();
  final _grammarExplanationController = TextEditingController();

  @override
  void dispose() {
    _levelController.dispose();
    _instructionController.dispose();
    _passageController.dispose();
    _readingQuestionController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _promptController.dispose();
    _expectedAnswerController.dispose();
    _textToSpeakController.dispose();
    _grammarQuestionController.dispose();
    _grammarExplanationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final firestore = FirebaseFirestore.instance;
      final level = int.parse(_levelController.text);
      final id =
          '${_selectedType}_${DateTime.now().millisecondsSinceEpoch}'; // Unique ID based on time

      try {
        if (_selectedType == 'reading') {
          await firestore.collection('reading_quests').doc(id).set({
            'id': id,
            'difficulty': level,
            'instruction': _instructionController.text,
            'passage':
                _passageController.text, // In real app, separate Q&A model
            // Simplification: using our existing model structure which puts Q in instruction or passage?
            // Existing ReadingQuestModel has passage, options. Logic implies "read and answer".
            // We'll stick to model structure.
            'options': [
              _option1Controller.text,
              _option2Controller.text,
              _option3Controller.text,
              _option4Controller.text,
            ],
            'correctOptionIndex': _correctOptionIndex,
            'type': 'reading',
          });
        } else if (_selectedType == 'writing') {
          await firestore.collection('writing_quests').doc(id).set({
            'id': id,
            'difficulty': level,
            'instruction': _instructionController.text,
            'prompt': _promptController.text,
            'expectedAnswer': _expectedAnswerController.text,
            'type': 'writing',
          });
        } else if (_selectedType == 'speaking') {
          await firestore.collection('speaking_quests').doc(id).set({
            'id': id,
            'difficulty': level,
            'instruction': _instructionController.text,
            'textToSpeak': _textToSpeakController.text,
            'type': 'speaking',
          });
        } else if (_selectedType == 'grammar') {
          await firestore.collection('grammar_quests').doc(id).set({
            'id': id,
            'difficulty': level,
            'instruction': _instructionController.text,
            'question': _grammarQuestionController.text,
            'options': [
              _option1Controller.text,
              _option2Controller.text,
              _option3Controller.text,
              _option4Controller.text,
            ],
            'correctOptionIndex': _correctOptionIndex,
            'explanation': _grammarExplanationController.text,
            'type': 'grammar',
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Quest added successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Quest')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['reading', 'writing', 'speaking', 'grammar']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
                decoration: const InputDecoration(labelText: 'Quest Type'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Level (Difficulty)',
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionController,
                decoration: const InputDecoration(labelText: 'Instruction'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTypeSpecificFields(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Quest'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSpecificFields() {
    switch (_selectedType) {
      case 'reading':
        return Column(
          children: [
            TextFormField(
              controller: _passageController,
              decoration: const InputDecoration(labelText: 'Passage'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildOptionsFields(),
          ],
        );
      case 'writing':
        return Column(
          children: [
            TextFormField(
              controller: _promptController,
              decoration: const InputDecoration(labelText: 'Prompt'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _expectedAnswerController,
              decoration: const InputDecoration(
                labelText: 'Expected Answer (for simple check)',
              ),
            ),
          ],
        );
      case 'speaking':
        return TextFormField(
          controller: _textToSpeakController,
          decoration: const InputDecoration(labelText: 'Text to Speak'),
        );
      case 'grammar':
        return Column(
          children: [
            TextFormField(
              controller: _grammarQuestionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16),
            _buildOptionsFields(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _grammarExplanationController,
              decoration: const InputDecoration(labelText: 'Explanation'),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOptionsFields() {
    return Column(
      children: [
        TextFormField(
          controller: _option1Controller,
          decoration: const InputDecoration(labelText: 'Option 1'),
        ),
        TextFormField(
          controller: _option2Controller,
          decoration: const InputDecoration(labelText: 'Option 2'),
        ),
        TextFormField(
          controller: _option3Controller,
          decoration: const InputDecoration(labelText: 'Option 3'),
        ),
        TextFormField(
          controller: _option4Controller,
          decoration: const InputDecoration(labelText: 'Option 4'),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _correctOptionIndex,
          items: List.generate(
            4,
            (index) => DropdownMenuItem(
              value: index,
              child: Text('Option ${index + 1} Correct'),
            ),
          ),
          onChanged: (val) => setState(() => _correctOptionIndex = val!),
          decoration: const InputDecoration(labelText: 'Correct Option'),
        ),
      ],
    );
  }
}
