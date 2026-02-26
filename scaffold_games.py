import os

def to_pascal_case(snake_str):
    return "".join(x.capitalize() for x in snake_str.split("_"))

def to_camel_case(snake_str):
    components = snake_str.split("_")
    return components[0] + "".join(x.title() for x in components[1:])

categories = {
    "listening": [
        "audio_fill_blanks", "audio_multiple_choice", "audio_sentence_order", 
        "audio_true_false", "sound_image_match", "fast_speech_decoder", 
        "emotion_recognition", "detail_spotlight", "listening_inference", "ambient_id"
    ],
    "accent": [
        "minimal_pairs", "intonation_mimic", "syllable_stress", "word_linking", 
        "shadowing_challenge", "vowel_distinction", "consonant_clarity", 
        "pitch_pattern_match", "speed_variance", "dialect_drill"
    ],
    "roleplay": [
        "branching_dialogue", "situational_response", "job_interview", 
        "medical_consult", "gourmet_order", "travel_desk", "conflict_resolver", 
        "elevator_pitch", "social_spark", "emergency_hub"
    ],
    "grammar": [
        "grammar_quest", "sentence_correction", "word_reorder", "tense_mastery", 
        "parts_of_speech", "subject_verb_agreement", "clause_connector", 
        "voice_swap", "question_formatter", "article_insertion"
    ]
}

colors = {
    "listening": "Color(0xFF3B82F6)",
    "accent": "Color(0xFF8B5CF6)",
    "roleplay": "Color(0xFFEC4899)",
    "grammar": "Color(0xFF10B981)"
}

icons = {
    "listening": "Icons.headphones_rounded",
    "accent": "Icons.record_voice_over_rounded",
    "roleplay": "Icons.groups_rounded",
    "grammar": "Icons.spellcheck_rounded"
}

map_template = """import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:voxai_quest/core/presentation/widgets/games/placeholder_game_map.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class {PASCAL_NAME}Map extends StatelessWidget {{
  const {PASCAL_NAME}Map({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return PlaceholderGameMap(
      gameType: GameSubtype.{CAMEL_NAME},
      categoryId: '{CATEGORY}',
    );
  }}
}}
"""

screen_template = """import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class {PASCAL_NAME}Screen extends StatelessWidget {{
  final int level;

  const {PASCAL_NAME}Screen({{
    super.key,
    required this.level,
  }});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
        title: Text('{DISPLAY_NAME} - Level $level'),
      ),
      body: Center(
        child: Text(
          'Custom Design for {DISPLAY_NAME} Coming Soon\\nEvery game has its own logic!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 18),
        ),
      ),
    );
  }}
}}
"""

base_path = "lib/features"

for cat, games in categories.items():
    for game in games:
        pascal = to_pascal_case(game)
        camel = to_camel_case(game)
        display = game.replace("_", " ").title()
        
        target_dir = os.path.join(base_path, cat, game, "presentation", "pages")
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)
            
        map_path = os.path.join(target_dir, f"{game}_map.dart")
        screen_path = os.path.join(target_dir, f"{game}_screen.dart")
        
        # Only write if file doesn't exist
        if not os.path.exists(map_path):
            with open(map_path, "w") as f:
                f.write(map_template.format(
                    PASCAL_NAME=pascal,
                    CAMEL_NAME=camel,
                    CATEGORY=cat
                ))
        
        if not os.path.exists(screen_path):
            with open(screen_path, "w") as f:
                f.write(screen_template.format(
                    PASCAL_NAME=pascal,
                    DISPLAY_NAME=display
                ))

print("Scaffolding complete.")
