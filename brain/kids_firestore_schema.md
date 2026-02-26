# Gaia Kids: Ready-to-Use Content Generation Guide

This guide provides **standalone, copy-paste prompts** for each of the 20 Kids Zone game categories. Simply copy the prompt for your desired category, paste it into ChatGPT/Gemini, and you will get perfect JSON data ready for the Admin Panel.

---

## 🎨 Design Strategy: Premium 3D Clay
All prompts are pre-configured to generate **"Cute, vibrant 3D clay-style"** image descriptions. This ensures your app has a consistent, world-class aesthetic.

---

## 🎡 Standalone Game Prompts (Copy & Paste)

### 1. Alphabet (Letters & Phonics)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Alphabet" category.
Level: 1 (Basic Identification)
Rules: Output ONLY a raw JSON array. Use 3D clay-style image prompts. Instruction must be short.
JSON Template:
{
  "id": "ALPHA_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Which one is the big letter A?",
  "question": "A",
  "options": ["A", "B", "C", "D"],
  "correctAnswer": "A",
  "imageUrl": "3d clay style letter A, red color, friendly eyes, white background",
  "metadata": { "concept": "letter_id" }
}
```

### 2. Numbers (Counting & Digits)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Numbers" category.
Level: 1 (Counting 1-10)
Rules: Output ONLY a raw JSON array. Use 3D clay-style image prompts.
JSON Template:
{
  "id": "NUM_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Can you find 3 stars?",
  "question": "3",
  "options": ["1", "5", "3", "2"],
  "correctAnswer": "3",
  "imageUrl": "three shiny yellow 3d clay stars, sparkly, white background",
  "metadata": { "concept": "counting" }
}
```

### 3. Colors (Identification)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Colors" category.
Level: 1 (Primary Colors)
Rules: Output ONLY a raw JSON array. Use 3D clay-style image prompts.
JSON Template:
{
  "id": "COLOR_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Find the color of the yummy apple!",
  "question": "Red",
  "options": ["Blue", "Red", "Green", "Yellow"],
  "correctAnswer": "Red",
  "imageUrl": "vibrant 3d clay red apple, shiny, soft texture, white background",
  "metadata": { "concept": "color_matching" }
}
```

### 4. Shapes (Recognition)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Shapes" category.
Level: 1 (Basic Shapes)
Rules: Output ONLY a raw JSON array. Use 3D clay-style image prompts.
JSON Template:
{
  "id": "SHAPE_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Which shape looks like a pizza slice?",
  "question": "Triangle",
  "options": ["Square", "Circle", "Triangle", "Star"],
  "correctAnswer": "Triangle",
  "imageUrl": "3d clay pizza slice, triangular shape, melting cheese, white background",
  "metadata": { "concept": "shapes_real_world" }
}
```

### 5. Animals (Sounds & Names)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Animals" category.
Level: 1 (Farm Animals)
Rules: Output ONLY a raw JSON array. Use 3D clay-style image prompts.
JSON Template:
{
  "id": "ANIMAL_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Who says Meow Meow?",
  "question": "Cat",
  "options": ["Dog", "Cat", "Cow", "Pig"],
  "correctAnswer": "Cat",
  "imageUrl": "cute 3d clay kitten, big eyes, fluffy tail, ginger color, white background",
  "metadata": { "concept": "animal_sounds" }
}
```

### 6. Fruits (Colors & Shapes)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Fruits" category.
Rules: Output ONLY a raw JSON array. 3D clay aesthetic.
JSON Template:
{
  "id": "FRUIT_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Find the long yellow banana!",
  "question": "Banana",
  "options": ["Apple", "Banana", "Grape", "Melon"],
  "correctAnswer": "Banana",
  "imageUrl": "vibrant 3d clay banana, bright yellow, happy face, white background",
  "metadata": { "concept": "fruit_id" }
}
```

### 7. Family (Roles)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Family" category.
Rules: Output ONLY a raw JSON array. 3D characters.
JSON Template:
{
  "id": "FAM_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Who is the Baby?",
  "question": "Baby",
  "options": ["Father", "Mother", "Baby", "Grandpa"],
  "correctAnswer": "Baby",
  "imageUrl": "cute 3d clay baby in a blue onesie, laughing, white background",
  "metadata": { "concept": "family_roles" }
}
```

### 8. School (Tools)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "School" category.
Rules: Output ONLY a raw JSON array. 3D clay.
JSON Template:
{
  "id": "SCH_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "What do we use to color?",
  "question": "Crayon",
  "options": ["Book", "Eraser", "Crayon", "Desk"],
  "correctAnswer": "Crayon",
  "imageUrl": "colorful 3d clay crayons in a box, vibrant, white background",
  "metadata": { "concept": "school_tools" }
}
```

### 9. Verbs (Actions)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Verbs" category.
Rules: Output ONLY a raw JSON array. 3D dynamic characters.
JSON Template:
{
  "id": "VERB_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Find someone who is Jumping!",
  "question": "Jump",
  "options": ["Run", "Jump", "Sleep", "Eat"],
  "correctAnswer": "Jump",
  "imageUrl": "happy 3d clay boy jumping high, vibrant colors, white background",
  "metadata": { "concept": "action_id" }
}
```

### 10. Emotions (Feelings)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Emotions" category.
Rules: Output ONLY a raw JSON array. expressive 3D faces.
JSON Template:
{
  "id": "EMO_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "He got a new toy! How does he feel?",
  "question": "Happy",
  "options": ["Sad", "Angry", "Happy", "Crying"],
  "correctAnswer": "Happy",
  "imageUrl": "joyful 3d clay emoji face, huge smile, bright yellow, white background",
  "metadata": { "concept": "empathy" }
}
```

### 11. Daily Routine (My Day)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Routine" category.
Rules: Output ONLY a raw JSON array. Sequence-based activities.
JSON Template:
{
  "id": "ROUTINE_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Look! What do we do after we wake up?",
  "question": "Brush teeth",
  "options": ["Go to bed", "Brush teeth", "Dinner", "Bath"],
  "correctAnswer": "Brush teeth",
  "imageUrl": "3d clay style toothbrush and toothpaste, minty, vibrant, white background",
  "metadata": { "concept": "daily_routine" }
}
```

### 12. Opposites (Big & Small)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Opposites" category.
Rules: Output ONLY a raw JSON array. Comparison logic.
JSON Template:
{
  "id": "OPP_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "The elephant is big. Find something SMALL!",
  "question": "Mouse",
  "options": ["Whale", "Truck", "Mouse", "House"],
  "correctAnswer": "Mouse",
  "imageUrl": "tiny 3d clay mouse, cute whiskers, grey, white background",
  "metadata": { "concept": "comparisons" }
}
```

### 13. Prepositions (Where is it?)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Prepositions" category.
Rules: Output ONLY a raw JSON array. Spatial awareness.
JSON Template:
{
  "id": "PREP_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Where is the cat? Find UNDER!",
  "question": "Under",
  "options": ["On", "Over", "Under", "Behind"],
  "correctAnswer": "Under",
  "imageUrl": "3d clay cat hiding under a colorful table, vibrant, white background",
  "metadata": { "concept": "spatial" }
}
```

### 14. Phonics (Sounds)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Phonics" category.
Rules: Output ONLY a raw JSON array. Sound-to-object matching.
JSON Template:
{
  "id": "PHON_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Which word starts with the sound /B/?",
  "question": "Ball",
  "options": ["Apple", "Ball", "Cat", "Dog"],
  "correctAnswer": "Ball",
  "imageUrl": "bouncy 3d clay beach ball, red and blue, shiny, white background",
  "metadata": { "concept": "initial_sounds" }
}
```

### 15. Word Jumble (Simple Spelling)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Word Jumble" category.
Rules: Output ONLY a raw JSON array. Unscramble simple words.
JSON Template:
{
  "id": "JUMBLE_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Unscramble these letters to make CAT!",
  "question": "A-C-T",
  "options": ["DOG", "CAT", "SUN", "BUS"],
  "correctAnswer": "CAT",
  "imageUrl": "3d clay alphabet blocks jumbled, colorful, white background",
  "metadata": { "concept": "spelling_intro" }
}
```

### 16. Time (Tick Tock)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Time" category.
Rules: Output ONLY a raw JSON array. Day/Night and Clock basics.
JSON Template:
{
  "id": "TIME_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "It is breakfast time! Is it Morning or Night?",
  "question": "Morning",
  "options": ["Morning", "Night", "Evening", "Noon"],
  "correctAnswer": "Morning",
  "imageUrl": "happy 3d clay sun peeking over a cereal bowl, morning light, white background",
  "metadata": { "concept": "time_context" }
}
```

### 17. Nature (Outdoors)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Nature" category.
Rules: Output ONLY a raw JSON array. Weather and environment.
JSON Template:
{
  "id": "NAT_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "What appears in the sky after the rain?",
  "question": "Rainbow",
  "options": ["Snow", "Fire", "Rainbow", "Cloud"],
  "correctAnswer": "Rainbow",
  "imageUrl": "vibrant 3d clay rainbow with soft clouds, colorful, white background",
  "metadata": { "concept": "nature_logic" }
}
```

### 18. Home (My House)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Home" category.
Rules: Output ONLY a raw JSON array. Household objects.
JSON Template:
{
  "id": "HOME_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Where do we sit to watch a movie?",
  "question": "Sofa",
  "options": ["Bed", "Table", "Sofa", "Fridge"],
  "correctAnswer": "Sofa",
  "imageUrl": "comfy 3d clay sofa, soft cushions, blue color, white background",
  "metadata": { "concept": "home_objects" }
}
```

### 19. Food (Yummy!)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Food" category.
Rules: Output ONLY a raw JSON array. Meal identification.
JSON Template:
{
  "id": "FOOD_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Find the yummy Breakfast egg!",
  "question": "Egg",
  "options": ["Pizza", "Burger", "Egg", "Rice"],
  "correctAnswer": "Egg",
  "imageUrl": "fried 3d clay egg, plate, vibrant yellow yolk, white background",
  "metadata": { "concept": "food_groups" }
}
```

### 20. Transport (Vroom!)
```markdown
You are an expert kid-learning designer. Generate 10 unique JSON objects for the "Transport" category.
Rules: Output ONLY a raw JSON array. Vehicles and travel.
JSON Template:
{
  "id": "TRANS_001",
  "gameType": "choice_multi",
  "level": 1,
  "instruction": "Which one flies high in the clouds?",
  "question": "Airplane",
  "options": ["Car", "Boat", "Airplane", "Train"],
  "correctAnswer": "Airplane",
  "imageUrl": "cute 3d clay red airplane, flying, soft white smoke, white background",
  "metadata": { "concept": "movement_type" }
}
```

---

## 🛡️ Anti-Crash Rules (Strict)
1. **correctAnswer** MUST exist in **options**.
2. **id** must be unique (use Category Prefix like `TRANS_101`).
3. **imageUrl** should always be a descriptive prompt for AI image generation.

---
*Created by Antigravity for Gaia Kids Zone | 2026*
