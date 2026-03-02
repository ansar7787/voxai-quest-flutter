/**
 * Phase 3: Reading Games + Phase 4: Writing Games Curriculum Generator
 * 20 games × 7 sections = 140 files
 */
const fs = require('fs');
const path = require('path');
function mkDir(d) { if (!fs.existsSync(d)) fs.mkdirSync(d, { recursive: true }); }
function getDifficulty(l) { if(l<=30) return Math.ceil(l/3); if(l<=60) return 10+Math.ceil((l-30)/3); if(l<=100) return 20+Math.ceil((l-60)/4); if(l<=150) return 30+Math.ceil((l-100)/5); return 40+Math.ceil((l-150)/5); }

// ─── READING CONTENT ─────────────────────────────────────────────────────────
const READ_ANSWER = [
  { p: 'John went to the store to buy apples and milk.', q: 'What did John buy?', opts: ['Apples and milk', 'Oranges', 'Bread', 'Fish'], ans: 0, hint: 'The answer is in the sentence.' },
  { p: 'The Great Wall of China is over 13,000 miles long and was built over many centuries.', q: 'How long is the Great Wall?', opts: ['5,000 miles', '13,000 miles', '20,000 miles', '1,000 miles'], ans: 1, hint: 'Look for the number.' },
  { p: 'Bees are essential pollinators. Without them, many crops would fail to produce fruit.', q: 'Why are bees important?', opts: ['They make honey', 'They pollinate crops', 'They are colorful', 'They fly fast'], ans: 1, hint: "Look for the word 'essential'." },
  { p: 'The Amazon rainforest produces about 20 percent of the world oxygen.', q: 'What percentage of oxygen comes from the Amazon?', opts: ['10%', '20%', '30%', '50%'], ans: 1, hint: 'Find the percentage.' },
  { p: 'Marie Curie was the first woman to win a Nobel Prize, awarded in 1903 for physics.', q: 'When did Curie win her first Nobel?', opts: ['1901', '1903', '1910', '1920'], ans: 1, hint: 'Find the year.' },
  { p: 'The human body contains about 206 bones. Babies are born with approximately 270 bones.', q: 'How many bones do adults have?', opts: ['150', '206', '270', '300'], ans: 1, hint: 'Focus on adult information.' },
  { p: 'Photosynthesis is the process by which plants convert sunlight into energy.', q: 'What do plants convert into energy?', opts: ['Water', 'Soil', 'Sunlight', 'Air'], ans: 2, hint: "Look for 'convert'." },
  { p: 'The Eiffel Tower stands 330 meters tall and attracts nearly 7 million visitors each year.', q: 'How many visitors does the Eiffel Tower get yearly?', opts: ['3 million', '5 million', '7 million', '10 million'], ans: 2, hint: 'Find the visitor number.' },
  { p: 'Dolphins are highly intelligent mammals that live in the ocean and communicate using clicks.', q: 'How do dolphins communicate?', opts: ['By singing', 'Using clicks', 'Through dance', 'With colors'], ans: 1, hint: "Look for 'communicate'." },
  { p: 'The library hosts a free reading program every Saturday from 10 AM to noon for children.', q: 'When is the reading program?', opts: ['Monday', 'Wednesday', 'Friday', 'Saturday'], ans: 3, hint: 'Find the day.' },
];

const WORD_MEANING = [
  { p: 'The traveler was weary after the long journey.', w: 'weary', opts: ['Tired', 'Excited', 'Happy', 'Angry'], ans: 0, hint: 'How someone feels after a long walk.' },
  { p: 'The politician gave an eloquent speech that moved the audience.', w: 'eloquent', opts: ['Loud', 'Confusing', 'Persuasive and fluent', 'Short'], ans: 2, hint: 'It moved the audience.' },
  { p: 'The frugal shopper always looked for the best deals.', w: 'frugal', opts: ['Wasteful', 'Economical', 'Lazy', 'Rich'], ans: 1, hint: 'Related to saving money.' },
  { p: 'Her benevolent nature made her loved by everyone.', w: 'benevolent', opts: ['Cruel', 'Kind and generous', 'Strict', 'Shy'], ans: 1, hint: 'Everyone loved her for it.' },
  { p: 'The dilapidated barn was about to collapse.', w: 'dilapidated', opts: ['New', 'Colorful', 'In ruins', 'Expensive'], ans: 2, hint: 'About to collapse.' },
  { p: 'His meticulous attention to detail earned him a promotion.', w: 'meticulous', opts: ['Careless', 'Very careful', 'Quick', 'Lazy'], ans: 1, hint: 'Attention to detail.' },
  { p: 'The ubiquitous smartphones have changed modern life.', w: 'ubiquitous', opts: ['Rare', 'Everywhere', 'Expensive', 'Old'], ans: 1, hint: 'Everyone has one.' },
  { p: 'The child showed remarkable resilience after the setback.', w: 'resilience', opts: ['Weakness', 'Ability to recover', 'Fear', 'Anger'], ans: 1, hint: 'Bouncing back from difficulty.' },
  { p: 'The pristine beach had crystal clear water and white sand.', w: 'pristine', opts: ['Dirty', 'Crowded', 'Clean and unspoiled', 'Dark'], ans: 2, hint: 'Crystal clear suggests purity.' },
  { p: 'The pragmatic approach saved the company millions.', w: 'pragmatic', opts: ['Theoretical', 'Practical', 'Emotional', 'Random'], ans: 1, hint: 'It saved money by being sensible.' },
];

const TF_READING = [
  { p: 'London is the capital of the United Kingdom.', q: 'Paris is the capital of the UK.', opts: ['True', 'False'], ans: 1, hint: 'Check the city names.' },
  { p: 'Water freezes at zero degrees Celsius.', q: 'Water freezes at zero degrees.', opts: ['True', 'False'], ans: 0, hint: 'A basic science fact.' },
  { p: 'The Pacific Ocean is the largest ocean on Earth.', q: 'The Atlantic is the largest ocean.', opts: ['True', 'False'], ans: 1, hint: 'Compare ocean names.' },
  { p: 'Penguins are birds that cannot fly but are excellent swimmers.', q: 'Penguins can fly.', opts: ['True', 'False'], ans: 1, hint: "Look for 'cannot fly'." },
  { p: 'Shakespeare wrote Romeo and Juliet in the late 16th century.', q: 'Shakespeare wrote Romeo and Juliet.', opts: ['True', 'False'], ans: 0, hint: 'Direct information.' },
  { p: 'The human heart beats about 100,000 times per day.', q: 'The heart beats 50,000 times daily.', opts: ['True', 'False'], ans: 1, hint: 'Compare the numbers.' },
  { p: 'Mount Everest is located on the border of Nepal and Tibet.', q: 'Mount Everest is in Africa.', opts: ['True', 'False'], ans: 1, hint: 'Check the location.' },
  { p: 'Honey never spoils and has been found in ancient Egyptian tombs.', q: 'Honey can last thousands of years.', opts: ['True', 'False'], ans: 0, hint: "Never spoils means it lasts." },
  { p: 'Venus is the hottest planet in our solar system despite Mercury being closer to the Sun.', q: 'Mercury is the hottest planet.', opts: ['True', 'False'], ans: 1, hint: "Look for 'despite'." },
  { p: 'Octopuses have three hearts and blue blood.', q: 'Octopuses have one heart.', opts: ['True', 'False'], ans: 1, hint: 'Count the hearts.' },
];

const SENT_ORDER = [
  { shuffled: ['He ate dinner.', 'Then he went to bed.', 'John came home at 6 PM.'], order: [2, 0, 1], hint: 'Look for time indicators.' },
  { shuffled: ['She opened her umbrella.', 'It started to rain.', 'She walked to the bus stop.'], order: [2, 1, 0], hint: 'What happens first logically?' },
  { shuffled: ['The alarm went off.', 'He got dressed.', 'He woke up immediately.'], order: [0, 2, 1], hint: 'Morning routine order.' },
  { shuffled: ['They ordered food.', 'They arrived at the restaurant.', 'They paid the bill.', 'They enjoyed their meal.'], order: [1, 0, 3, 2], hint: 'Restaurant event sequence.' },
  { shuffled: ['The plane landed safely.', 'Passengers boarded the plane.', 'The pilot announced turbulence.'], order: [1, 2, 0], hint: 'Flight timeline.' },
  { shuffled: ['He scored the winning goal.', 'The team celebrated.', 'The match was tied.'], order: [2, 0, 1], hint: 'Sports event order.' },
  { shuffled: ['She graduated with honors.', 'She applied to college.', 'She studied for four years.'], order: [1, 2, 0], hint: 'Education timeline.' },
  { shuffled: ['The seeds sprouted.', 'She planted the seeds.', 'She watered them daily.', 'Beautiful flowers bloomed.'], order: [1, 2, 0, 3], hint: 'Growing process.' },
];

const SPEED_CHECK = [
  { p: 'Global warming is causing glaciers to melt at an unprecedented rate. Scientists warn that sea levels could rise significantly by the end of the century.', opts: ['Environmental issues', 'Sports', 'Cooking', 'Space travel'], ans: 0, hint: 'Focus on the first few words.' },
  { p: 'Recent studies show that regular exercise can reduce the risk of heart disease by up to 50 percent.', opts: ['Fashion', 'Health benefits of exercise', 'Cooking', 'History'], ans: 1, hint: 'What is the main subject?' },
  { p: 'The invention of the printing press in the 15th century revolutionized the spread of information.', opts: ['Technology history', 'Cooking recipes', 'Sports', 'Weather'], ans: 0, hint: 'Focus on the key invention.' },
  { p: 'Researchers have discovered a new species of deep-sea fish that produces its own light through bioluminescence.', opts: ['Astronomy', 'Marine biology', 'Agriculture', 'Architecture'], ans: 1, hint: "Look for 'deep-sea fish'." },
  { p: 'The global economy is shifting toward renewable energy sources as fossil fuel reserves continue to decline.', opts: ['Energy economics', 'Fashion', 'Food', 'Sports'], ans: 0, hint: 'What is changing globally?' },
  { p: 'A balanced diet including fruits, vegetables, whole grains, and lean proteins supports overall health.', opts: ['Nutrition', 'Technology', 'Travel', 'Music'], ans: 0, hint: 'What foods are mentioned?' },
  { p: 'Ancient Roman aqueducts were engineering marvels that transported water over long distances using gravity.', opts: ['Modern computing', 'Roman engineering', 'Space travel', 'Marine biology'], ans: 1, hint: 'Focus on the civilization mentioned.' },
  { p: 'Sleep deprivation can impair cognitive function, mood, and immune response in significant ways.', opts: ['Sleep and health', 'Cooking', 'Sports', 'Geography'], ans: 0, hint: 'What is being deprived?' },
];

const GUESS_TITLE = [
  { p: 'A small dog rescued a child from a burning building today in New York. The heroic pet alerted neighbors.', opts: ['Heroic Pet Saves Child', 'Cooking Tips', 'Weather Report', 'Stock Market'], ans: 0, hint: 'What is the story about?' },
  { p: 'Scientists have confirmed that a massive asteroid will pass safely by Earth next month, posing no danger.', opts: ['Asteroid Flyby', 'Recipe Guide', 'Fashion Show', 'Music Festival'], ans: 0, hint: "Focus on 'asteroid' and 'Earth'." },
  { p: 'A new study reveals that reading for just 30 minutes a day can significantly reduce stress levels.', opts: ['Reading Reduces Stress', 'Car Reviews', 'Sports Results', 'Weather Forecast'], ans: 0, hint: 'What is the benefit described?' },
  { p: 'The world oldest person celebrated her 117th birthday with five generations of family members.', opts: ['Record-Breaking Birthday', 'Technology News', 'Sports Update', 'Travel Guide'], ans: 0, hint: 'What event is being celebrated?' },
  { p: 'Electric vehicles now account for over 15 percent of new car sales globally as prices continue to drop.', opts: ['EV Market Growth', 'Cooking Trends', 'Movie Reviews', 'Health Tips'], ans: 0, hint: 'What product is selling more?' },
  { p: 'Volunteering just two hours a week has been shown to improve mental health and social connections.', opts: ['Benefits of Volunteering', 'Stock Prices', 'Weather', 'Sports'], ans: 0, hint: 'What activity is beneficial?' },
  { p: 'A hidden cave system discovered beneath a mountain contains crystal formations millions of years old.', opts: ['Underground Discovery', 'Cooking Show', 'Fashion Week', 'Olympics'], ans: 0, hint: 'What was found?' },
  { p: 'Urban gardens are transforming rooftops in major cities into green spaces that produce fresh food.', opts: ['Urban Farming Revolution', 'Movie reviews', 'Car racing', 'Music charts'], ans: 0, hint: 'What is changing in cities?' },
];

const READ_MATCH = [
  { pairs: [{a:'History',b:'It was founded in 1890 by a group of merchants.'},{a:'Geography',b:'The mountains are to the north and the river runs south.'}], hint: "Look for keywords like 'founded' or 'mountains'." },
  { pairs: [{a:'Diet',b:'Eating fruits and vegetables daily improves health.'},{a:'Exercise',b:'Running thirty minutes a day strengthens the heart.'}], hint: 'Match the topic to the activity.' },
  { pairs: [{a:'Cause',b:'The heavy rain flooded the streets.'},{a:'Effect',b:'Cars were stuck and traffic was delayed for hours.'}], hint: 'What happened and what resulted?' },
  { pairs: [{a:'Problem',b:'Plastic waste is polluting our oceans.'},{a:'Solution',b:'Countries are banning single-use plastics.'}], hint: 'Match the issue to the response.' },
  { pairs: [{a:'Past',b:'Dinosaurs roamed the earth millions of years ago.'},{a:'Present',b:'Today we study their fossils in museums.'}], hint: 'Time period keywords.' },
  { pairs: [{a:'Advantage',b:'Online learning offers flexibility and convenience.'},{a:'Disadvantage',b:'Students may feel isolated without face-to-face contact.'}], hint: 'Positive vs negative.' },
  { pairs: [{a:'Introduction',b:'Climate change is one of the biggest challenges today.'},{a:'Evidence',b:'Global temperatures have risen by 1.1 degrees since 1900.'}], hint: 'General statement vs specific data.' },
  { pairs: [{a:'Opinion',b:'I believe public transport should be free for everyone.'},{a:'Fact',b:'Bus ridership increased by 20 percent last year.'}], hint: "Look for 'I believe' vs numbers." },
];

const PARA_SUMMARY = [
  { p: 'Solar panels convert sunlight into electricity through photovoltaic cells. This technology has become increasingly affordable and is now used in homes, businesses, and large-scale power plants worldwide.', opts: ['Solar energy technology', 'Rainy day activities', 'Tax laws', 'Ancient art'], ans: 0, hint: 'The passage explains a technology.' },
  { p: 'Coral reefs support 25 percent of all marine species despite covering less than 1 percent of the ocean floor. Rising ocean temperatures threaten these vital ecosystems.', opts: ['Importance of coral reefs', 'Desert animals', 'Urban planning', 'Space missions'], ans: 0, hint: 'What ecosystem is discussed?' },
  { p: 'The invention of antibiotics in 1928 transformed medicine. Bacterial infections that were once fatal could now be treated effectively, saving millions of lives.', opts: ['History of antibiotics', 'Cooking methods', 'Sports history', 'Art movements'], ans: 0, hint: 'What medical advance is described?' },
  { p: 'Social media has changed how people communicate. While it connects people globally, concerns about privacy and misinformation have grown significantly.', opts: ['Impact of social media', 'Gardening tips', 'Car repair', 'Ancient history'], ans: 0, hint: 'What technology platform is discussed?' },
  { p: 'Migration patterns of birds are influenced by daylight hours, temperature, and food availability. Some species travel thousands of miles each year.', opts: ['Bird migration', 'Cooking recipes', 'Car maintenance', 'Fashion trends'], ans: 0, hint: 'What animal behavior is described?' },
  { p: 'The Industrial Revolution began in Britain in the late 18th century and spread across Europe. It fundamentally changed manufacturing, transportation, and daily life.', opts: ['The Industrial Revolution', 'Modern art', 'Space exploration', 'Marine biology'], ans: 0, hint: 'A major historical period.' },
];

const READ_INFERENCE = [
  { p: "Despite the 'safety' features, many were still wary of entering the cave.", q: 'The people feel...', opts: ['Unsafe', 'Confident', 'Excited', 'Bored'], ans: 0, hint: "Look at the word 'Despite'." },
  { p: 'He glanced at his watch for the third time and tapped his foot impatiently.', q: 'The man is probably...', opts: ['Relaxed', 'Waiting impatiently', 'Sleeping', 'Reading'], ans: 1, hint: 'What do repeated actions show?' },
  { p: 'She smiled politely but her eyes told a different story.', q: 'She is probably...', opts: ['Genuinely happy', 'Hiding her true feelings', 'Confused', 'Sleeping'], ans: 1, hint: "Her eyes 'told a different story'." },
  { p: "The restaurant had excellent reviews online, but tonight every table was empty.", q: 'This suggests...', opts: ['Something unusual happened', 'The food is great', 'It is always empty', 'It is fully booked'], ans: 0, hint: "Contrast between reviews and reality." },
  { p: "Although he said he wasn't hungry, he kept staring at the pizza.", q: 'He probably...', opts: ['Hates pizza', 'Is actually hungry', 'Is full', 'Is allergic'], ans: 1, hint: "Actions contradict words." },
  { p: 'The once-bustling factory now stood silent, its windows shattered and overgrown with vines.', q: 'The factory is...', opts: ['New', 'Abandoned', 'Busy', 'Under construction'], ans: 1, hint: "Look for signs of neglect." },
  { p: 'Her suitcase was packed, her passport was ready, and she kept checking flight times.', q: 'She is about to...', opts: ['Go to sleep', 'Cook dinner', 'Travel somewhere', 'Go to school'], ans: 2, hint: 'What do these items suggest?' },
  { p: 'The child clutched her teddy bear tightly and hid behind her mother during the thunderstorm.', q: 'The child is feeling...', opts: ['Excited', 'Brave', 'Scared', 'Happy'], ans: 2, hint: 'What does hiding suggest?' },
];

const READ_CONCLUSION = [
  { p: 'The team practiced 10 hours a day for months. They had the best coach and the latest equipment.', opts: ['They were well prepared.', 'They were lazy.', 'They never played.', 'They lost interest.'], ans: 0, hint: 'Does hard work lead to readiness?' },
  { p: 'Despite investing heavily in marketing, the product received poor reviews and sales dropped.', opts: ['The product succeeded', 'Marketing alone cannot save a bad product', 'They did not advertise', 'The price was too low'], ans: 1, hint: 'Good marketing but bad reviews.' },
  { p: 'Countries that invest in education tend to have higher GDP and lower poverty rates.', opts: ['Education hurts economy', 'Education boosts economic growth', 'Education is unnecessary', 'GDP does not matter'], ans: 1, hint: 'What is the connection drawn?' },
  { p: 'The experiment was repeated five times with the same result each time.', opts: ['Results are unreliable', 'Results are consistent and reliable', 'The experiment failed', 'More tests are needed'], ans: 1, hint: 'Consistency suggests reliability.' },
  { p: 'Overuse of antibiotics has led to the rise of drug-resistant bacteria.', opts: ['Antibiotics should be used more', 'Responsible use of antibiotics is important', 'Bacteria are harmless', 'Antibiotics are unnecessary'], ans: 1, hint: 'What is the consequence of overuse?' },
  { p: 'Workers who take regular breaks report higher productivity and lower stress levels.', opts: ['Breaks waste time', 'Breaks improve performance', 'Work without breaks is best', 'Stress is not related to breaks'], ans: 1, hint: 'What do breaks lead to?' },
];

// ─── WRITING CONTENT ─────────────────────────────────────────────────────────
const SENT_BUILDER = [
  { words: ['is', 'apple', 'The', 'red.'], order: [2, 1, 0, 3], hint: "Start with 'The'." },
  { words: ['cats', 'like', 'I', 'very', 'much.'], order: [2, 1, 0, 3, 4], hint: "Subject first." },
  { words: ['to', 'school', 'goes', 'She', 'every', 'day.'], order: [3, 2, 0, 1, 4, 5], hint: "Who performs the action?" },
  { words: ['will', 'tomorrow.', 'rain', 'It'], order: [3, 0, 2, 1], hint: "Weather prediction." },
  { words: ['are', 'delicious.', 'These', 'cookies'], order: [2, 3, 0, 1], hint: "Start with a demonstrative." },
  { words: ['playing', 'in', 'the', 'park.', 'Children', 'are'], order: [4, 5, 0, 1, 2, 3], hint: "Subject + auxiliary + verb." },
  { words: ['has', 'He', 'beautiful', 'a', 'garden.'], order: [1, 0, 3, 2, 4], hint: "Article before adjective." },
  { words: ['quickly.', 'ran', 'The', 'dog', 'very'], order: [2, 3, 1, 4, 0], hint: "Adverb modifies the verb." },
  { words: ['bought', 'She', 'new', 'a', 'dress.'], order: [1, 0, 3, 2, 4], hint: "Past tense action." },
  { words: ['reading', 'enjoys', 'My', 'books.', 'sister'], order: [2, 4, 1, 0, 3], hint: "Possessive + subject." },
];

const COMPLETE_SENT = [
  { p: 'When it rains, you should take an ___.', w: 'umbrella', hint: 'It keeps you dry.' },
  { p: 'The doctor gave me a ___ for my cough.', w: 'prescription', hint: 'A medical document.' },
  { p: 'She put on her ___ before going outside in winter.', w: 'coat', hint: 'Warm outerwear.' },
  { p: 'The students raised their ___ to answer the question.', w: 'hands', hint: 'A body part used to volunteer.' },
  { p: 'He locked the ___ before leaving the house.', w: 'door', hint: 'The entrance to a building.' },
  { p: 'You need a ___ to drive a car legally.', w: 'license', hint: 'An official document.' },
  { p: 'She set her ___ for 6 AM to wake up early.', w: 'alarm', hint: 'A wake-up device.' },
  { p: 'The children played in the ___ during recess.', w: 'playground', hint: 'An area for outdoor games.' },
  { p: 'We planted ___ in the garden last spring.', w: 'seeds', hint: 'What grows into plants.' },
  { p: 'Please pass me the ___ and pepper.', w: 'salt', hint: 'A common seasoning pair.' },
];

const DESC_SIT = [
  { sit: 'A man is waiting for a bus in the rain.', sample: 'A man stands at a bus stop under a gray sky, holding an umbrella.', hint: 'Include the weather.' },
  { sit: 'Two children are building a sandcastle on the beach.', sample: 'Two kids kneel on the sandy shore, carefully shaping towers of wet sand.', hint: 'Describe the action and location.' },
  { sit: 'A woman is reading a book in a cozy cafe.', sample: 'A woman sits by the window of a warm cafe, absorbed in her book with coffee beside her.', hint: 'Include the setting details.' },
  { sit: 'An old man feeding pigeons in the park.', sample: 'An elderly man sits on a park bench, scattering breadcrumbs for a group of eager pigeons.', hint: 'Describe both the person and animals.' },
  { sit: 'Students studying late at the library.', sample: 'Several students sit at long tables surrounded by books, studying under soft lamplight.', hint: 'Mention the time and atmosphere.' },
  { sit: 'A family having a picnic by a lake.', sample: 'A family spreads a blanket beside a calm lake, enjoying sandwiches and laughter.', hint: 'Include the food and emotions.' },
  { sit: 'A dog playing fetch in a field.', sample: 'A golden retriever bounds across a green field, chasing a tennis ball thrown by its owner.', hint: 'Describe the animal and movement.' },
  { sit: 'Traffic jam in a busy city during rush hour.', sample: 'Cars sit bumper to bumper on a wide boulevard as horns honk and pedestrians weave between lanes.', hint: 'Include sounds and movements.' },
];

const FIX_SENT = [
  { wrong: 'He go to school yesterday.', correct: 'He went to school yesterday.', hint: 'Check the past tense.' },
  { wrong: 'She dont like coffee.', correct: "She doesn't like coffee.", hint: 'Third person needs does + not.' },
  { wrong: 'They was playing football.', correct: 'They were playing football.', hint: 'Subject-verb agreement.' },
  { wrong: 'I has two brothers.', correct: 'I have two brothers.', hint: "First person uses 'have'." },
  { wrong: 'The childs are playing outside.', correct: 'The children are playing outside.', hint: 'Irregular plural.' },
  { wrong: 'She can sings very well.', correct: 'She can sing very well.', hint: 'No -s after modal verbs.' },
  { wrong: 'We goed to the park.', correct: 'We went to the park.', hint: "Irregular past tense of 'go'." },
  { wrong: 'Him is my best friend.', correct: 'He is my best friend.', hint: 'Subject pronoun needed.' },
  { wrong: 'I and my friend went shopping.', correct: 'My friend and I went shopping.', hint: 'Others before self.' },
  { wrong: 'She more taller than me.', correct: 'She is taller than me.', hint: 'Remove double comparative.' },
];

const SHORT_ANSWER = [
  { q: 'Why is education important?', s: 'It opens up new opportunities and builds knowledge.', hint: 'Think about future jobs.' },
  { q: 'What is your favorite hobby and why?', s: 'I enjoy reading because it takes me to different worlds.', hint: 'Give a personal reason.' },
  { q: 'How can we help the environment?', s: 'We can reduce waste, recycle, and use public transport.', hint: 'Think of everyday actions.' },
  { q: 'What makes a good friend?', s: 'A good friend is loyal, supportive, and honest.', hint: 'Think of important qualities.' },
  { q: 'Why is exercise important?', s: 'Exercise keeps our body healthy and reduces stress.', hint: 'Think about health benefits.' },
  { q: 'What would you do with a million dollars?', s: 'I would invest in education and help my community.', hint: 'Think long-term.' },
  { q: 'How has technology changed our lives?', s: 'Technology has made communication faster and information more accessible.', hint: 'Think about daily changes.' },
  { q: 'What is the best way to learn a new language?', s: 'Practice daily, watch shows, and speak with native speakers.', hint: 'Think about methods.' },
];

const OPINION = [
  { t: 'Should schools start later in the morning?', s: 'I believe they should, as students need more sleep for better learning.', hint: "Use 'I believe' or 'In my opinion'." },
  { t: 'Is social media good or bad for society?', s: 'In my opinion, it has both benefits and drawbacks that require balance.', hint: 'Consider both sides.' },
  { t: 'Should homework be abolished?', s: 'I think homework should be reduced but not completely removed.', hint: 'Take a moderate stance.' },
  { t: 'Are electric cars better than petrol cars?', s: 'I believe electric cars are better for the environment in the long run.', hint: 'Consider environmental impact.' },
  { t: 'Should everyone learn to code?', s: 'In my view, basic coding literacy is valuable in the modern world.', hint: 'Think about relevance.' },
  { t: 'Is fast food harmful?', s: 'I think occasional fast food is fine, but a regular habit is unhealthy.', hint: 'Consider moderation.' },
];

const JOURNAL = [
  { day: 'A day where you met an old friend by surprise.', s: 'Today I ran into Sarah at the park! It has been years since we last met.', hint: 'Describe how you felt.' },
  { day: 'Your first day at a new school.', s: 'I was so nervous walking through the gates. Everyone seemed to know each other already.', hint: 'Express your emotions.' },
  { day: 'A rainy day spent indoors.', s: 'The rain pattered against the windows all day. I curled up with hot chocolate and a good book.', hint: 'Describe the atmosphere.' },
  { day: 'A day you tried something new.', s: 'I tried rock climbing for the first time. My arms were shaking but the view from the top was incredible.', hint: 'Describe the challenge and reward.' },
  { day: 'A day you helped someone.', s: 'I helped an elderly woman carry her groceries today. Her smile made my entire day.', hint: 'Focus on the impact.' },
  { day: 'A perfect summer day.', s: 'We went to the beach, built sandcastles, and watched the sun set over the water.', hint: 'Use sensory details.' },
];

const SUMMARIZE = [
  { story: 'A brave cat traveled 200 miles across mountains and rivers to find its way back home to its family after being lost during a camping trip.', s: 'A lost cat made an incredible 200-mile journey home across mountains and rivers.', hint: 'Focus on the main action.' },
  { story: 'An old lighthouse keeper discovered a message in a bottle that led him to a hidden treasure on a nearby island, changing his quiet life forever.', s: 'A lighthouse keeper found a treasure map in a bottle that changed his life.', hint: 'What transforms the characters life?' },
  { story: 'A young girl planted a single seed in her backyard. Over twenty years, it grew into a magnificent oak tree that became a landmark in her town.', s: 'A girl planted a seed that grew into a town landmark over twenty years.', hint: 'Beginning and end result.' },
  { story: 'During a blackout, neighbors who had never spoken before gathered in the street with candles and food, forming friendships that lasted years.', s: 'A blackout brought strangers together, creating lasting community friendships.', hint: 'What was the unexpected outcome?' },
  { story: 'A retired teacher started a free tutoring program from her garage. Within five years, over a thousand students had benefited and test scores in her area rose significantly.', s: 'A retired teacher free tutoring program helped over a thousand students succeed.', hint: 'Impact and numbers.' },
];

const EMAIL = [
  { ctx: 'Requesting a meeting with your boss next Tuesday.', s: 'Dear Sir, I would like to request a meeting on Tuesday to discuss the project timeline.', hint: 'Start with a professional greeting.' },
  { ctx: 'Apologizing for missing a deadline.', s: 'Dear Manager, I sincerely apologize for missing the deadline. I will submit the report by tomorrow.', hint: 'Apologize and give a solution.' },
  { ctx: 'Thanking a colleague for covering your shift.', s: 'Hi John, Thank you so much for covering my shift last Friday. I truly appreciate your help.', hint: 'Express genuine gratitude.' },
  { ctx: 'Requesting time off for a family event.', s: 'Dear HR, I would like to request leave from March 10-12 for a family wedding.', hint: 'State the dates and reason.' },
  { ctx: 'Reporting a technical issue to IT support.', s: 'Dear IT Team, My computer has been freezing repeatedly since Monday. Could you please look into this?', hint: 'Describe the problem clearly.' },
  { ctx: 'Following up on a job application.', s: 'Dear Hiring Manager, I am writing to follow up on my application for the Marketing position submitted last week.', hint: 'Reference the position and date.' },
];

const CORRECTION = [
  { wrong: 'I enjoys fish. They lives in water', correct: 'I enjoy fish. They live in water.', hint: 'Check subject-verb agreement.' },
  { wrong: 'The childrens plays in the park every day', correct: 'The children play in the park every day.', hint: 'Irregular plural and verb form.' },
  { wrong: 'She dont have no money', correct: "She doesn't have any money.", hint: 'Fix double negative and contraction.' },
  { wrong: 'Him and me went to store', correct: 'He and I went to the store.', hint: 'Subject pronouns and missing article.' },
  { wrong: 'The books is on the tables.', correct: 'The books are on the table.', hint: 'Subject-verb agreement with plurals.' },
  { wrong: 'We was happy to sees you.', correct: 'We were happy to see you.', hint: 'Past tense plural and infinitive form.' },
  { wrong: 'Their going too the shops.', correct: "They're going to the shops.", hint: "Their/They're and too/to." },
  { wrong: 'She readed the book quick.', correct: 'She read the book quickly.', hint: 'Irregular past tense and adverb form.' },
];

// ─── GENERATOR MAPS ──────────────────────────────────────────────────────────
const readingGens = {
  read_and_answer: (l,i) => { const b=READ_ANSWER[((l-1)*3+(i-1))%READ_ANSWER.length]; return {id:`raa_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Read the text and choose the correct answer.',difficulty:getDifficulty(l),subtype:'readAndAnswer',interactionType:'choice',passage:b.p,question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  find_word_meaning: (l,i) => { const b=WORD_MEANING[((l-1)*3+(i-1))%WORD_MEANING.length]; return {id:`fwm_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Select the best definition for the word.',difficulty:getDifficulty(l),subtype:'findWordMeaning',interactionType:'choice',passage:b.p,word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  true_false_reading: (l,i) => { const b=TF_READING[((l-1)*3+(i-1))%TF_READING.length]; return {id:`tfr_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'True or False?',difficulty:getDifficulty(l),subtype:'trueFalseReading',interactionType:'choice',passage:b.p,question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  sentence_order_reading: (l,i) => { const b=SENT_ORDER[((l-1)*3+(i-1))%SENT_ORDER.length]; return {id:`sor_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Arrange the sentences in order.',difficulty:getDifficulty(l),subtype:'sentenceOrderReading',interactionType:'sequence',shuffledSentences:b.shuffled,correctOrder:b.order,hint:b.hint,xpReward:10,coinReward:10};},
  reading_speed_check: (l,i) => { const b=SPEED_CHECK[((l-1)*3+(i-1))%SPEED_CHECK.length]; return {id:`rsc_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'What is the main topic?',difficulty:getDifficulty(l),subtype:'readingSpeedCheck',interactionType:'choice',passage:b.p,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  guess_title: (l,i) => { const b=GUESS_TITLE[((l-1)*3+(i-1))%GUESS_TITLE.length]; return {id:`gt_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Choose the best title.',difficulty:getDifficulty(l),subtype:'guessTitle',interactionType:'choice',passage:b.p,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  read_and_match: (l,i) => { const b=READ_MATCH[((l-1)*3+(i-1))%READ_MATCH.length]; return {id:`ram_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Match the headings to the paragraphs.',difficulty:getDifficulty(l),subtype:'readAndMatch',interactionType:'match',pairs:b.pairs,hint:b.hint,xpReward:10,coinReward:10};},
  paragraph_summary: (l,i) => { const b=PARA_SUMMARY[((l-1)*3+(i-1))%PARA_SUMMARY.length]; return {id:`ps_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Pick the best summary.',difficulty:getDifficulty(l),subtype:'paragraphSummary',interactionType:'choice',passage:b.p,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  reading_inference: (l,i) => { const b=READ_INFERENCE[((l-1)*3+(i-1))%READ_INFERENCE.length]; return {id:`ri_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'What is implied?',difficulty:getDifficulty(l),subtype:'readingInference',interactionType:'choice',passage:b.p,question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  reading_conclusion: (l,i) => { const b=READ_CONCLUSION[((l-1)*3+(i-1))%READ_CONCLUSION.length]; return {id:`rc_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Select the logical conclusion.',difficulty:getDifficulty(l),subtype:'readingConclusion',interactionType:'choice',passage:b.p,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
};

const writingGens = {
  sentence_builder: (l,i) => { const b=SENT_BUILDER[((l-1)*3+(i-1))%SENT_BUILDER.length]; return {id:`sb_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Build a correct sentence.',difficulty:getDifficulty(l),subtype:'sentenceBuilder',interactionType:'sequence',shuffledWords:b.words,correctOrder:b.order,hint:b.hint,xpReward:10,coinReward:10};},
  complete_sentence: (l,i) => { const b=COMPLETE_SENT[((l-1)*3+(i-1))%COMPLETE_SENT.length]; return {id:`cs_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Type the missing word.',difficulty:getDifficulty(l),subtype:'completeSentence',interactionType:'writing',passage:b.p,missingWord:b.w,hint:b.hint,xpReward:10,coinReward:10};},
  describe_situation_writing: (l,i) => { const b=DESC_SIT[((l-1)*3+(i-1))%DESC_SIT.length]; return {id:`dsw_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Describe what is happening.',difficulty:getDifficulty(l),subtype:'describeSituationWriting',interactionType:'writing',situation:b.sit,sampleAnswer:b.sample,hint:b.hint,xpReward:10,coinReward:10};},
  fix_the_sentence: (l,i) => { const b=FIX_SENT[((l-1)*3+(i-1))%FIX_SENT.length]; return {id:`fts_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Correct the mistake.',difficulty:getDifficulty(l),subtype:'fixTheSentence',interactionType:'writing',wrongSentence:b.wrong,correctSentence:b.correct,hint:b.hint,xpReward:10,coinReward:10};},
  short_answer_writing: (l,i) => { const b=SHORT_ANSWER[((l-1)*3+(i-1))%SHORT_ANSWER.length]; return {id:`saw_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Answer the question.',difficulty:getDifficulty(l),subtype:'shortAnswerWriting',interactionType:'writing',question:b.q,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  opinion_writing: (l,i) => { const b=OPINION[((l-1)*3+(i-1))%OPINION.length]; return {id:`ow_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'What is your opinion?',difficulty:getDifficulty(l),subtype:'opinionWriting',interactionType:'writing',topic:b.t,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  daily_journal: (l,i) => { const b=JOURNAL[((l-1)*3+(i-1))%JOURNAL.length]; return {id:`dj_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Write a journal entry.',difficulty:getDifficulty(l),subtype:'dailyJournal',interactionType:'writing',dayDescription:b.day,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  summarize_story_writing: (l,i) => { const b=SUMMARIZE[((l-1)*3+(i-1))%SUMMARIZE.length]; return {id:`ssw_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Summarize the story.',difficulty:getDifficulty(l),subtype:'summarizeStoryWriting',interactionType:'writing',story:b.story,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  writing_email: (l,i) => { const b=EMAIL[((l-1)*3+(i-1))%EMAIL.length]; return {id:`we_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Write a short formal email.',difficulty:getDifficulty(l),subtype:'writingEmail',interactionType:'writing',context:b.ctx,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  correction_writing: (l,i) => { const b=CORRECTION[((l-1)*3+(i-1))%CORRECTION.length]; return {id:`cw_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`,instruction:'Find and fix the errors.',difficulty:getDifficulty(l),subtype:'correctionWriting',interactionType:'writing',wrongText:b.wrong,correctText:b.correct,hint:b.hint,xpReward:10,coinReward:10};},
};

// ─── BUILD & WRITE ───────────────────────────────────────────────────────────
function buildSection(sn, fn) {
  let s = sn<=6 ? (sn-1)*30+1 : 181, e = sn<=6 ? sn*30 : 200;
  const q = [];
  for (let l=s;l<=e;l++) for(let i=1;i<=3;i++) q.push(fn(l,i));
  return {quests:q};
}
function writeGame(cat, name, fn) {
  const d = path.join(__dirname,'assets','curriculum',cat);
  mkDir(d);
  for(let s=1;s<=7;s++){const data=buildSection(s,fn);const fp=path.join(d,`${name}_s${s}.json`);fs.writeFileSync(fp,JSON.stringify(data,null,2));console.log(`✅ ${name}_s${s}.json (${data.quests.length})`);}
}

console.log('\n📖 Phase 3: READING GAMES\n');
for(const[n,fn]of Object.entries(readingGens)) writeGame('reading',n,fn);
console.log('\n✍️ Phase 4: WRITING GAMES\n');
for(const[n,fn]of Object.entries(writingGens)) writeGame('writing',n,fn);
console.log('\n✅ Reading & Writing generation complete!\n');
