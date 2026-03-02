# Voxai Quest: Curriculum Generation Guide 🎓

This document tracks the generation of 200 progressive levels for each game subtype in Voxai Quest.

## Level Structure Overview
- **Total Levels**: 200 per game.
- **Items Per Level**: 3 (600 total items per game).
- **Progression Logic**:
    - Section 1: Levels 001-030 (A1 - Beginner)
    - Section 2: Levels 031-060 (A2 - Elementary)
    - Section 3: Levels 061-090 (B1 - Intermediate)
    - Section 4: Levels 091-120 (B2 - Upper Intermediate)
    - Section 5: Levels 121-150 (C1 - Advanced)
    - Section 6: Levels 151-180 (C2 - Proficiency)
    - Section 7: Levels 181-200 (Mastery/Specialized)

---

## Master Prompt Template

```markdown
Role: You are a Curriculum Engineer for Voxai Quest, a premium language learning app.
Task: Generate [COUNT] levels (3 items each) for the specific Game Subtype defined below.
Output Format: A single JSON object containing a 'quests' array.
Constraint 1: Zero External Assets. Use text and internal audio logic (STT/TTS).
Constraint 2: No Placeholders. Content must be educational and professional.
Constraint 3: Progressive Difficulty. Level [START_LEVEL] matches difficulty [CEFR_LEVEL].
Constraint 4: JSON only. No markdown formatting around the JSON string.
```

---

## Tracking Table

| Category | Game Subtype | Section 1 (1-30) | Section 2 (31-60) | Section 3 (61-90) | Section 4 (91-120) | Section 5 (121-150) | Section 6 (151-180) | Section 7 (181-200) |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Speaking** | repeatSentence | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Speaking** | situationSpeaking | ⚪ | ⚪ | ⚪ | ⚪ | ⚪ | ⚪ | ⚪ |
| **Kids Zone** | kids_alphabet | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_numbers | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_colors | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_shapes | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_animals | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_fruits | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_family | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_school | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_verbs | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_emotions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_routine | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_opposites | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_prepositions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_phonics | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_jumble | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_time | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_nature | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_home | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_food | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_transport | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Kids Zone** | kids_day_night | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

*(⏳ = In Progress, ✅ = Done, ⚪ = Pending)*

---

## 1. SPEAKING MASTERY

### 1.1 repeatSentence
**Data Schema**: `{"text": "Sentence to repeat"}`

#### [SECTION 1] Levels 1-30 (A1)
**Generation Prompt**:
```text
Role: You are a Curriculum Engineer for Voxai Quest.
Task: Generate 30 levels (3 items each, 90 total) for 'repeatSentence'.
Start Level: 1. End Level: 30.
Difficulty: A1 Beginner. Focus on hello/goodbye, numbers, colors, basic verbs, family, and home.
Sentence Length: 3 to 6 words.
Constraint: Zero External Assets. JSON output only.
```

---

## 2. KIDS ADVENTURE ZONE

### 2.1 kids_alphabet (Category: Alphabet)
**Data Schema**: `{"id": "ALPHA_001", "gameType": "choice_multi", "level": 1, "instruction": "Find A", "question": "A", "options": ["A", "B", "C", "D"], "correctAnswer": "A", "imageUrl": "3d clay...", "metadata": {"concept": "letter_id"}}`

#### [SECTION 1] Levels 1-30 (A1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 1. End Level: 30.
Aesthetic: 3D Clay Style.
Logic: Progression from Single Letters (Uppercase) to Lowercase, then Phonics sounds.
Constraint: JSON output only.

#### [SECTION 2] Levels 31-60 (A2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 31. End Level: 60.
Aesthetic: 3D Clay Style.
Logic: Focused on mid/end sounds (e.g., "Find the letter at the end of DOG"), vowel vs consonant sorting, and simple 3-letter word matching.
Constraint: JSON output only.

#### [SECTION 3] Levels 61-90 (B1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 61. End Level: 90.
Aesthetic: 3D Clay Style.
Logic: Blending sounds (st, bl, fr), Long vs Short vowels (Magic E logic like 'can' vs 'cane'), and identifying 3-4 letter word spellings.
Constraint: JSON output only.

#### [SECTION 4] Levels 91-120 (B2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 91. End Level: 120.
Aesthetic: 3D Clay Style.
Logic: Complex Digraphs (PH, CK, NG), 3-letter blends (STR, SPL, SPR), and identifying simple Compound Words (e.g., Star + Fish = Starfish).
Constraint: JSON output only.

#### [SECTION 5] Levels 121-150 (C1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 121. End Level: 150.
Aesthetic: 3D Clay Style.
Logic: Diphthongs (OI, OY, OU, OW), R-Controlled Vowels (AR, OR, ER, IR, UR), and identifying simple Vowel Teams (AI, AY, EE, EA, OA).
Constraint: JSON output only.

#### [SECTION 6] Levels 151-180 (C2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_alphabet'.
Start Level: 151. End Level: 180.
Aesthetic: 3D Clay Style.
Logic: Common Prefixes (Un-, Re-), Suffixes (-ing, -ed, -ly, -er, -est), and identifying words with 2-3 syllables. Also, base word vs modified word logic.
Constraint: JSON output only.

#### [SECTION 7] Levels 181-200 (Mastery)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 20 levels (3 items each, 60 total) for 'kids_alphabet'.
Start Level: 181. End Level: 200.
Aesthetic: 3D Clay Style.
Logic: Combined Mastery - Mixed phonics, tricky sound patterns (GH as /f/, PH, silent letters like K in KNEE), advanced spelling of 5-8 letter words, and simple synonym/antonym matching (e.g., Happy vs Glad, Big vs Small).
Constraint: JSON output only.
```
```
```
```

---

### 2.2 kids_numbers (Category: Numbers)
**Data Schema**: `{"id": "NUM_001", "gameType": "choice_multi", "level": 1, "instruction": "Find 1", "question": "1", "options": ["1", "2", "3", "0"], "correctAnswer": "1", "imageUrl": "3d clay...", "metadata": {"concept": "digit_id"}}`

#### [SECTION 1] Levels 1-30 (A1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 1. End Level: 30.
Aesthetic: 3D Clay Style.
Logic: Identification of numbers 1-10, counting objects (e.g., "How many apples?"), and matching digits to number names (e.g., "one" to "1").
Constraint: JSON output only.
```

#### [SECTION 2] Levels 31-60 (A2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 31. End Level: 60.
Aesthetic: 3D Clay Style.
Logic: Numbers 11-20, teen number logic (10 + 3), and sequencing (identifying the number "before" or "after").
Constraint: JSON output only.
```

#### [SECTION 3] Levels 61-90 (B1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 61. End Level: 90.
Aesthetic: 3D Clay Style.
Logic: Counting to 50, skip counting by 10s and 5s, and basic magnitude comparison (Which group has more?).
Constraint: JSON output only.
```

#### [SECTION 4] Levels 91-120 (B2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 91. End Level: 120.
Aesthetic: 3D Clay Style.
Logic: Numbers to 100, basic visual patterns, and introduction to simple visual addition/subtraction (e.g., 2 birds + 1 bird).
Constraint: JSON output only.
```

#### [SECTION 5] Levels 121-150 (C1)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 121. End Level: 150.
Aesthetic: 3D Clay Style.
Logic: Place value (Tens and Ones), ordinal numbers (1st, 2nd, 3rd), and comparing numbers up to 100.
Constraint: JSON output only.
```

#### [SECTION 6] Levels 151-180 (C2)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 30 levels (3 items each, 90 total) for 'kids_numbers'.
Start Level: 151. End Level: 180.
Aesthetic: 3D Clay Style.
Logic: Basic arithmetic without visuals, number words for tens (Twenty, Thirty, etc.), and missing number patterns.
Constraint: JSON output only.
```

#### [SECTION 7] Levels 181-200 (Mastery)
**Generation Prompt**:
```text
Role: You are an expert kid-learning designer.
Task: Generate 20 levels (3 items each, 60 total) for 'kids_numbers'.
Start Level: 181. End Level: 200.
Aesthetic: 3D Clay Style.
Logic: Mastery Challenge - Multi-step counting in 3D scenes, simple word problems ("If I have 2 and you have 3..."), and reviewing all count/order concepts.
Constraint: JSON output only.
```
```
```
```
