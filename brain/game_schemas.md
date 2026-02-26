# Voxai Quest: 80-Game Master Generation Blueprints (V5)

This document contains **80 hyper-detailed prompts**. Copy any prompt into ChatGPT (GPT-4o or o1 recommended) to generate 30 levels (90 items) of Firestore-ready JSON data.

---

## 🏗️ The Global Generation Base (Always Include This)
"Role: You are a Curriculum Engineer for Voxai Quest, a premium language learning app.
Task: Generate 30 levels (3 items each, 90 total) for the specific Game Subtype defined below.
Output Format: A single JSON object containing a 'quests' array.
Constraint 1: Zero External Assets. Use text and internal audio logic (STT/TTS).
Constraint 2: No Placeholders. Content must be educational and professional.
Constraint 3: Progressive Difficulty. Level 1 is A1 (Beginner), Level 30 is C2 (Advanced)."

---

## 1. SPEAKING (Interaction Type: `speech`)

### 1.1 repeatSentence
**Instruction**: "Repeat the sentence exactly as you hear it."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: repeatSentence
InteractionType: speech
Focus: Fluency & Pronunciation.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Listen and repeat the sentence clearly.",
  "difficulty": 1,
  "subtype": "repeatSentence",
  "interactionType": "speech",
  "textToSpeak": "The quick brown fox jumps over the lazy dog.",
  "hint": "Focus on the 'th' and 'v' sounds.",
  "xpReward": 10,
  "coinReward": 10
}
Difficulty Curve: Level 1-10 (4-7 words), Level 11-20 (8-12 words), Level 21-30 (15+ words with complex clauses).
```

### 1.2 speakMissingWord
**Instruction**: "Speak the missing word to complete the sentence."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: speakMissingWord
InteractionType: speech
Focus: Spontaneous Recall.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Speak the word that completes the sentence.",
  "difficulty": 1,
  "subtype": "speakMissingWord",
  "interactionType": "speech",
  "textToSpeak": "The sun rises in the ___.",
  "missingWord": "east",
  "hint": "Think about directions.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.3 situationSpeaking
**Instruction**: "Respond to the situation described."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: situationSpeaking
InteractionType: speech
Focus: Functional Language.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "How would you respond in this situation?",
  "difficulty": 5,
  "subtype": "situationSpeaking",
  "interactionType": "speech",
  "situationText": "You are at a cafe and want to order a latte.",
  "sampleAnswer": "I would like a latte, please.",
  "hint": "Use 'I would like' or 'Can I have'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.4 sceneDescriptionSpeaking
**Instruction**: "Describe the scene using the provided keywords."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: sceneDescriptionSpeaking
InteractionType: speech
Focus: Descriptive Fluency.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Describe the scene in detail.",
  "difficulty": 10,
  "subtype": "sceneDescriptionSpeaking",
  "interactionType": "speech",
  "sceneText": "A busy park on a Saturday afternoon with families and a dog.",
  "keywords": ["sunlight", "crowded", "joyful"],
  "hint": "Try to use all three keywords.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.5 yesNoSpeaking
**Instruction**: "Answer with 'Yes' or 'No' and a short reason."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: yesNoSpeaking
InteractionType: speech
Focus: Quick Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Answer with Yes/No and explain.",
  "difficulty": 1,
  "subtype": "yesNoSpeaking",
  "interactionType": "speech",
  "question": "Can cats fly?",
  "correctAnswer": "No, cats do not have wings.",
  "hint": "Think about biology.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.6 speakSynonym
**Instruction**: "Say a synonym for the given word."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: speakSynonym
InteractionType: speech
Focus: Vocabulary Range.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Say a synonym for the highlighted word.",
  "difficulty": 8,
  "subtype": "speakSynonym",
  "interactionType": "speech",
  "word": "Enormous",
  "acceptedSynonyms": ["huge", "giant", "vast", "massive"],
  "hint": "Think of something very big.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.7 dialogueRoleplay
**Instruction**: "Complete your part in the dialogue."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: dialogueRoleplay
InteractionType: speech
Focus: Flow.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Respond to the speaker naturally.",
  "difficulty": 15,
  "subtype": "dialogueRoleplay",
  "interactionType": "speech",
  "lastLine": "I really enjoyed the movie, didn't you?",
  "sampleAnswer": "Yes, the acting was incredible!",
  "hint": "Express your opinion.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.8 pronunciationFocus
**Instruction**: "Pronounce the target word clearly."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: pronunciationFocus
InteractionType: speech
Focus: Phonetic Accuracy.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Focus on the syllable stress and speak.",
  "difficulty": 12,
  "subtype": "pronunciationFocus",
  "interactionType": "speech",
  "word": "Phenomenon",
  "phoneticHint": "fuh-NOM-uh-non",
  "hint": "Stress the second syllable.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.9 speakOpposite
**Instruction**: "Say the opposite of the given word."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: speakOpposite
InteractionType: speech
Focus: Semantic Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Speak the antonym for this word.",
  "difficulty": 4,
  "subtype": "speakOpposite",
  "interactionType": "speech",
  "word": "Strict",
  "correctAnswer": "Lenient",
  "hint": "The opposite of rigid rules.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 1.10 dailyExpression
**Instruction**: "Use the idiom/expression in a sentence."
**Interaction**: `speech`
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: dailyExpression
InteractionType: speech
Focus: Naturalness.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Use this expression in a sentence.",
  "difficulty": 20,
  "subtype": "dailyExpression",
  "interactionType": "speech",
  "expression": "Beat around the bush",
  "meaning": "To avoid the main topic.",
  "sampleAnswer": "Don't beat around the bush, just tell me the truth.",
  "hint": "It means avoiding the point.",
  "xpReward": 10,
  "coinReward": 10
}
```

## 2. LISTENING (Interaction Type: choice / writing)

### 2.1 audioFillBlanks
**Instruction**: "Listen to the audio and type the missing word."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: audioFillBlanks
InteractionType: writing
Focus: Precise Listening.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Type the missing word from the audio.",
  "difficulty": 1,
  "subtype": "audioFillBlanks",
  "interactionType": "writing",
  "textToSpeak": "She sells seashells by the ___.",
  "missingWord": "seashore",
  "hint": "It's near the ocean.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.2 audioMultipleChoice
**Instruction**: "Listen and pick the correct meaning."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: audioMultipleChoice
InteractionType: choice
Focus: Contextual Understanding.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What is the speaker's main point?",
  "difficulty": 5,
  "subtype": "audioMultipleChoice",
  "interactionType": "choice",
  "textToSpeak": "I'm heading to the grocery store to get some milk and bread.",
  "options": ["Buying groceries", "Going to work", "Visiting a friend", "Baking bread"],
  "correctAnswerIndex": 0,
  "hint": "Listen for specific items.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.3 audioSentenceOrder
**Instruction**: "Reorder the words to match the audio."
**Interaction**: sequence
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: audioSentenceOrder
InteractionType: sequence
Focus: Syntactic Awareness.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Arrange the words in the order you heard them.",
  "difficulty": 8,
  "subtype": "audioSentenceOrder",
  "interactionType": "sequence",
  "textToSpeak": "The weather is beautiful today.",
  "shuffledSentences": ["beautiful", "weather", "The", "today.", "is"],
  "correctOrder": [2, 1, 4, 0, 3],
  "hint": "Start with the subject.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.4 audioTrueFalse
**Instruction**: "Is the statement about the audio True or False?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: audioTrueFalse
InteractionType: choice
Focus: Fact Checking.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Is the follow-up statement True or False?",
  "difficulty": 3,
  "subtype": "audioTrueFalse",
  "interactionType": "choice",
  "textToSpeak": "I usually drink coffee in the morning, but today I have tea.",
  "question": "The speaker is drinking coffee today.",
  "options": ["True", "False"],
  "correctAnswerIndex": 1,
  "hint": "Listen for the word 'but'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.5 audioWordMatch
**Instruction**: "Identify the word spoken from the options."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: audioWordMatch
InteractionType: choice
Focus: Phonetic Discrimination.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the exact word you hear.",
  "difficulty": 2,
  "subtype": "audioWordMatch",
  "interactionType": "choice",
  "textToSpeak": "Specific",
  "options": ["Specific", "Pacific", "Scientific", "Terrific"],
  "correctAnswerIndex": 0,
  "hint": "Listen for the 'Sp' sound.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.6 fastSpeechDecoder
**Instruction**: "Transcribe the rapid speech."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: fastSpeechDecoder
InteractionType: writing
Focus: Connected Speech.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Type what the speaker says (Rapid Speech).",
  "difficulty": 18,
  "subtype": "fastSpeechDecoder",
  "interactionType": "writing",
  "textToSpeak": "Whatcha gonna do about it?",
  "correctAnswer": "What are you going to do about it?",
  "hint": "It's a question about future plans.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.7 emotionRecognition
**Instruction**: "Identify the speaker's emotion."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: emotionRecognition
InteractionType: choice
Focus: Tone & Intonation.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "How does the speaker feel?",
  "difficulty": 12,
  "subtype": "emotionRecognition",
  "interactionType": "choice",
  "textToSpeak": "I can't believe this is finally happening!",
  "options": ["Frustrated", "Excited", "Bored", "Angry"],
  "correctAnswerIndex": 1,
  "hint": "Listen to the rising energy.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.8 detailSpotlight
**Instruction**: "Listen for a specific detail."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: detailSpotlight
InteractionType: choice
Focus: Selective Listening.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What time does the train leave?",
  "difficulty": 7,
  "subtype": "detailSpotlight",
  "interactionType": "choice",
  "textToSpeak": "The express train to London will depart from platform 4 at 10:15 AM.",
  "options": ["10:00 AM", "10:15 AM", "10:45 AM", "11:15 AM"],
  "correctAnswerIndex": 1,
  "hint": "Focus on the numbers.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.9 listeningInference
**Instruction**: "Predict what happens next."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: listeningInference
InteractionType: choice
Focus: Predictive Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What will likely happen next?",
  "difficulty": 22,
  "subtype": "listeningInference",
  "interactionType": "choice",
  "textToSpeak": "The dark clouds rolled in and the wind began to howl. Sarah reached for her umbrella.",
  "options": ["It will rain.", "The sun will come out.", "Sarah will go swimming.", "It's bedtime."],
  "correctAnswerIndex": 0,
  "hint": "Think about the weather clues.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 2.10 ambientId
**Instruction**: "Identify the location based on sounds described."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: ambientId
InteractionType: choice
Focus: Logic & Vocabulary.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Where is this taking place?",
  "difficulty": 4,
  "subtype": "ambientId",
  "interactionType": "choice",
  "textToSpeak": "[Ambient: Sound of waves crashing and seagulls crying]",
  "options": ["Airport", "Forest", "Beach", "Library"],
  "correctAnswerIndex": 2,
  "hint": "Think of water and birds.",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 3. READING (Interaction Type: choice / sequence)

### 3.1 readAndAnswer
**Instruction**: "Read the passage and answer the question."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: readAndAnswer
InteractionType: choice
Focus: Comprehension.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Read the text and choose the correct answer.",
  "difficulty": 1,
  "passage": "John went to the store to buy apples.",
  "question": "What did John buy?",
  "options": ["Apples", "Oranges", "Bananas", "Milk"],
  "correctAnswerIndex": 0,
  "hint": "The answer is in the first sentence.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.2 findWordMeaning
**Instruction**: "What is the meaning of the highlighted word in context?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: findWordMeaning
InteractionType: choice
Focus: Contextual Vocabulary.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the best definition for the word.",
  "difficulty": 5,
  "passage": "The traveler was weary after the long journey.",
  "word": "weary",
  "options": ["Tired", "Excited", "Happy", "Angry"],
  "correctAnswerIndex": 0,
  "hint": "Think about how someone feels after a long walk.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.3 trueFalseReading
**Instruction**: "State if the following is True or False based on the text."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: trueFalseReading
InteractionType: choice
Focus: Detail Verification.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "True or False?",
  "difficulty": 2,
  "passage": "London is the capital of the United Kingdom.",
  "question": "Paris is the capital of the UK.",
  "options": ["True", "False"],
  "correctAnswerIndex": 1,
  "hint": "Check the city names.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.4 sentenceOrderReading
**Instruction**: "Reorder the sentences to form a logical paragraph."
**Interaction**: sequence
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: sentenceOrderReading
InteractionType: sequence
Focus: Logical Flow.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Arrange the sentences in order.",
  "difficulty": 10,
  "shuffledSentences": ["He ate dinner.", "Then he went to bed.", "John came home at 6 PM."],
  "correctOrder": [2, 0, 1],
  "hint": "Look for time indicators.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.5 readingSpeedCheck
**Instruction**: "Quickly read the text and identify the main topic."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: readingSpeedCheck
InteractionType: choice
Focus: Skimming/Scanning.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What is the main topic?",
  "difficulty": 15,
  "passage": "Global warming is causing glaciers to melt at an unprecedented rate...",
  "options": ["Environmental issues", "Sports", "Cooking", "Space travel"],
  "correctAnswerIndex": 0,
  "hint": "Focus on the first few words.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.6 guessTitle
**Instruction**: "Select the best title for this passage."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: guessTitle
InteractionType: choice
Focus: Central Idea.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Choose the best title.",
  "difficulty": 8,
  "passage": "A small dog rescued a child from a burning building today in New York...",
  "options": ["Heroic Pet", "Cooking Tips", "Weather Report", "Stock Market"],
  "correctAnswerIndex": 0,
  "hint": "What is the story about?",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.7 readAndMatch
**Instruction**: "Match the headings to the correct paragraphs."
**Interaction**: match
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: readAndMatch
InteractionType: match
Focus: Structural Analysis.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Match the headings to the paragraphs.",
  "difficulty": 12,
  "pairs": [
    {"a": "History", "b": "It was founded in 1890..."},
    {"a": "Geography", "b": "The mountains are to the north..."}
  ],
  "hint": "Look for keywords like 'founded' or 'mountains'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.8 paragraphSummary
**Instruction**: "Identify the best one-sentence summary."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: paragraphSummary
InteractionType: choice
Focus: Synthesis.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Pick the best summary.",
  "difficulty": 20,
  "passage": "...detailed technical explanation of how solar panels work...",
  "options": ["Solar energy mechanics", "Rainy day activities", "Tax laws", "Ancient art"],
  "correctAnswerIndex": 0,
  "hint": "The passage explains a process.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.9 readingInference
**Instruction**: "What can be inferred from the speaker's tone?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: readingInference
InteractionType: choice
Focus: Implied Meaning.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What is implied?",
  "difficulty": 25,
  "passage": "Despite the 'safety' features, many were still wary of entering the cave.",
  "question": "The people feel...",
  "options": ["Unsafe", "Confident", "Excited", "Bored"],
  "correctAnswerIndex": 0,
  "hint": "Look at the word 'Despite'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 3.10 readingConclusion
**Instruction**: "Which of these is a logical conclusion?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: readingConclusion
InteractionType: choice
Focus: Critical Thinking.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the logical conclusion.",
  "difficulty": 30,
  "passage": "The team practiced 10 hours a day for months. They had the best coach.",
  "options": ["They were well prepared.", "They were lazy.", "They never played.", "They lost interest."],
  "correctAnswerIndex": 0,
  "hint": "Does hard work usually lead to being prepared?",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 4. WRITING (Interaction Type: textInput)

### 4.1 sentenceBuilder
**Instruction**: "Assemble the words into a perfect sentence."
**Interaction**: sequence
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: sentenceBuilder
InteractionType: sequence
Focus: Grammatical Structure.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Build a correct sentence.",
  "difficulty": 3,
  "shuffledWords": ["is", "apple", "The", "red."],
  "correctOrder": [2, 1, 0, 3],
  "hint": "Start with 'The'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.2 completeSentence
**Instruction**: "Type the missing word to complete the thought."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: completeSentence
InteractionType: writing
Focus: Contextual Completion.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Type the missing word.",
  "difficulty": 4,
  "passage": "When it rains, you should take an ___.",
  "missingWord": "umbrella",
  "hint": "It keeps you dry.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.3 describeSituationWriting
**Instruction**: "Describe the scenario in one sentence."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: describeSituationWriting
InteractionType: writing
Focus: Descriptive Precision.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Describe what is happening.",
  "difficulty": 10,
  "situation": "A man is waiting for a bus in the rain.",
  "sampleAnswer": "A man stands at a bus stop under a gray sky.",
  "hint": "Include the weather.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.4 fixTheSentence
**Instruction**: "Rewrite the sentence with the correct grammar/spelling."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: fixTheSentence
InteractionType: writing
Focus: Error Correction.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Correct the mistake.",
  "difficulty": 12,
  "wrongSentence": "He go to school yesterday.",
  "correctSentence": "He went to school yesterday.",
  "hint": "Check the past tense.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.5 shortAnswerWriting
**Instruction**: "Write a short answer to the prompt."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: shortAnswerWriting
InteractionType: writing
Focus: Brief Expression.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Answer the question.",
  "difficulty": 15,
  "question": "Why is education important?",
  "sampleAnswer": "It opens up new opportunities and builds knowledge.",
  "hint": "Think about future jobs.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.6 opinionWriting
**Instruction**: "Express your opinion on this topic."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: opinionWriting
InteractionType: writing
Focus: Argumentation.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What is your opinion?",
  "difficulty": 22,
  "topic": "Should schools start later in the morning?",
  "sampleAnswer": "I believe they should, as students need more sleep.",
  "hint": "Use 'I believe' or 'In my opinion'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.7 dailyJournal
**Instruction**: "Write a journal entry for the described day."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: dailyJournal
InteractionType: writing
Focus: Reflective Writing.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Write a journal entry.",
  "difficulty": 18,
  "dayDescription": "A day where you met an old friend by surprise.",
  "sampleAnswer": "Today I ran into Sarah at the park! It's been years...",
  "hint": "Describe how you felt.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.8 summarizeStoryWriting
**Instruction**: "Summarize the short story in 20 words."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: summarizeStoryWriting
InteractionType: writing
Focus: Conciseness.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Summarize the story.",
  "difficulty": 25,
  "story": "Long story about a cat that traveled across the country...",
  "sampleAnswer": "A cat makes an incredible journey across the country to find home.",
  "hint": "Focus on the main action.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.9 correctionWriting
**Instruction**: "Identify and fix all 3 errors in this text."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: correctionWriting
InteractionType: writing
Focus: Proofreading.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Find and fix the 3 errors.",
  "difficulty": 28,
  "wrongText": "I enjoys fish. They lives in water",
  "correctText": "I enjoy fish. They live in water.",
  "hint": "Check subject-verb agreement.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 4.10 writingEmail
**Instruction**: "Write a formal email based on the context."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: writingEmail
InteractionType: writing
Focus: Professional Communication.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Write a short formal email.",
  "difficulty": 30,
  "context": "Requesting a meeting with your boss next Tuesday.",
  "sampleAnswer": "Dear Sir, I would like to request a meeting...",
  "hint": "Start with a professional greeting.",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 5. GRAMMAR (Interaction Type: choice / writing)

### 5.1 grammarQuest
**Instruction**: "Select the grammatically correct option."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: grammarQuest
InteractionType: choice
Focus: General Syntax.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Which sentence is correct?",
  "difficulty": 1,
  "question": "Choose the correct sentence.",
  "options": ["He don't like milk.", "He doesn't like milk.", "He not like milk.", "He doesn't likes milk."],
  "correctAnswerIndex": 1,
  "hint": "Check the third person singular agreement.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.2 sentenceTransformation
**Instruction**: "Rewrite the sentence as instructed."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: sentenceTransformation
InteractionType: writing
Focus: Structural Flexibility.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Rewrite the sentence in the negative form.",
  "difficulty": 5,
  "originalSentence": "They are playing football.",
  "correctAnswer": "They are not playing football.",
  "hint": "Add 'not' after the auxiliary verb.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.3 tenseCorrection
**Instruction**: "Type the correct tense of the verb in parentheses."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: tenseCorrection
InteractionType: writing
Focus: Verb Conjugation.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Fill in the correct verb form.",
  "difficulty": 8,
  "passage": "I (go) to the cinema yesterday.",
  "missingWord": "went",
  "hint": "It happened in the past.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.4 prepositionChoice
**Instruction**: "Select the correct preposition."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: prepositionChoice
InteractionType: choice
Focus: Spatial/Temporal Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Choose the right preposition.",
  "difficulty": 4,
  "question": "The book is ___ the table.",
  "options": ["on", "at", "by", "in"],
  "correctAnswerIndex": 0,
  "hint": "It's touching the surface.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.5 articleUsage
**Instruction**: "Identify if 'a', 'an', or 'the' is needed."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: articleUsage
InteractionType: choice
Focus: Determiner Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the correct article.",
  "difficulty": 3,
  "question": "I saw ___ elephant at the zoo.",
  "options": ["a", "an", "the", "no article"],
  "correctAnswerIndex": 1,
  "hint": "Elephant starts with a vowel sound.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.6 passiveToActive
**Instruction**: "Change the sentence from passive to active voice."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: passiveToActive
InteractionType: writing
Focus: Voice Dynamics.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Change to active voice.",
  "difficulty": 15,
  "passiveSentence": "The cake was eaten by the boy.",
  "activeSentence": "The boy ate the cake.",
  "hint": "The subject should perform the action.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.7 reportedSpeech
**Instruction**: "Rewrite the direct speech as reported speech."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: reportedSpeech
InteractionType: writing
Focus: Indirect Communication.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Change to reported speech.",
  "difficulty": 18,
  "directSpeech": "I am hungry,' said Peter.",
  "reportedSpeech": "Peter said that he was hungry.",
  "hint": "Change the tense and the pronoun.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.8 relativeClauses
**Instruction**: "Combine the sentences using a relative pronoun."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: relativeClauses
InteractionType: writing
Focus: Sentence Combining.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Combine the sentences.",
  "difficulty": 22,
  "sentenceA": "The man is my uncle.",
  "sentenceB": "He is wearing a hat.",
  "combinedSentence": "The man who is wearing a hat is my uncle.",
  "hint": "Use 'who' for people.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.9 conjunctions
**Instruction**: "Select the best conjunction to join the ideas."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: conjunctions
InteractionType: choice
Focus: Logical Connectives.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Choose the best conjunction.",
  "difficulty": 12,
  "question": "It was raining, ___ we went for a walk anyway.",
  "options": ["but", "so", "because", "and"],
  "correctAnswerIndex": 0,
  "hint": "The second part contrasts the first.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 5.10 modalVerbs
**Instruction**: "Which modal verb best expresses a strong obligation?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: modalVerbs
InteractionType: choice
Focus: Intent & Nuance.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the correct modal verb.",
  "difficulty": 10,
  "question": "You ___ stop at a red light.",
  "options": ["must", "can", "might", "should"],
  "correctAnswerIndex": 0,
  "hint": "It's a legal requirement.",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 6. VOCABULARY (Interaction Type: choice / match / writing)

### 6.1 flashcards
**Instruction**: "Study the word and its definition."
**Interaction**: match
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: flashcards
InteractionType: match
Focus: Semantic Memory.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Match the word to its definition.",
  "difficulty": 1,
  "word": "Melancholy",
  "definition": "A feeling of pensive sadness.",
  "example": "He felt a wave of melancholy on cloudy days.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.2 synonymMatch
**Instruction**: "Find the closest synonym from the list."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: synonymMatch
InteractionType: choice
Focus: Lexical Range.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Pick the synonym.",
  "difficulty": 5,
  "word": "Brave",
  "options": ["Courageous", "Timid", "Weak", "Angry"],
  "correctAnswerIndex": 0,
  "hint": "It means having no fear.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.3 antonymMatch
**Instruction**: "Find the opposite of the given word."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: antonymMatch
InteractionType: choice
Focus: Contrastive Meaning.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Pick the antonym.",
  "difficulty": 5,
  "word": "Artificial",
  "options": ["Natural", "Fake", "Old", "New"],
  "correctAnswerIndex": 0,
  "hint": "Think about things made by nature.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.4 contextUsage
**Instruction**: "Which sentence uses the word correctly?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: contextUsage
InteractionType: choice
Focus: Contextual Accuracy.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the correct usage.",
  "difficulty": 12,
  "word": "Pragmatic",
  "options": [
    "He took a pragmatic approach to solving the budget crisis.",
    "The pragmatics of the weather made it rain.",
    "She felt very pragmatic after drinking coffee.",
    "A pragmatic of birds flew south."
  ],
  "correctAnswerIndex": 0,
  "hint": "It means being practical.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.5 phrasalVerbs
**Instruction**: "Select the correct meaning of the phrasal verb."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: phrasalVerbs
InteractionType: choice
Focus: Idiomatic Verbs.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What does 'break down' mean here?",
  "difficulty": 15,
  "passage": "His car broke down on the highway.",
  "options": ["Stop functioning", "Start crying", "Go faster", "Turn left"],
  "correctAnswerIndex": 0,
  "hint": "The car stopped working.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.6 idioms
**Instruction**: "What does the idiom mean in this context?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: idioms
InteractionType: choice
Focus: Figurative Language.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Pick the correct meaning.",
  "difficulty": 20,
  "idiom": "Under the weather",
  "options": ["Feeling ill", "Outside in rain", "In a storm", "Happy"],
  "correctAnswerIndex": 0,
  "hint": "It has to do with health.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.7 collocations
**Instruction**: "Complete the collocation with the common partner-word."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: collocations
InteractionType: choice
Focus: Natural Word Pairing.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Choose the word that fits.",
  "difficulty": 8,
  "question": "I made a/an ___ decision.",
  "options": ["informed", "known", "said", "thought"],
  "correctAnswerIndex": 0,
  "hint": "Commonly used with 'decision' to mean well-researched.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.8 wordFormations
**Instruction**: "Change the word to its noun form."
**Interaction**: writing
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: wordFormations
InteractionType: writing
Focus: Morphology.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Type the noun form.",
  "difficulty": 18,
  "verb": "Inform",
  "noun": "Information",
  "hint": "Think of the act of informing.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.9 rootWords
**Instruction**: "What is the common root of 'bicycle' and 'binary'?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: rootWords
InteractionType: choice
Focus: Etymology.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Identify the root meaning.",
  "difficulty": 22,
  "options": ["Two", "Circle", "Machine", "Fast"],
  "correctAnswerIndex": 0,
  "hint": "How many wheels on a bicycle?",
  "xpReward": 10,
  "coinReward": 10
}
```

### 6.10 vocabularyExpansion
**Instruction**: "Which word is more formal than 'get' in this sentence?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: vocabularyExpansion
InteractionType: choice
Focus: Professional Lexicon.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the formal equivalent.",
  "difficulty": 25,
  "sentence": "I need to get a new passport.",
  "options": ["Obtain", "Grab", "Find", "Buy"],
  "correctAnswerIndex": 0,
  "hint": "Think of official processes.",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 7. ACCENT (Interaction Type: audio / stt)

### 7.1 minimalPairs
**Instruction**: "Select the word you hear (minimal pair)."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: minimalPairs
InteractionType: choice
Focus: Phonetic Contrast.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Which word do you hear?",
  "difficulty": 2,
  "textToSpeak": "Ship",
  "options": ["Ship", "Sheep"],
  "correctAnswerIndex": 0,
  "hint": "Listen for the short 'i' sound.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.2 syllableStress
**Instruction**: "Which syllable is stressed in this word?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: syllableStress
InteractionType: choice
Focus: Word Rhythm.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the stressed syllable.",
  "difficulty": 5,
  "word": "ECONOMY",
  "options": ["E-", "-CON-", "-O-", "-MY"],
  "correctAnswerIndex": 1,
  "hint": "Listen to the volume of the second part.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.3 intonationPatterns
**Instruction**: "Does the voice rise or fall at the end of this question?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: intonationPatterns
InteractionType: choice
Focus: Sentence Melody.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the intonation pattern.",
  "difficulty": 8,
  "textToSpeak": "Are you coming today?",
  "options": ["Rising", "Falling"],
  "correctAnswerIndex": 0,
  "hint": "Listen to the end of the sentence.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.4 connectedSpeech
**Instruction**: "Identify the blended sound in 'Would you'."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: connectedSpeech
InteractionType: choice
Focus: Linking & Blending.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What sound do you hear between 'Would' and 'you'?",
  "difficulty": 12,
  "textToSpeak": "Would you like some tea?",
  "options": ["/dʒ/", "/d/", "/y/", "/z/"],
  "correctAnswerIndex": 0,
  "hint": "It sounds like 'Woud-ja'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.5 vowelDiscrimination
**Instruction**: "Which of these audio snippets contains the /æ/ sound?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: vowelDiscrimination
InteractionType: choice
Focus: Vowel Clarity.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the option with the /æ/ sound.",
  "difficulty": 10,
  "options": ["Cat", "Cut", "Cot", "Coat"],
  "correctAnswerIndex": 0,
  "hint": "Think of the short 'a' in 'back'.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.6 consonantFocus
**Instruction**: "Focus on the 'th' sound. Is it voiced or unvoiced?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: consonantFocus
InteractionType: choice
Focus: Consonant Precision.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Is the 'th' voiced or unvoiced?",
  "difficulty": 15,
  "word": "THINK",
  "options": ["Voiced", "Unvoiced"],
  "correctAnswerIndex": 1,
  "hint": "Touch your throat. Does it vibrate?",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.7 rhythmPractice
**Instruction**: "Mirror the rhythm and stress of the speaker."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: rhythmPractice
InteractionType: stt
Focus: Prosody.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Repeat following the same rhythm.",
  "difficulty": 20,
  "textToSpeak": "The early bird catches the worm.",
  "hint": "Stress only the content words.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.8 homophones
**Instruction**: "Which spelling matches the word heard in this context?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: homophones
InteractionType: choice
Focus: Sound vs Meaning.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the correct spelling.",
  "difficulty": 4,
  "textToSpeak": "I can see the sea from here.",
  "options": ["Sea", "See"],
  "correctAnswerIndex": 0,
  "hint": "Think of the ocean.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.9 phonemeGrouping
**Instruction**: "Which word doesn't rhyme with the others?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: phonemeGrouping
InteractionType: choice
Focus: Rhyme & Cluster.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Pick the odd one out.",
  "difficulty": 7,
  "options": ["Height", "Light", "Right", "Wait"],
  "correctAnswerIndex": 3,
  "hint": "Listen to the vowel sound.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 7.10 thoughtGroups
**Instruction**: "Where should the speaker pause to make logical sense?"
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: thoughtGroups
InteractionType: choice
Focus: Phrasing.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the correct pause point.",
  "difficulty": 25,
  "passage": "If you want to go to the store you should take the bus.",
  "options": [
    "If you want to go / to the store / you should take the bus.",
    "If / you want to go to / the store you should / take the bus.",
    "If you want / to go to the / store you should take / the bus."
  ],
  "correctAnswerIndex": 0,
  "hint": "Pause after complete thoughts.",
  "xpReward": 10,
  "coinReward": 10
}
```

---

## 8. ROLEPLAY (Interaction Type: choice / stt)

### 8.1 branchingDialogue
**Instruction**: "Choose your response to continue the conversation."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: branchingDialogue
InteractionType: choice
Focus: Social Flow.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Select the best response.",
  "difficulty": 10,
  "lastLine": "I'm sorry, we are all out of milk.",
  "options": ["That's okay, I'll take soy milk instead.", "I hate you.", "Where is my car?", "Give me milk now."],
  "correctAnswerIndex": 0,
  "hint": "Be polite and look for an alternative.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.2 customerService
**Instruction**: "Help the customer with their complaint."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: customerService
InteractionType: choice
Focus: Professionalism.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "How do you handle this complaint?",
  "difficulty": 15,
  "complaint": "My order arrived three days late and was damaged.",
  "options": [
    "I apologize for the inconvenience. Let me issue a refund immediately.",
    "It's not our fault, blame the shipping company.",
    "You should be more patient.",
    "Why are you telling me this?"
  ],
  "correctAnswerIndex": 0,
  "hint": "Always apologize first.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.3 medicalConsultation
**Instruction**: "Describe your symptoms to the doctor."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: medicalConsultation
InteractionType: stt
Focus: Specific Vocabulary.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Respond to the doctor's question.",
  "difficulty": 20,
  "doctorQuestion": "Where exactly does it hurt?",
  "sampleAnswer": "I have a sharp pain in my lower back.",
  "hint": "Mention the location and the type of pain.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.4 jobInterview
**Instruction**: "Answer the interview question professionally."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: jobInterview
InteractionType: stt
Focus: Career Communication.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Respond to the interviewer.",
  "difficulty": 25,
  "interviewerQuestion": "Why should we hire you for this position?",
  "sampleAnswer": "I have extensive experience in this field and a strong work ethic.",
  "hint": "Mention your skills and experience.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.5 travelScenario
**Instruction**: "You are at the airport. Ask about your flight delay."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: travelScenario
InteractionType: choice
Focus: Travel Logic.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What do you say to the agent?",
  "difficulty": 12,
  "situation": "Your flight to Rome has been delayed by 5 hours.",
  "options": [
    "Excuse me, could you tell me why the flight to Rome is delayed?",
    "Rome is far away.",
    "I like airplanes.",
    "Give me a ticket to London instead."
  ],
  "correctAnswerIndex": 0,
  "hint": "Be polite and ask for information.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.6 educationalDiscussion
**Instruction**: "Express your agreement or disagreement with the student."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: educationalDiscussion
InteractionType: stt
Focus: Academic Discourse.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Respond to the student's point.",
  "difficulty": 22,
  "studentPoint": "I think renewable energy is too expensive to implement globally.",
  "sampleAnswer": "I see your point, but the long-term benefits outweigh the initial costs.",
  "hint": "Use a respectful 'disagreement' phrase.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.7 socialInteraction
**Instruction**: "Meet a new neighbor and introduce yourself."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: socialInteraction
InteractionType: choice
Focus: Casual Conversation.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "What do you say?",
  "difficulty": 8,
  "neighborLine": "Hi! I just moved in next door.",
  "options": [
    "Welcome to the neighborhood! My name is John.",
    "I am busy.",
    "Who are you?",
    "The weather is nice."
  ],
  "correctAnswerIndex": 0,
  "hint": "Welcome them and introduce yourself.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.8 emergencySituation
**Instruction**: "You see a fire. Call the emergency services."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: emergencySituation
InteractionType: stt
Focus: Crisis Communication.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Speak to the dispatcher.",
  "difficulty": 18,
  "dispatcherQuestion": "Emergency services, what is the location of the fire?",
  "sampleAnswer": "The fire is at 123 Maple Street.",
  "hint": "Provide a clear address.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.9 technicalSupport
**Instruction**: "Explain your computer problem to the technician."
**Interaction**: stt
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: technicalSupport
InteractionType: stt
Focus: Technical Vocabulary.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Describe the issue.",
  "difficulty": 20,
  "techQuestion": "Can you describe what happens when you try to turn it on?",
  "sampleAnswer": "The screen stays black and I hear a loud clicking sound.",
  "hint": "Describe the visual and auditory symptoms.",
  "xpReward": 10,
  "coinReward": 10
}
```

### 8.10 negotiations
**Instruction**: "Negotiate a better price for the antique vase."
**Interaction**: choice
**Prompt**:
```text
[INCLUDE GLOBAL BASE]
Subtype: negotiations
InteractionType: choice
Focus: Persuasion.
JSON Item Structure:
{
  "id": "uuid",
  "instruction": "Make a counter-offer.",
  "difficulty": 30,
  "sellerPrice": "I cannot go lower than $50 for this vase.",
  "options": [
    "Would you consider $40 if I buy the lamp as well?",
    "Fine, I will pay $1000.",
    "I don't like vases.",
    "Goodbye."
  ],
  "correctAnswerIndex": 0,
  "hint": "Try to offer a deal or bundle.",
  "xpReward": 10,
  "coinReward": 10
}
```
