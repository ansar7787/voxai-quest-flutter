import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/reading/data/models/reading_quest_model.dart';
import 'package:voxai_quest/features/writing/data/models/writing_quest_model.dart';
import 'package:voxai_quest/features/speaking/data/models/speaking_quest_model.dart';
import 'package:voxai_quest/features/grammar/data/models/grammar_quest_model.dart';
import 'package:voxai_quest/features/speaking/data/models/conversation_quest_model.dart';
import 'package:voxai_quest/features/speaking/data/models/pronunciation_quest_model.dart';

class SeedingService {
  final FirebaseFirestore firestore;

  SeedingService(this.firestore);

  Future<void> seedData() async {
    final batch = firestore.batch();

    // ==========================================
    // 1. Reading Quests (Beginner -> Advanced)
    // ==========================================
    final readingData = [
      // Beginner (1-3)
      {
        'level': 1,
        'passage': 'The sun is hot. The sky is blue.',
        'q': 'What color is the sky?',
        'opts': ['Blue', 'Red', 'Green', 'Yellow'],
        'ans': 0,
      },
      {
        'level': 2,
        'passage': 'I have a red ball. I play in the park.',
        'q': 'Where do I play?',
        'opts': ['School', 'Home', 'Park', 'Shop'],
        'ans': 2,
      },
      {
        'level': 3,
        'passage': 'Sarah likes apples. She eats one every day.',
        'q': 'What does Sarah like?',
        'opts': ['Bananas', 'Apples', 'Grapes', 'Oranges'],
        'ans': 1,
      },
      // Intermediate (4-6)
      {
        'level': 4,
        'passage':
            'The astronaut flew to the moon. He walked on the surface and saw the Earth from far away.',
        'q': 'What did the astronaut see?',
        'opts': ['The Sun', 'Mars', 'The Earth', 'Aliens'],
        'ans': 2,
      },
      {
        'level': 5,
        'passage':
            'Photosynthesis is the process by which plants make their own food using sunlight.',
        'q': 'What do plants use to make food?',
        'opts': ['Wind', 'Sunlight', 'Rocks', 'Sand'],
        'ans': 1,
      },
      {
        'level': 6,
        'passage':
            'The ancient city of Rome was known for its impressive architecture, including the Colosseum.',
        'q': 'What is a famous building in Rome?',
        'opts': ['Eiffel Tower', 'Big Ben', 'Colosseum', 'Taj Mahal'],
        'ans': 2,
      },
      // Advanced (7-10)
      {
        'level': 7,
        'passage':
            'The industrial revolution marked a major turning point in history; almost every aspect of daily life was influenced in some way.',
        'q': 'What was influenced by the industrial revolution?',
        'opts': ['Only farming', 'Nothing', 'Daily life', 'The weather'],
        'ans': 2,
      },
      {
        'level': 8,
        'passage':
            'Quantum mechanics is a fundamental theory in physics that provides a description of the physical properties of nature at the scale of atoms.',
        'q': 'What does quantum mechanics describe?',
        'opts': ['Stars', 'Atoms', 'Oceans', 'Buildings'],
        'ans': 1,
      },
      {
        'level': 9,
        'passage':
            'Existentialism involves the attempt to make sense of what many have called the "meaninglessness" or "absurdity" of human existence.',
        'q': 'What concept is central to existentialism?',
        'opts': ['Logic', 'Absurdity', 'Happiness', 'Wealth'],
        'ans': 1,
      },
      {
        'level': 10,
        'passage':
            'The neurological basis of consciousness remains one of the most intriguing and unsolved mysteries of modern science.',
        'q': 'What is considered an unsolved mystery?',
        'opts': ['Gravity', 'Digestion', 'Consciousness', 'Circulation'],
        'ans': 2,
      },
    ];

    for (var i = 0; i < readingData.length; i++) {
      final data = readingData[i];
      final docRef = firestore
          .collection('reading_quests')
          .doc('reading_${data['level']}');
      batch.set(
        docRef,
        ReadingQuestModel(
          id: 'reading_${data['level']}',
          difficulty: data['level'] as int,
          instruction: 'Read the passage and answer.',
          passage: data['passage'] as String,
          options: data['opts'] as List<String>,
          correctOptionIndex: data['ans'] as int,
        ).toJson(),
      );
    }

    // ==========================================
    // 2. Writing Quests (Beginner -> Advanced)
    // ==========================================
    final writingData = [
      // Beginner
      {'level': 1, 'prompt': 'My name is...', 'ans': 'My name is John'},
      {'level': 2, 'prompt': 'I like to eat...', 'ans': 'I like to eat pizza'},
      {'level': 3, 'prompt': 'The cat is...', 'ans': 'The cat is sleeping'},
      // Intermediate
      {
        'level': 4,
        'prompt': 'Describe your favorite hobby.',
        'ans': 'I enjoy playing guitar because it relaxes me.',
      },
      {
        'level': 5,
        'prompt': 'Write a sentence about your weekend.',
        'ans': 'Last weekend I went hiking with friends.',
      },
      {
        'level': 6,
        'prompt': 'Explain why you are learning English.',
        'ans': 'I am learning English to travel the world.',
      },
      // Advanced
      {
        'level': 7,
        'prompt': 'Discuss the importance of technology.',
        'ans': 'Technology drives innovation and connects people globally.',
      },
      {
        'level': 8,
        'prompt': 'Write an opinion on climate change.',
        'ans':
            'Climate change requires immediate global action to prevent disaster.',
      },
      {
        'level': 9,
        'prompt': 'Analyze the impact of social media.',
        'ans':
            'Social media shapes public opinion but can also spread misinformation.',
      },
      {
        'level': 10,
        'prompt': 'Composed a short philosophy on life.',
        'ans': 'Life is a journey of continuous learning and adaptation.',
      },
    ];

    for (var i = 0; i < writingData.length; i++) {
      final data = writingData[i];
      final docRef = firestore
          .collection('writing_quests')
          .doc('writing_${data['level']}');
      batch.set(
        docRef,
        WritingQuestModel(
          id: 'writing_${data['level']}',
          difficulty: data['level'] as int,
          instruction: 'Complete the sentence or answer the prompt.',
          prompt: data['prompt'] as String,
          expectedAnswer: data['ans'] as String,
        ).toJson(),
      );
    }

    // ==========================================
    // 3. Speaking Quests (Beginner -> Advanced)
    // ==========================================
    final speakingData = [
      {'level': 1, 'text': 'Hello, nice to meet you!'},
      {'level': 2, 'text': 'How has your day been so far?'},
      {'level': 3, 'text': 'Good morning, I would like to order a breakfast.'},
      {
        'level': 4,
        'text': 'Could you please tell me where the nearest pharmacy is?',
      },
      {'level': 5, 'text': 'I am looking for a gift for my friend’s birthday.'},
      {
        'level': 6,
        'text': 'The project deadline is approaching, we need to hurry.',
      },
      {
        'level': 7,
        'text': 'I completely agree with the points you raised in the meeting.',
      },
      {
        'level': 8,
        'text': 'Can we reschedule our appointment for tomorrow afternoon?',
      },
      {
        'level': 9,
        'text': 'It is essential to maintain a healthy work-life balance.',
      },
      {
        'level': 10,
        'text': 'Could you please explain this concept in more detail?',
      },
      // Advanced Levels
      {
        'level': 11,
        'text':
            'Implementing sustainable practices is crucial for the environment.',
      },
      {
        'level': 12,
        'text':
            'Artificial intelligence is revolutionizing the way we live and work.',
      },
      {
        'level': 13,
        'text':
            'The economic fluctuations have a significant impact on global trade.',
      },
      {
        'level': 14,
        'text':
            'Persistence and hard work are the keys to achieving long-term goals.',
      },
      {
        'level': 15,
        'text':
            'Cultural diversity enriched our society and broadens our perspectives.',
      },
    ];

    for (var i = 0; i < speakingData.length; i++) {
      final data = speakingData[i];
      final docRef = firestore
          .collection('speaking_quests')
          .doc('speaking_${data['level']}');
      batch.set(
        docRef,
        SpeakingQuestModel(
          id: 'speaking_${data['level']}',
          difficulty: data['level'] as int,
          instruction: 'Read the text aloud.',
          textToSpeak: data['text'] as String,
        ).toJson(),
      );
    }

    // ==========================================
    // 4. Grammar Quests (Beginner -> Advanced)
    // ==========================================
    final grammarData = [
      // Beginner
      {
        'level': 1,
        'q': 'I ___ a student.',
        'opts': ['is', 'am', 'are', 'be'],
        'ans': 1,
        'exp': 'Use "am" with "I".',
      },
      {
        'level': 2,
        'q': 'She ___ happy.',
        'opts': ['is', 'am', 'are', 'be'],
        'ans': 0,
        'exp': 'Use "is" with "She".',
      },
      {
        'level': 3,
        'q': 'They ___ playing.',
        'opts': ['is', 'am', 'are', 'was'],
        'ans': 2,
        'exp': 'Use "are" with "They".',
      },
      // Intermediate
      {
        'level': 4,
        'q': 'He ___ to the store yesterday.',
        'opts': ['go', 'goes', 'went', 'gone'],
        'ans': 2,
        'exp': 'Past tense of "go" is "went".',
      },
      {
        'level': 5,
        'q': 'I have ___ that movie.',
        'opts': ['see', 'saw', 'seen', 'seeing'],
        'ans': 2,
        'exp': 'Present perfect uses participial "seen".',
      },
      {
        'level': 6,
        'q': 'If it rains, we ___ stay home.',
        'opts': ['will', 'would', 'had', 'did'],
        'ans': 0,
        'exp': 'First conditional uses "will".',
      },
      // Advanced
      {
        'level': 7,
        'q': 'I wish I ___ harder for the exam.',
        'opts': ['study', 'studied', 'had studied', 'studies'],
        'ans': 2,
        'exp': 'Past perfect used for past regrets.',
      },
      {
        'level': 8,
        'q': '___ tired, he went to bed.',
        'opts': ['Feel', 'Felt', 'Feeling', 'Feels'],
        'ans': 2,
        'exp': 'Participial phrase "Feeling tired".',
      },
      {
        'level': 9,
        'q': 'Had I known, I ___ have come.',
        'opts': ['will', 'would', 'can', 'may'],
        'ans': 1,
        'exp': 'Third conditional uses "would have".',
      },
      {
        'level': 10,
        'q': 'Not only ___ smart, but she is also kind.',
        'opts': ['she is', 'is she', 'she was', 'was she'],
        'ans': 1,
        'exp': 'Inversion after "Not only".',
      },
    ];

    for (var i = 0; i < grammarData.length; i++) {
      final data = grammarData[i];
      final docRef = firestore
          .collection('grammar_quests')
          .doc('grammar_${data['level']}');
      batch.set(
        docRef,
        GrammarQuestModel(
          id: 'grammar_${data['level']}',
          difficulty: data['level'] as int,
          question: data['q'] as String,
          options: data['opts'] as List<String>,
          correctOptionIndex: data['ans'] as int,
          explanation: data['exp'] as String,
          instruction: 'Choose the correct answer.',
        ).toJson(),
      );
    }

    // ==========================================
    // 5. Conversation Roleplay Quests
    // ==========================================
    final conversationData = [
      {
        'level': 1,
        'role': 'Waiter',
        'prompt': 'Hello! Are you ready to order?',
        'keys': ['order', 'menu', 'please', 'drink'],
      },
      {
        'level': 2,
        'role': 'Hotel Clerk',
        'prompt': 'Welcome! Do you have a reservation?',
        'keys': ['reservation', 'booking', 'check in', 'key'],
      },
      {
        'level': 3,
        'role': 'Doctor',
        'prompt': 'How can I help you today? Where does it hurt?',
        'keys': ['pain', 'stomach', 'headache', 'medicine'],
      },
    ];

    for (var data in conversationData) {
      final docRef = firestore
          .collection('conversation_quests')
          .doc('conversation_${data['level']}');
      batch.set(
        docRef,
        ConversationQuestModel(
          id: 'conversation_${data['level']}',
          difficulty: data['level'] as int,
          instruction: 'Respond to the ${data['role']} naturally.',
          roleName: data['role'] as String,
          aiPrompt: data['prompt'] as String,
          targetKeyPhrases: data['keys'] as List<String>,
        ).toJson(),
      );
    }

    // ==========================================
    // 6. Pronunciation Master Quests
    // ==========================================
    final pronunciationData = [
      {'level': 1, 'word': 'Schedule', 'phonetic': '/ˈʃɛdjuːl/'},
      {'level': 2, 'word': 'Entrepreneur', 'phonetic': '/ˌɒntrəprəˈnɜːr/'},
      {'level': 3, 'word': 'Rural', 'phonetic': '/ˈrʊərəl/'},
    ];

    for (var data in pronunciationData) {
      final docRef = firestore
          .collection('pronunciation_quests')
          .doc('pronunciation_${data['level']}');
      batch.set(
        docRef,
        PronunciationQuestModel(
          id: 'pronunciation_${data['level']}',
          difficulty: data['level'] as int,
          instruction: 'Pronounce the word correctly.',
          word: data['word'] as String,
          phonetic: data['phonetic'] as String,
        ).toJson(),
      );
    }

    await batch.commit();
  }
}
