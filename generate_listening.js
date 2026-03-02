/**
 * Phase 2: Listening Games Curriculum Generator
 * 10 games × 7 sections × (90 or 60 items) = 70 files
 */
const fs = require('fs');
const path = require('path');
const BASE = path.join(__dirname, 'assets', 'curriculum', 'listening');
if (!fs.existsSync(BASE)) fs.mkdirSync(BASE, { recursive: true });

function getDifficulty(level) {
  if (level <= 30) return Math.ceil(level / 3);
  if (level <= 60) return 10 + Math.ceil((level - 30) / 3);
  if (level <= 100) return 20 + Math.ceil((level - 60) / 4);
  if (level <= 150) return 30 + Math.ceil((level - 100) / 5);
  return 40 + Math.ceil((level - 150) / 5);
}

// ─── CONTENT BANKS ───────────────────────────────────────────────────────────

const FILL_BLANKS = [
  { text: 'She sells seashells by the ___.', word: 'seashore', hint: "It's near the ocean." },
  { text: 'The early bird catches the ___.', word: 'worm', hint: 'Something birds eat.' },
  { text: 'Actions speak louder than ___.', word: 'words', hint: 'What you say.' },
  { text: 'Every cloud has a silver ___.', word: 'lining', hint: 'Something positive inside.' },
  { text: 'A journey of a thousand miles begins with a single ___.', word: 'step', hint: 'A movement of your foot.' },
  { text: 'The pen is mightier than the ___.', word: 'sword', hint: 'A weapon.' },
  { text: 'Practice makes ___.', word: 'perfect', hint: 'The best result.' },
  { text: 'Rome was not built in a ___.', word: 'day', hint: 'A unit of time.' },
  { text: 'Knowledge is ___.', word: 'power', hint: 'Strength or ability.' },
  { text: 'Time heals all ___.', word: 'wounds', hint: 'Injuries or hurts.' },
  { text: 'The doctor prescribed some ___ for the pain.', word: 'medicine', hint: 'Something from a pharmacy.' },
  { text: 'Please turn off the ___ when you leave.', word: 'lights', hint: 'They illuminate a room.' },
  { text: 'The children played in the ___ all afternoon.', word: 'garden', hint: 'An outdoor area with plants.' },
  { text: 'She always drinks ___ with breakfast.', word: 'juice', hint: 'A drink from fruits.' },
  { text: 'The flight departs from ___ number five.', word: 'gate', hint: 'An entry point at airports.' },
  { text: 'He forgot his ___ at home today.', word: 'wallet', hint: 'Holds money and cards.' },
  { text: 'The train arrives at ___ sharp.', word: 'noon', hint: 'Twelve o\'clock midday.' },
  { text: 'We need to buy ___ for the party.', word: 'decorations', hint: 'Things that make a place festive.' },
  { text: 'The ___ is the largest organ in the body.', word: 'skin', hint: 'It covers your entire body.' },
  { text: 'Mount Everest is the tallest ___ in the world.', word: 'mountain', hint: 'A very high landform.' },
];

const MULTI_CHOICE = [
  { text: "I'm heading to the grocery store to get some milk and bread.", q: "What is the speaker's main point?", opts: ['Buying groceries', 'Going to work', 'Visiting a friend', 'Baking bread'], ans: 0, hint: 'Listen for specific items.' },
  { text: 'The meeting has been rescheduled to three PM on Thursday.', q: 'When is the meeting?', opts: ['Monday', 'Wednesday', 'Thursday at 3 PM', 'Friday morning'], ans: 2, hint: 'Focus on the day and time.' },
  { text: 'I cannot come to the party because I have an exam tomorrow.', q: 'Why is the speaker unavailable?', opts: ['They are sick', 'They have an exam', 'They are traveling', 'They forgot'], ans: 1, hint: 'Listen for the reason word.' },
  { text: 'The library closes at nine PM on weekdays and six PM on weekends.', q: 'When does the library close on Saturday?', opts: ['5 PM', '6 PM', '8 PM', '9 PM'], ans: 1, hint: 'Saturday is a weekend day.' },
  { text: 'She studied biology in college and now works at a hospital.', q: 'What is her profession likely?', opts: ['Teacher', 'Doctor or nurse', 'Engineer', 'Lawyer'], ans: 1, hint: 'Biology relates to health.' },
  { text: 'The restaurant is fully booked tonight but has openings tomorrow.', q: 'Can you eat there tonight?', opts: ['Yes, anytime', 'No, it is full', 'Only at lunch', 'Only with reservation'], ans: 1, hint: 'Listen for "fully booked".' },
  { text: 'Please take the second left and the building will be on your right.', q: 'Where is the building?', opts: ['First left', 'Second left then right side', 'Straight ahead', 'Behind you'], ans: 1, hint: 'Follow the directions step by step.' },
  { text: 'The temperature will drop to minus five degrees tonight with heavy snowfall.', q: 'What is the weather forecast?', opts: ['Warm and sunny', 'Rainy', 'Very cold with snow', 'Windy but clear'], ans: 2, hint: 'Listen for temperature and conditions.' },
  { text: 'I have been learning Spanish for three years and can now hold conversations.', q: 'How long has the speaker studied Spanish?', opts: ['One year', 'Two years', 'Three years', 'Five years'], ans: 2, hint: 'Focus on the number.' },
  { text: 'The concert starts at eight but we should arrive by seven thirty to get good seats.', q: 'What time should they arrive?', opts: ['7:00', '7:30', '8:00', '8:30'], ans: 1, hint: 'Listen for the suggested arrival time.' },
  { text: 'After the accident, traffic was diverted through Oak Street.', q: 'Why was traffic diverted?', opts: ['Construction', 'An accident', 'A parade', 'Road repair'], ans: 1, hint: 'Listen for what happened first.' },
  { text: 'The new policy requires all employees to submit weekly reports by Friday.', q: 'When are reports due?', opts: ['Monday', 'Wednesday', 'Friday', 'Daily'], ans: 2, hint: 'Listen for the day of the week.' },
  { text: 'She ordered a vegetarian pizza with extra mushrooms and no olives.', q: 'What did she NOT want?', opts: ['Mushrooms', 'Cheese', 'Olives', 'Peppers'], ans: 2, hint: 'Listen for the word "no".' },
  { text: 'The museum is free on the first Sunday of every month.', q: 'When is the museum free?', opts: ['Every Sunday', 'First Sunday monthly', 'Weekdays only', 'Never'], ans: 1, hint: 'Listen for "first" and "every month".' },
  { text: 'Due to the storm, all afternoon flights have been cancelled.', q: 'What happened to the flights?', opts: ['Delayed 1 hour', 'On time', 'Cancelled', 'Rerouted'], ans: 2, hint: 'Listen for the outcome.' },
];

const SENTENCE_ORDER = [
  { text: 'The weather is beautiful today.', shuffled: ['beautiful', 'weather', 'The', 'today.', 'is'], order: [2, 1, 4, 0, 3], hint: 'Start with the article.' },
  { text: 'She walked to the park.', shuffled: ['the', 'walked', 'park.', 'She', 'to'], order: [3, 1, 4, 0, 2], hint: 'Start with the subject.' },
  { text: 'I have finished my homework.', shuffled: ['homework.', 'finished', 'I', 'my', 'have'], order: [2, 4, 1, 3, 0], hint: 'Use present perfect tense.' },
  { text: 'They are going to the cinema tonight.', shuffled: ['tonight.', 'cinema', 'going', 'They', 'the', 'are', 'to'], order: [3, 5, 2, 6, 4, 1, 0], hint: 'Subject first, then verb.' },
  { text: 'The cat sat on the mat.', shuffled: ['mat.', 'on', 'The', 'sat', 'cat', 'the'], order: [2, 4, 3, 1, 5, 0], hint: 'A classic simple sentence.' },
  { text: 'We should leave before sunset.', shuffled: ['sunset.', 'should', 'We', 'before', 'leave'], order: [2, 1, 4, 3, 0], hint: 'Modal verb after subject.' },
  { text: 'He quickly ran across the field.', shuffled: ['field.', 'across', 'quickly', 'He', 'the', 'ran'], order: [3, 2, 5, 1, 4, 0], hint: 'Adverb before the verb.' },
  { text: 'My mother bakes delicious cakes.', shuffled: ['cakes.', 'delicious', 'mother', 'My', 'bakes'], order: [3, 2, 4, 1, 0], hint: 'Possessive pronoun first.' },
  { text: 'The children laughed and played outside.', shuffled: ['played', 'outside.', 'children', 'and', 'The', 'laughed'], order: [4, 2, 5, 3, 0, 1], hint: 'Two verbs connected by "and".' },
  { text: 'She will visit her grandmother tomorrow.', shuffled: ['grandmother', 'tomorrow.', 'She', 'visit', 'will', 'her'], order: [2, 4, 3, 5, 0, 1], hint: 'Future tense with "will".' },
];

const TRUE_FALSE = [
  { text: 'I usually drink coffee in the morning, but today I have tea.', q: 'The speaker is drinking coffee today.', opts: ['True', 'False'], ans: 1, hint: "Listen for the word 'but'." },
  { text: 'The store opens at nine AM and closes at ten PM every day.', q: 'The store is open for thirteen hours.', opts: ['True', 'False'], ans: 0, hint: 'Calculate the difference.' },
  { text: 'She has three cats and two dogs.', q: 'She has more dogs than cats.', opts: ['True', 'False'], ans: 1, hint: 'Compare the numbers.' },
  { text: 'The project is due next Monday, not this Friday.', q: 'The deadline is this Friday.', opts: ['True', 'False'], ans: 1, hint: "Listen for 'not'." },
  { text: 'He was born in London but grew up in New York.', q: 'He grew up in London.', opts: ['True', 'False'], ans: 1, hint: "Listen for 'but' to find the contrast." },
  { text: 'The exam covers chapters one through five, excluding chapter three.', q: 'Chapter three is on the exam.', opts: ['True', 'False'], ans: 1, hint: "Listen for 'excluding'." },
  { text: 'We arrived at the airport two hours before our flight departed.', q: 'They arrived early for their flight.', opts: ['True', 'False'], ans: 0, hint: 'Two hours before means early.' },
  { text: 'The restaurant serves Italian and Japanese cuisine.', q: 'You can get sushi there.', opts: ['True', 'False'], ans: 0, hint: 'Sushi is Japanese food.' },
  { text: 'It rained all morning, but the afternoon was sunny.', q: 'The whole day was rainy.', opts: ['True', 'False'], ans: 1, hint: "Listen for the time distinction." },
  { text: 'The package weighs exactly two kilograms.', q: 'The package is heavier than three kilograms.', opts: ['True', 'False'], ans: 1, hint: 'Compare two and three.' },
  { text: 'She speaks French, Spanish, and a little German.', q: 'She is fluent in German.', opts: ['True', 'False'], ans: 1, hint: "Listen for 'a little'." },
  { text: 'The museum is free for children under twelve.', q: 'A ten year old pays to enter.', opts: ['True', 'False'], ans: 1, hint: 'Ten is under twelve.' },
];

const WORD_MATCH = [
  { text: 'Specific', opts: ['Specific', 'Pacific', 'Scientific', 'Terrific'], ans: 0, hint: "Listen for the 'Sp' sound." },
  { text: 'Accept', opts: ['Except', 'Accept', 'Expect', 'Access'], ans: 1, hint: "Focus on the first vowel." },
  { text: 'Desert', opts: ['Dessert', 'Desert', 'Desire', 'Design'], ans: 1, hint: 'One s or two?' },
  { text: 'Weather', opts: ['Whether', 'Weather', 'Wither', 'Whither'], ans: 1, hint: 'Think about climate.' },
  { text: 'Affect', opts: ['Effect', 'Affect', 'Infect', 'Detect'], ans: 1, hint: "The verb form starts with 'a'." },
  { text: 'Complement', opts: ['Compliment', 'Complement', 'Complete', 'Comply'], ans: 1, hint: 'To make complete.' },
  { text: 'Principle', opts: ['Principal', 'Principle', 'Practical', 'Practice'], ans: 1, hint: 'A fundamental truth or rule.' },
  { text: 'Stationary', opts: ['Stationery', 'Stationary', 'Station', 'Static'], ans: 1, hint: 'Not moving.' },
  { text: 'Advice', opts: ['Advise', 'Advice', 'Device', 'Devise'], ans: 1, hint: 'The noun form.' },
  { text: 'Loose', opts: ['Lose', 'Loose', 'Loss', 'Lost'], ans: 1, hint: 'Not tight.' },
  { text: 'Their', opts: ['There', 'Their', "They're", 'Tier'], ans: 1, hint: 'Possessive pronoun.' },
  { text: 'Break', opts: ['Brake', 'Break', 'Brick', 'Brook'], ans: 1, hint: 'To shatter or pause.' },
];

const FAST_SPEECH = [
  { text: "Whatcha gonna do about it?", answer: 'What are you going to do about it?', hint: 'A question about future plans.' },
  { text: "I dunno what happened.", answer: "I don't know what happened.", hint: "Dunno means don't know." },
  { text: "Lemme think about it.", answer: 'Let me think about it.', hint: "Lemme means let me." },
  { text: "Gimme a second.", answer: 'Give me a second.', hint: 'A request for time.' },
  { text: "Wanna grab some lunch?", answer: 'Do you want to grab some lunch?', hint: 'An invitation to eat.' },
  { text: "Shoulda told me earlier.", answer: 'You should have told me earlier.', hint: 'Expressing regret about timing.' },
  { text: "Coulda been worse.", answer: 'It could have been worse.', hint: 'Looking on the bright side.' },
  { text: "Gotta go now.", answer: 'I have got to go now.', hint: 'Expressing urgency to leave.' },
  { text: "Kinda busy right now.", answer: 'I am kind of busy right now.', hint: 'Partially occupied.' },
  { text: "Hafta finish this first.", answer: 'I have to finish this first.', hint: 'Expressing obligation.' },
  { text: "D'ya know where it is?", answer: 'Do you know where it is?', hint: 'Asking about location.' },
  { text: "S'pose we should leave.", answer: 'I suppose we should leave.', hint: 'Suggesting departure.' },
];

const EMOTIONS = [
  { text: "I can't believe this is finally happening!", opts: ['Frustrated', 'Excited', 'Bored', 'Angry'], ans: 1, hint: 'Listen to the rising energy.' },
  { text: "I really don't care anymore.", opts: ['Apathetic', 'Happy', 'Excited', 'Sad'], ans: 0, hint: "Listen for lack of interest." },
  { text: "Oh no, not again...", opts: ['Delighted', 'Anxious', 'Annoyed', 'Calm'], ans: 2, hint: "Repetition causes frustration." },
  { text: 'This is the best day of my life!', opts: ['Angry', 'Sad', 'Overjoyed', 'Confused'], ans: 2, hint: 'Extreme positive emotion.' },
  { text: 'I just found out I lost the job.', opts: ['Thrilled', 'Disappointed', 'Excited', 'Amused'], ans: 1, hint: 'Bad news about work.' },
  { text: "I'm so nervous about tomorrow's presentation.", opts: ['Confident', 'Anxious', 'Relaxed', 'Bored'], ans: 1, hint: 'Upcoming stressful event.' },
  { text: 'Wow, I never expected this surprise!', opts: ['Surprised', 'Angry', 'Sad', 'Tired'], ans: 0, hint: "Listen for 'never expected'." },
  { text: "I wish I hadn't said that to her.", opts: ['Proud', 'Regretful', 'Happy', 'Confused'], ans: 1, hint: "Wishing to undo something." },
  { text: 'Finally, some peace and quiet.', opts: ['Anxious', 'Frustrated', 'Relieved', 'Angry'], ans: 2, hint: 'Satisfaction after waiting.' },
  { text: 'This is completely unacceptable!', opts: ['Happy', 'Outraged', 'Calm', 'Amused'], ans: 1, hint: 'Strong negative reaction.' },
  { text: 'I wonder what will happen next.', opts: ['Bored', 'Curious', 'Angry', 'Sad'], ans: 1, hint: 'Wanting to know more.' },
  { text: 'Thank goodness that is finally over.', opts: ['Relieved', 'Disappointed', 'Excited', 'Scared'], ans: 0, hint: 'End of something stressful.' },
];

const DETAILS = [
  { text: 'The express train to London will depart from platform 4 at 10:15 AM.', q: 'What time does the train leave?', opts: ['10:00 AM', '10:15 AM', '10:45 AM', '11:15 AM'], ans: 1, hint: 'Focus on the numbers.' },
  { text: 'The meeting room is on the third floor, room 307.', q: 'What room number?', opts: ['307', '370', '703', '730'], ans: 0, hint: 'Listen for the room number.' },
  { text: 'Your appointment is scheduled for Tuesday, March 15th at 2 PM.', q: 'What day is the appointment?', opts: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'], ans: 1, hint: 'Focus on the day of the week.' },
  { text: 'The prescription is for 500 milligrams, taken twice daily with food.', q: 'How often should it be taken?', opts: ['Once daily', 'Twice daily', 'Three times', 'Four times'], ans: 1, hint: 'Listen for frequency.' },
  { text: 'Flight BA247 to Paris has been delayed by 45 minutes.', q: 'What is the flight number?', opts: ['BA274', 'BA247', 'BA472', 'BA742'], ans: 1, hint: 'Listen carefully to the digits.' },
  { text: 'The sale starts December 26th and runs until January 3rd.', q: 'When does the sale end?', opts: ['Dec 31', 'Jan 1', 'Jan 3', 'Jan 5'], ans: 2, hint: "Listen for 'until'." },
  { text: 'Please call customer service at 1-800-555-0199.', q: 'What are the last four digits?', opts: ['0199', '0911', '0991', '1099'], ans: 0, hint: 'Focus on the end of the number.' },
  { text: 'The package weighs 3.5 kilograms and measures 40 by 30 centimeters.', q: 'How much does it weigh?', opts: ['3 kg', '3.5 kg', '4 kg', '4.5 kg'], ans: 1, hint: 'Listen for the decimal.' },
  { text: 'Check-in opens at 2 PM and check-out is at 11 AM.', q: 'What time is check-out?', opts: ['10 AM', '11 AM', '12 PM', '2 PM'], ans: 1, hint: 'Focus on check-out, not check-in.' },
  { text: 'The recipe calls for 250 grams of flour and 100 grams of sugar.', q: 'How much flour is needed?', opts: ['100g', '150g', '250g', '350g'], ans: 2, hint: 'Listen for flour specifically.' },
];

const INFERENCE = [
  { text: 'The dark clouds rolled in and the wind began to howl. Sarah reached for her umbrella.', opts: ['It will rain.', 'The sun will come out.', 'Sarah will go swimming.', "It's bedtime."], ans: 0, hint: 'Think about the weather clues.' },
  { text: 'He put on his running shoes, stretched his legs, and started his stopwatch.', opts: ['He will cook dinner.', 'He will go for a run.', 'He will go to sleep.', 'He will read a book.'], ans: 1, hint: 'What activity needs these items?' },
  { text: 'She packed her suitcase, checked her passport, and called a taxi to the airport.', opts: ['She is going to work.', 'She is going shopping.', 'She is traveling somewhere.', 'She is going to school.'], ans: 2, hint: 'Airport means travel.' },
  { text: 'The waiter brought the menu and asked if they would like something to drink first.', opts: ['They are at home.', 'They are at a restaurant.', 'They are at school.', 'They are at a hospital.'], ans: 1, hint: 'Where do waiters work?' },
  { text: 'She studied all night, set three alarms, and laid out her formal clothes.', opts: ['She has a big exam or interview.', 'She is going on vacation.', 'She is having a party.', 'She is going to bed early.'], ans: 0, hint: 'Preparation for something important.' },
  { text: 'The lights dimmed, the audience went quiet, and the curtain slowly rose.', opts: ['A show is about to begin.', 'Everyone is leaving.', 'It is morning.', 'The power went out.'], ans: 0, hint: 'Theater elements.' },
  { text: 'He looked at the flat tire, opened the trunk, and pulled out the spare.', opts: ['He will drive faster.', 'He will change the tire.', 'He will call the police.', 'He will take a bus.'], ans: 1, hint: 'What do you do with a flat tire?' },
  { text: 'The referee blew the whistle, the crowd cheered, and confetti rained down.', opts: ['The game just started.', 'Someone scored.', 'The game ended in celebration.', 'The game was postponed.'], ans: 2, hint: 'Confetti means celebration.' },
];

const AMBIENT = [
  { text: '[Ambient: Sound of waves crashing and seagulls crying]', opts: ['Airport', 'Forest', 'Beach', 'Library'], ans: 2, hint: 'Think of water and birds.' },
  { text: '[Ambient: Clinking of utensils, soft music, quiet conversation]', opts: ['Gym', 'Restaurant', 'School', 'Park'], ans: 1, hint: 'Where do people eat formally?' },
  { text: '[Ambient: Children laughing, swings creaking, dogs barking]', opts: ['Hospital', 'Office', 'Playground', 'Museum'], ans: 2, hint: 'Where children play.' },
  { text: '[Ambient: Pages turning, whispered voices, distant typing]', opts: ['Library', 'Stadium', 'Market', 'Factory'], ans: 0, hint: 'A quiet place with books.' },
  { text: '[Ambient: Engine roaring, tires screeching, crowd cheering]', opts: ['Library', 'Race track', 'Hospital', 'School'], ans: 1, hint: 'Fast vehicles and spectators.' },
  { text: '[Ambient: Cash register beeping, bags rustling, announcements]', opts: ['Park', 'Supermarket', 'Gym', 'Cinema'], ans: 1, hint: 'Where you buy things.' },
  { text: '[Ambient: Rain pattering on windows, thunder rumbling, wind howling]', opts: ['Inside during a storm', 'Beach', 'Sunny park', 'Desert'], ans: 0, hint: 'Bad weather sounds.' },
  { text: '[Ambient: Keyboards clicking, phone ringing, printer humming]', opts: ['Kitchen', 'Office', 'Garden', 'Pool'], ans: 1, hint: 'A professional workspace.' },
  { text: '[Ambient: Applause, microphone feedback, speaker clearing throat]', opts: ['Bedroom', 'Conference hall', 'Kitchen', 'Bathroom'], ans: 1, hint: 'A formal presentation setting.' },
  { text: '[Ambient: Birds chirping, leaves rustling, stream flowing]', opts: ['City center', 'Factory', 'Forest', 'Airport'], ans: 2, hint: 'Natural sounds in nature.' },
];

// ─── GENERATOR FUNCTIONS ─────────────────────────────────────────────────────

const generators = {
  audio_fill_blanks: (l, i) => { const b = FILL_BLANKS[((l-1)*3+(i-1)) % FILL_BLANKS.length]; return { id: `afb_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Type the missing word from the audio.', difficulty: getDifficulty(l), subtype: 'audioFillBlanks', interactionType: 'writing', textToSpeak: b.text, missingWord: b.word, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  audio_multiple_choice: (l, i) => { const b = MULTI_CHOICE[((l-1)*3+(i-1)) % MULTI_CHOICE.length]; return { id: `amc_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: b.q, difficulty: getDifficulty(l), subtype: 'audioMultipleChoice', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  audio_sentence_order: (l, i) => { const b = SENTENCE_ORDER[((l-1)*3+(i-1)) % SENTENCE_ORDER.length]; return { id: `aso_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Arrange the words in the order you heard them.', difficulty: getDifficulty(l), subtype: 'audioSentenceOrder', interactionType: 'sequence', textToSpeak: b.text, shuffledSentences: b.shuffled, correctOrder: b.order, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  audio_true_false: (l, i) => { const b = TRUE_FALSE[((l-1)*3+(i-1)) % TRUE_FALSE.length]; return { id: `atf_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Is the statement True or False?', difficulty: getDifficulty(l), subtype: 'audioTrueFalse', interactionType: 'choice', textToSpeak: b.text, question: b.q, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  sound_image_match: (l, i) => { const b = WORD_MATCH[((l-1)*3+(i-1)) % WORD_MATCH.length]; return { id: `sim_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Select the exact word you hear.', difficulty: getDifficulty(l), subtype: 'soundImageMatch', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  fast_speech_decoder: (l, i) => { const b = FAST_SPEECH[((l-1)*3+(i-1)) % FAST_SPEECH.length]; return { id: `fsd_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Type what the speaker says (Rapid Speech).', difficulty: getDifficulty(l), subtype: 'fastSpeechDecoder', interactionType: 'writing', textToSpeak: b.text, correctAnswer: b.answer, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  emotion_recognition: (l, i) => { const b = EMOTIONS[((l-1)*3+(i-1)) % EMOTIONS.length]; return { id: `er_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'How does the speaker feel?', difficulty: getDifficulty(l), subtype: 'emotionRecognition', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  detail_spotlight: (l, i) => { const b = DETAILS[((l-1)*3+(i-1)) % DETAILS.length]; return { id: `ds_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: b.q, difficulty: getDifficulty(l), subtype: 'detailSpotlight', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  listening_inference: (l, i) => { const b = INFERENCE[((l-1)*3+(i-1)) % INFERENCE.length]; return { id: `li_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'What will likely happen next?', difficulty: getDifficulty(l), subtype: 'listeningInference', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },

  ambient_id: (l, i) => { const b = AMBIENT[((l-1)*3+(i-1)) % AMBIENT.length]; return { id: `aid_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`, instruction: 'Where is this taking place?', difficulty: getDifficulty(l), subtype: 'ambientId', interactionType: 'choice', textToSpeak: b.text, options: b.opts, correctAnswerIndex: b.ans, hint: b.hint, xpReward: 10, coinReward: 10 }; },
};

// ─── BUILD & WRITE ───────────────────────────────────────────────────────────

function buildSection(sectionNum, genFn) {
  let startLevel = sectionNum <= 6 ? (sectionNum - 1) * 30 + 1 : 181;
  let endLevel = sectionNum <= 6 ? sectionNum * 30 : 200;
  const quests = [];
  for (let level = startLevel; level <= endLevel; level++) {
    for (let item = 1; item <= 3; item++) quests.push(genFn(level, item));
  }
  return { quests };
}

console.log('\n🎧 Phase 2: LISTENING GAMES\n');
for (const [name, genFn] of Object.entries(generators)) {
  for (let s = 1; s <= 7; s++) {
    const data = buildSection(s, genFn);
    const filepath = path.join(BASE, `${name}_s${s}.json`);
    fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
    console.log(`✅ ${name}_s${s}.json (${data.quests.length} items)`);
  }
}
console.log('\n✅ Listening generation complete!\n');
