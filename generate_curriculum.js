/**
 * Voxai Quest - Curriculum Generator
 * Generates JSON curriculum files for all 80 games.
 * Each game: 200 levels × 3 questions = 600 items across 7 section files.
 * s1-s6: 30 levels each (90 items), s7: 20 levels (60 items)
 */
const fs = require('fs');
const path = require('path');

const BASE = path.join(__dirname, 'assets', 'curriculum');

// ─── CONTENT BANKS ───────────────────────────────────────────────────────────

const TOPICS = {
  greetings: ['Hello, how are you?', 'Good morning, everyone.', 'Nice to meet you.', 'How do you do?', 'Welcome aboard.'],
  family: ['My mother is kind.', 'He has two brothers.', 'She lives with her grandmother.', 'Our family is large.', 'My father works hard.'],
  food: ['I would like some coffee.', 'The soup is delicious.', 'Can I have the menu?', 'This cake is sweet.', 'We need more bread.'],
  travel: ['Where is the airport?', 'The train leaves at noon.', 'I need a taxi please.', 'How far is the hotel?', 'My flight is delayed.'],
  weather: ['It is raining today.', 'The sun is shining brightly.', 'It will snow tomorrow.', 'The wind is very strong.', 'What a beautiful day.'],
  school: ['The teacher is explaining.', 'I have homework tonight.', 'The library is open.', 'We have a test tomorrow.', 'Class starts at nine.'],
  work: ['The meeting is at three.', 'I need to finish the report.', 'She got a promotion.', 'The deadline is Friday.', 'Let us discuss the project.'],
  health: ['I have a headache.', 'The doctor will see you now.', 'Take this medicine twice daily.', 'I feel much better today.', 'Exercise is important.'],
  shopping: ['How much does this cost?', 'I am looking for a gift.', 'Do you have this in blue?', 'Can I try this on?', 'Where is the checkout?'],
  nature: ['The mountains are beautiful.', 'The river flows gently.', 'Birds sing in the morning.', 'The flowers are blooming.', 'Stars twinkle at night.'],
  technology: ['My phone needs charging.', 'The internet is slow today.', 'Send me an email please.', 'This app is very useful.', 'Update your software now.'],
  emotions: ['I am so happy today.', 'She feels quite nervous.', 'He is very excited.', 'They were disappointed.', 'We are extremely grateful.'],
  hobbies: ['I enjoy playing guitar.', 'She likes painting flowers.', 'He runs every morning.', 'We love watching movies.', 'They practice yoga daily.'],
  city: ['The traffic is heavy.', 'Where is the nearest bank?', 'The park is beautiful.', 'This building is very tall.', 'The museum opens at ten.'],
  home: ['The living room is cozy.', 'Please close the door.', 'The garden needs watering.', 'I cleaned the kitchen.', 'The bedroom is upstairs.'],
  sports: ['The game starts at seven.', 'She won the championship.', 'He plays basketball well.', 'The team practiced hard.', 'Running builds endurance.'],
  animals: ['The dog is very loyal.', 'Cats are independent animals.', 'The bird flew away quickly.', 'Fish need clean water.', 'Elephants have great memory.'],
  culture: ['This painting is remarkable.', 'The concert was amazing.', 'They celebrate many festivals.', 'The book is fascinating.', 'Music connects people globally.'],
  environment: ['We must reduce pollution.', 'Recycle plastic and paper.', 'Forests are vital ecosystems.', 'Climate change is real.', 'Save water every day.'],
  science: ['The earth orbits the sun.', 'Water boils at one hundred degrees.', 'Gravity pulls objects down.', 'Plants need sunlight to grow.', 'The moon affects the tides.'],
};

const TOPIC_KEYS = Object.keys(TOPICS);

function pickTopic(level) {
  return TOPIC_KEYS[level % TOPIC_KEYS.length];
}

// ─── WORD BANKS ──────────────────────────────────────────────────────────────

const MISSING_WORDS = [
  { sentence: 'The sun rises in the ___.', word: 'east', hint: 'Think about directions.' },
  { sentence: 'Water is essential for ___.', word: 'life', hint: 'Everything needs it to survive.' },
  { sentence: 'She went to the ___ to buy bread.', word: 'bakery', hint: 'A place that sells baked goods.' },
  { sentence: 'The ___ is the largest planet.', word: 'Jupiter', hint: 'Think about the solar system.' },
  { sentence: 'He takes the ___ to work every day.', word: 'bus', hint: 'A form of public transport.' },
  { sentence: 'The capital of France is ___.', word: 'Paris', hint: 'A famous European city.' },
  { sentence: 'You read books in a ___.', word: 'library', hint: 'A quiet place full of books.' },
  { sentence: 'The opposite of hot is ___.', word: 'cold', hint: 'Think about temperature.' },
  { sentence: 'We breathe ___ to stay alive.', word: 'oxygen', hint: 'A gas in the air.' },
  { sentence: 'The ___ shines at night.', word: 'moon', hint: 'Look up in the dark sky.' },
  { sentence: 'An apple is a type of ___.', word: 'fruit', hint: 'Something that grows on trees.' },
  { sentence: 'You wear ___ on your feet.', word: 'shoes', hint: 'Footwear for walking.' },
  { sentence: 'A ___ has four legs and barks.', word: 'dog', hint: 'A common household pet.' },
  { sentence: 'The ocean is very ___ and wide.', word: 'deep', hint: 'The opposite of shallow.' },
  { sentence: 'She plays the ___ beautifully.', word: 'piano', hint: 'A musical instrument with keys.' },
  { sentence: 'In winter, it often ___.', word: 'snows', hint: 'White flakes fall from the sky.' },
  { sentence: 'The baby is ___ soundly.', word: 'sleeping', hint: 'Resting with eyes closed.' },
  { sentence: 'Birds build ___ in trees.', word: 'nests', hint: 'A home for baby birds.' },
  { sentence: 'We celebrate ___ in December.', word: 'Christmas', hint: 'A holiday with gifts and trees.' },
  { sentence: 'The ___ is used to tell time.', word: 'clock', hint: 'It has hands and numbers.' },
  { sentence: 'She writes with a ___.', word: 'pen', hint: 'A tool for writing.' },
  { sentence: 'The ___ of the United States is Washington D.C.', word: 'capital', hint: 'The main city of a country.' },
  { sentence: 'He drinks ___ every morning.', word: 'coffee', hint: 'A hot brown beverage.' },
  { sentence: 'The earth has seven ___.', word: 'continents', hint: 'Large landmasses on the globe.' },
  { sentence: 'A triangle has three ___.', word: 'sides', hint: 'Edges of a shape.' },
  { sentence: 'The rain makes the ground ___.', word: 'wet', hint: 'The opposite of dry.' },
  { sentence: 'You see your ___ in a mirror.', word: 'reflection', hint: 'An image of yourself.' },
  { sentence: 'The ___ is the tallest animal.', word: 'giraffe', hint: 'It has a very long neck.' },
  { sentence: 'Students go to ___ to learn.', word: 'school', hint: 'A place of education.' },
  { sentence: 'The heart ___ blood through the body.', word: 'pumps', hint: 'A pushing action.' },
];

const SITUATIONS = [
  { text: 'You are at a cafe and want to order a latte.', sample: 'I would like a latte, please.', hint: "Use 'I would like' or 'Can I have'." },
  { text: 'You are lost and need directions to the train station.', sample: 'Excuse me, could you tell me how to get to the train station?', hint: 'Start with a polite phrase.' },
  { text: 'You are at a restaurant and the food is too salty.', sample: 'Excuse me, this dish is a bit too salty. Could I get a replacement?', hint: 'Be polite but clear about the problem.' },
  { text: 'You are introducing yourself at a new job.', sample: 'Hello everyone, my name is Alex and I am excited to join the team.', hint: 'Include your name and enthusiasm.' },
  { text: 'You want to ask a friend to help you move this weekend.', sample: 'Hey, would you be free to help me move this Saturday?', hint: "Use 'would you' for polite requests." },
  { text: 'You are returning an item at a store.', sample: 'I would like to return this item. I have the receipt.', hint: 'State your intention and provide context.' },
  { text: 'You want to complain about noisy neighbors.', sample: 'Hi, I wanted to let you know that the noise has been quite loud lately.', hint: 'Be respectful but direct.' },
  { text: 'You are at the doctor and describing a headache.', sample: 'I have had a persistent headache for two days.', hint: 'Describe duration and intensity.' },
  { text: 'You are checking into a hotel.', sample: 'Good evening, I have a reservation under the name Smith.', hint: 'Start formally and provide your name.' },
  { text: 'You are asking for a day off at work.', sample: 'I would like to request a day off next Friday for a personal matter.', hint: 'State the day and give a brief reason.' },
  { text: 'You are making a phone call to schedule an appointment.', sample: 'Hello, I would like to schedule an appointment for next week.', hint: 'Be clear about what you need.' },
  { text: 'You are thanking a colleague for their help on a project.', sample: 'Thank you so much for your help. I really appreciate it.', hint: 'Express genuine gratitude.' },
  { text: 'You are asking for the bill at a restaurant.', sample: 'Could we have the bill, please?', hint: "Use 'Could we' for politeness." },
  { text: 'You are apologizing for being late to a meeting.', sample: 'I am sorry for being late. There was heavy traffic.', hint: 'Apologize and give a brief explanation.' },
  { text: 'You need to borrow a charger from a stranger at an airport.', sample: 'Excuse me, would you mind if I borrowed your charger for a moment?', hint: "Use 'would you mind' for polite requests." },
];

const SCENE_KEYWORDS = [
  { scene: 'A busy park on a Saturday afternoon with families and a dog.', keywords: ['sunlight', 'crowded', 'joyful'] },
  { scene: 'A rainy street at night with reflections on the pavement.', keywords: ['gloomy', 'wet', 'peaceful'] },
  { scene: 'A kitchen with someone baking cookies.', keywords: ['warm', 'delicious', 'cozy'] },
  { scene: 'A classroom with students taking a test.', keywords: ['quiet', 'focused', 'nervous'] },
  { scene: 'A beach at sunset with waves crashing.', keywords: ['golden', 'serene', 'beautiful'] },
  { scene: 'A farmer market with colorful fruits and vegetables.', keywords: ['fresh', 'vibrant', 'organic'] },
  { scene: 'An office with people working at their desks.', keywords: ['busy', 'professional', 'modern'] },
  { scene: 'A snow-covered village in winter.', keywords: ['cold', 'white', 'magical'] },
  { scene: 'A birthday party with balloons and a cake.', keywords: ['festive', 'cheerful', 'celebration'] },
  { scene: 'A library with tall bookshelves and reading lamps.', keywords: ['quiet', 'knowledge', 'organized'] },
];

const YES_NO_QUESTIONS = [
  { q: 'Can cats fly?', a: 'No, cats do not have wings.', hint: 'Think about biology.' },
  { q: 'Is the earth round?', a: 'Yes, the earth is approximately spherical.', hint: 'Think about geography.' },
  { q: 'Do fish breathe air?', a: 'No, fish breathe through their gills.', hint: 'Think about underwater life.' },
  { q: 'Is water wet?', a: 'Yes, water makes things wet by contact.', hint: 'Think about the properties of liquids.' },
  { q: 'Can penguins fly?', a: 'No, penguins are flightless birds.', hint: 'Think about Antarctic animals.' },
  { q: 'Is the sun a star?', a: 'Yes, the sun is the nearest star to Earth.', hint: 'Think about astronomy.' },
  { q: 'Do plants need sunlight?', a: 'Yes, plants use sunlight for photosynthesis.', hint: 'Think about how plants grow.' },
  { q: 'Is ice cream a healthy meal?', a: 'No, ice cream is a dessert, not a balanced meal.', hint: 'Think about nutrition.' },
  { q: 'Can humans breathe underwater?', a: 'No, humans need air to breathe.', hint: 'Think about our lungs.' },
  { q: 'Is French spoken in France?', a: 'Yes, French is the official language of France.', hint: 'Think about European countries.' },
  { q: 'Do trees produce oxygen?', a: 'Yes, trees release oxygen during photosynthesis.', hint: 'Think about the environment.' },
  { q: 'Is a whale a fish?', a: 'No, a whale is a mammal that lives in the ocean.', hint: 'Think about animal classification.' },
  { q: 'Can dogs see colors?', a: 'Yes, but dogs see fewer colors than humans.', hint: 'Think about animal vision.' },
  { q: 'Is the moon bigger than the earth?', a: 'No, the moon is much smaller than the earth.', hint: 'Think about the solar system.' },
  { q: 'Do spiders have six legs?', a: 'No, spiders have eight legs.', hint: 'Count the legs of an arachnid.' },
];

const SYNONYMS = [
  { word: 'Enormous', accepted: ['huge', 'giant', 'vast', 'massive'], hint: 'Something very big.' },
  { word: 'Happy', accepted: ['glad', 'joyful', 'cheerful', 'delighted'], hint: 'A positive emotion.' },
  { word: 'Brave', accepted: ['courageous', 'bold', 'fearless', 'valiant'], hint: 'Having no fear.' },
  { word: 'Smart', accepted: ['intelligent', 'clever', 'wise', 'brilliant'], hint: 'Having great mental ability.' },
  { word: 'Fast', accepted: ['quick', 'rapid', 'swift', 'speedy'], hint: 'Moving with high speed.' },
  { word: 'Beautiful', accepted: ['gorgeous', 'stunning', 'lovely', 'attractive'], hint: 'Pleasing to look at.' },
  { word: 'Angry', accepted: ['furious', 'mad', 'irate', 'livid'], hint: 'A strong negative feeling.' },
  { word: 'Small', accepted: ['tiny', 'little', 'miniature', 'petite'], hint: 'Not large in size.' },
  { word: 'Old', accepted: ['ancient', 'elderly', 'aged', 'vintage'], hint: 'Having existed for a long time.' },
  { word: 'Rich', accepted: ['wealthy', 'affluent', 'prosperous', 'well-off'], hint: 'Having a lot of money.' },
  { word: 'Sad', accepted: ['unhappy', 'sorrowful', 'gloomy', 'miserable'], hint: 'The opposite of happy.' },
  { word: 'Strong', accepted: ['powerful', 'mighty', 'robust', 'sturdy'], hint: 'Having great physical force.' },
  { word: 'Difficult', accepted: ['hard', 'challenging', 'tough', 'demanding'], hint: 'Not easy to do.' },
  { word: 'Important', accepted: ['significant', 'crucial', 'vital', 'essential'], hint: 'Having great value or meaning.' },
  { word: 'Begin', accepted: ['start', 'commence', 'initiate', 'launch'], hint: 'To set something in motion.' },
];

const DIALOGUE_LINES = [
  { last: 'I really enjoyed the movie, didn\'t you?', sample: 'Yes, the acting was incredible!', hint: 'Express your opinion.' },
  { last: 'What do you think about the new restaurant?', sample: 'I think it has great food but the service is slow.', hint: 'Give a balanced opinion.' },
  { last: 'Are you coming to the party this weekend?', sample: 'Yes, I wouldn\'t miss it for the world!', hint: 'Show enthusiasm.' },
  { last: 'I heard you got a new job. Congratulations!', sample: 'Thank you! I am really excited about this opportunity.', hint: 'Express gratitude and excitement.' },
  { last: 'The weather has been terrible lately, hasn\'t it?', sample: 'It really has. I can\'t wait for summer to arrive.', hint: 'Agree and add your own thought.' },
  { last: 'Have you been to the new shopping mall yet?', sample: 'Not yet, but I plan to visit this weekend.', hint: 'Share your future plans.' },
  { last: 'I can\'t believe how expensive everything is now.', sample: 'I know, prices have gone up quite a lot recently.', hint: 'Show agreement and empathy.' },
  { last: 'Do you have any hobbies?', sample: 'Yes, I enjoy reading and playing the guitar.', hint: 'Share personal interests.' },
  { last: 'How was your vacation?', sample: 'It was wonderful! We visited some beautiful places.', hint: 'Describe your experience positively.' },
  { last: 'Would you like to grab some coffee?', sample: 'That sounds great! I know a nice place nearby.', hint: 'Accept the invitation warmly.' },
];

const PRONUNCIATION_WORDS = [
  { word: 'Phenomenon', phonetic: 'fuh-NOM-uh-non', hint: 'Stress the second syllable.' },
  { word: 'Comfortable', phonetic: 'KUMF-ter-bul', hint: 'Only three syllables in natural speech.' },
  { word: 'Wednesday', phonetic: 'WENZ-day', hint: 'The d is silent.' },
  { word: 'Colonel', phonetic: 'KER-nul', hint: 'It sounds nothing like it looks.' },
  { word: 'February', phonetic: 'FEB-roo-air-ee', hint: 'Don\'t skip the first r.' },
  { word: 'Library', phonetic: 'LY-brer-ee', hint: 'Two r sounds, not one.' },
  { word: 'Pronunciation', phonetic: 'pro-NUN-see-AY-shun', hint: 'No "noun" in pronunciation.' },
  { word: 'Vegetable', phonetic: 'VEJ-tuh-bul', hint: 'Three syllables in casual speech.' },
  { word: 'Temperature', phonetic: 'TEM-pruh-chur', hint: 'Three syllables, not four.' },
  { word: 'Entrepreneur', phonetic: 'on-truh-pruh-NUR', hint: 'French origin, stress the last syllable.' },
  { word: 'Specifically', phonetic: 'spuh-SIF-ik-lee', hint: 'Stress the second syllable.' },
  { word: 'Refrigerator', phonetic: 'rih-FRIJ-uh-ray-ter', hint: 'Five syllables with stress on the second.' },
  { word: 'Architecture', phonetic: 'AR-kih-tek-chur', hint: 'Hard k sound, not ch.' },
  { word: 'Hierarchy', phonetic: 'HY-uh-rar-kee', hint: 'Four syllables.' },
  { word: 'Miscellaneous', phonetic: 'mis-uh-LAY-nee-us', hint: 'Stress on the third syllable.' },
];

const OPPOSITES = [
  { word: 'Hot', answer: 'Cold', hint: 'Think about temperature.' },
  { word: 'Light', answer: 'Dark', hint: 'Think about brightness.' },
  { word: 'Fast', answer: 'Slow', hint: 'Think about speed.' },
  { word: 'Big', answer: 'Small', hint: 'Think about size.' },
  { word: 'Happy', answer: 'Sad', hint: 'Think about emotions.' },
  { word: 'Young', answer: 'Old', hint: 'Think about age.' },
  { word: 'Rich', answer: 'Poor', hint: 'Think about wealth.' },
  { word: 'Strict', answer: 'Lenient', hint: 'The opposite of rigid rules.' },
  { word: 'Ancient', answer: 'Modern', hint: 'Think about time periods.' },
  { word: 'Generous', answer: 'Stingy', hint: 'Think about giving.' },
  { word: 'Brave', answer: 'Cowardly', hint: 'Think about courage.' },
  { word: 'Noisy', answer: 'Quiet', hint: 'Think about sound levels.' },
  { word: 'Smooth', answer: 'Rough', hint: 'Think about texture.' },
  { word: 'Shallow', answer: 'Deep', hint: 'Think about water depth.' },
  { word: 'Temporary', answer: 'Permanent', hint: 'Think about duration.' },
];

const EXPRESSIONS = [
  { expr: 'Beat around the bush', meaning: 'To avoid the main topic.', sample: 'Don\'t beat around the bush, just tell me the truth.', hint: 'It means avoiding the point.' },
  { expr: 'Break the ice', meaning: 'To initiate social interaction.', sample: 'She told a joke to break the ice at the party.', hint: 'Starting a conversation.' },
  { expr: 'Hit the nail on the head', meaning: 'To be exactly right.', sample: 'You hit the nail on the head with your analysis.', hint: 'Being perfectly accurate.' },
  { expr: 'Under the weather', meaning: 'Feeling sick.', sample: 'I am feeling under the weather today so I will stay home.', hint: 'Related to health.' },
  { expr: 'Piece of cake', meaning: 'Very easy.', sample: 'The test was a piece of cake. I finished in ten minutes.', hint: 'Something effortless.' },
  { expr: 'Cost an arm and a leg', meaning: 'Very expensive.', sample: 'That designer bag costs an arm and a leg.', hint: 'Related to price.' },
  { expr: 'Bite the bullet', meaning: 'To face something difficult.', sample: 'I decided to bite the bullet and ask for a raise.', hint: 'Facing a challenge bravely.' },
  { expr: 'Burning the midnight oil', meaning: 'Working late at night.', sample: 'She was burning the midnight oil to finish her thesis.', hint: 'Staying up late to work.' },
  { expr: 'Let the cat out of the bag', meaning: 'To reveal a secret.', sample: 'He let the cat out of the bag about the surprise party.', hint: 'Accidentally sharing a secret.' },
  { expr: 'Back to square one', meaning: 'Starting over again.', sample: 'The project failed, so we are back to square one.', hint: 'Returning to the beginning.' },
  { expr: 'On the same page', meaning: 'In agreement.', sample: 'Let us make sure we are on the same page before we proceed.', hint: 'Mutual understanding.' },
  { expr: 'The ball is in your court', meaning: 'It is your turn to act.', sample: 'I have made my offer. The ball is in your court now.', hint: 'Your decision or move next.' },
  { expr: 'Spill the beans', meaning: 'To reveal secret information.', sample: 'Come on, spill the beans! What happened at the meeting?', hint: 'Telling a secret.' },
  { expr: 'Once in a blue moon', meaning: 'Very rarely.', sample: 'He visits his hometown once in a blue moon.', hint: 'Something that almost never happens.' },
  { expr: 'A blessing in disguise', meaning: 'Something good from a bad situation.', sample: 'Losing that job was a blessing in disguise.', hint: 'A hidden positive outcome.' },
];

// ─── GENERATOR FUNCTIONS ─────────────────────────────────────────────────────

function getDifficulty(level) {
  if (level <= 30) return Math.ceil(level / 3);
  if (level <= 60) return 10 + Math.ceil((level - 30) / 3);
  if (level <= 100) return 20 + Math.ceil((level - 60) / 4);
  if (level <= 150) return 30 + Math.ceil((level - 100) / 5);
  return 40 + Math.ceil((level - 150) / 5);
}

function generateSpeakMissingWord(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % MISSING_WORDS.length;
  const base = MISSING_WORDS[idx];
  // Make sentences progressively harder
  const difficulty = getDifficulty(level);
  return {
    id: `smw_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Speak the word that completes the sentence.',
    difficulty,
    subtype: 'speakMissingWord',
    interactionType: 'speech',
    textToSpeak: base.sentence,
    missingWord: base.word,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateSituationSpeaking(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % SITUATIONS.length;
  const base = SITUATIONS[idx];
  return {
    id: `ss_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'How would you respond in this situation?',
    difficulty: getDifficulty(level),
    subtype: 'situationSpeaking',
    interactionType: 'speech',
    situationText: base.text,
    sampleAnswer: base.sample,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateSceneDescription(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % SCENE_KEYWORDS.length;
  const base = SCENE_KEYWORDS[idx];
  return {
    id: `sds_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Describe the scene in detail.',
    difficulty: getDifficulty(level),
    subtype: 'sceneDescriptionSpeaking',
    interactionType: 'speech',
    sceneText: base.scene,
    keywords: base.keywords,
    hint: `Try to use all three keywords: ${base.keywords.join(', ')}.`,
    xpReward: 10,
    coinReward: 10
  };
}

function generateYesNo(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % YES_NO_QUESTIONS.length;
  const base = YES_NO_QUESTIONS[idx];
  return {
    id: `yns_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Answer with Yes/No and explain.',
    difficulty: getDifficulty(level),
    subtype: 'yesNoSpeaking',
    interactionType: 'speech',
    question: base.q,
    correctAnswer: base.a,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateSpeakSynonym(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % SYNONYMS.length;
  const base = SYNONYMS[idx];
  return {
    id: `ssyn_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Say a synonym for the highlighted word.',
    difficulty: getDifficulty(level),
    subtype: 'speakSynonym',
    interactionType: 'speech',
    word: base.word,
    acceptedSynonyms: base.accepted,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateDialogueRoleplay(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % DIALOGUE_LINES.length;
  const base = DIALOGUE_LINES[idx];
  return {
    id: `dr_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Respond to the speaker naturally.',
    difficulty: getDifficulty(level),
    subtype: 'dialogueRoleplay',
    interactionType: 'speech',
    lastLine: base.last,
    sampleAnswer: base.sample,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generatePronunciationFocus(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % PRONUNCIATION_WORDS.length;
  const base = PRONUNCIATION_WORDS[idx];
  return {
    id: `pf_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Focus on syllable stress and speak.',
    difficulty: getDifficulty(level),
    subtype: 'pronunciationFocus',
    interactionType: 'speech',
    word: base.word,
    phoneticHint: base.phonetic,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateSpeakOpposite(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % OPPOSITES.length;
  const base = OPPOSITES[idx];
  return {
    id: `so_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Speak the antonym for this word.',
    difficulty: getDifficulty(level),
    subtype: 'speakOpposite',
    interactionType: 'speech',
    word: base.word,
    correctAnswer: base.answer,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

function generateDailyExpression(level, item) {
  const idx = ((level - 1) * 3 + (item - 1)) % EXPRESSIONS.length;
  const base = EXPRESSIONS[idx];
  return {
    id: `de_L${String(level).padStart(3,'0')}_${String(item).padStart(2,'0')}`,
    instruction: 'Use this expression in a sentence.',
    difficulty: getDifficulty(level),
    subtype: 'dailyExpression',
    interactionType: 'speech',
    expression: base.expr,
    meaning: base.meaning,
    sampleAnswer: base.sample,
    hint: base.hint,
    xpReward: 10,
    coinReward: 10
  };
}

// ─── SECTION BUILDER ─────────────────────────────────────────────────────────

function buildSection(sectionNum, generatorFn) {
  const ITEMS_PER_LEVEL = 3;
  let startLevel, endLevel;
  
  if (sectionNum <= 6) {
    startLevel = (sectionNum - 1) * 30 + 1;
    endLevel = sectionNum * 30;
  } else {
    startLevel = 181;
    endLevel = 200;
  }

  const quests = [];
  for (let level = startLevel; level <= endLevel; level++) {
    for (let item = 1; item <= ITEMS_PER_LEVEL; item++) {
      quests.push(generatorFn(level, item));
    }
  }
  return { quests };
}

// ─── FILE WRITER ─────────────────────────────────────────────────────────────

function writeGameFiles(category, gameName, generatorFn) {
  const dir = path.join(BASE, category);
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

  for (let s = 1; s <= 7; s++) {
    const data = buildSection(s, generatorFn);
    const filename = `${gameName}_s${s}.json`;
    const filepath = path.join(dir, filename);
    fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
    console.log(`✅ ${filepath} (${data.quests.length} items)`);
  }
}

// ─── MAIN ────────────────────────────────────────────────────────────────────

const PHASE = process.argv[2] || 'speaking';

if (PHASE === 'speaking' || PHASE === 'all') {
  console.log('\n🎤 Phase 1: SPEAKING GAMES\n');
  writeGameFiles('speaking', 'speak_missing_word', generateSpeakMissingWord);
  writeGameFiles('speaking', 'situation_speaking', generateSituationSpeaking);
  writeGameFiles('speaking', 'scene_description_speaking', generateSceneDescription);
  writeGameFiles('speaking', 'yes_no_speaking', generateYesNo);
  writeGameFiles('speaking', 'speak_synonym', generateSpeakSynonym);
  writeGameFiles('speaking', 'dialogue_roleplay', generateDialogueRoleplay);
  writeGameFiles('speaking', 'pronunciation_focus', generatePronunciationFocus);
  writeGameFiles('speaking', 'speak_opposite', generateSpeakOpposite);
  writeGameFiles('speaking', 'daily_expression', generateDailyExpression);
}

console.log('\n✅ Generation complete!\n');
