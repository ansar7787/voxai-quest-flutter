/**
 * Phase 5-8: Grammar, Vocabulary, Accent, Roleplay Generator
 * 40 games × 7 sections = 280 files
 */
const fs=require('fs'),path=require('path');
function mk(d){if(!fs.existsSync(d))fs.mkdirSync(d,{recursive:true});}
function dif(l){if(l<=30)return Math.ceil(l/3);if(l<=60)return 10+Math.ceil((l-30)/3);if(l<=100)return 20+Math.ceil((l-60)/4);if(l<=150)return 30+Math.ceil((l-100)/5);return 40+Math.ceil((l-150)/5);}
function id(p,l,i){return `${p}_L${String(l).padStart(3,'0')}_${String(i).padStart(2,'0')}`;}
function pick(arr,l,i){return arr[((l-1)*3+(i-1))%arr.length];}

// ── GRAMMAR ──
const GQ=[
  {q:'Choose the correct sentence.',opts:["He don't like milk.","He doesn't like milk.","He not like milk.","He doesn't likes milk."],ans:1,hint:'Third person singular.'},
  {q:'Which is grammatically correct?',opts:['She have a cat.','She has a cat.','She haves a cat.','She having a cat.'],ans:1,hint:'Third person singular verb.'},
  {q:'Select the correct form.',opts:['They is happy.','They am happy.','They are happy.','They be happy.'],ans:2,hint:'Plural subject needs "are".'},
  {q:'Which sentence is correct?',opts:['I goed home.','I went home.','I wented home.','I go home yesterday.'],ans:1,hint:'Irregular past tense.'},
  {q:'Choose the correct option.',opts:['She can sings.','She can sing.','She can sang.','She can singing.'],ans:1,hint:'Base form after modals.'},
  {q:'Which is right?',opts:['The childs play.','The children plays.','The children play.','The childrens play.'],ans:2,hint:'Irregular plural + verb agreement.'},
  {q:'Select correct grammar.',opts:['More better','Most best','Better','More good'],ans:2,hint:'Comparative form of good.'},
  {q:'Which sentence is correct?',opts:['I have been to Paris.','I have went to Paris.','I have go to Paris.','I have going to Paris.'],ans:0,hint:'Present perfect uses past participle.'},
];
const SC=[
  {orig:'They are playing football.',inst:'Rewrite in negative form.',ans:'They are not playing football.',hint:"Add 'not' after auxiliary."},
  {orig:'She likes reading books.',inst:'Change to a question.',ans:'Does she like reading books?',hint:"Use 'does' for third person."},
  {orig:'He drove to work.',inst:'Rewrite in present tense.',ans:'He drives to work.',hint:'Third person singular present.'},
  {orig:'We will go tomorrow.',inst:'Change to past tense.',ans:'We went yesterday.',hint:'Change will+verb to past.'},
  {orig:'The cake was eaten.',inst:'Change to active voice.',ans:'Someone ate the cake.',hint:'Subject performs the action.'},
  {orig:'I am a teacher.',inst:'Make it negative.',ans:'I am not a teacher.',hint:"Add 'not' after 'am'."},
];
const WR=[
  {words:['quickly','ran','She','home.'],order:[2,1,0,3],hint:'Subject first.'},
  {words:['the','are','park.','in','They'],order:[4,1,3,0,2],hint:'Subject + verb + preposition.'},
  {words:['yesterday.','went','I','cinema','the','to'],order:[2,1,5,4,3,0],hint:'Subject + past verb + place.'},
  {words:['beautiful','is','This','a','painting.'],order:[2,1,3,0,4],hint:"Start with 'This'."},
  {words:['can','English.','speak','We'],order:[3,0,2,1],hint:'Subject + modal + verb.'},
  {words:['every','brushes','He','teeth','day.','his'],order:[2,1,5,3,0,4],hint:'Daily routine.'},
];
const TM=[
  {p:'I (go) to the cinema yesterday.',w:'went',hint:'Past tense.'},
  {p:'She (study) English every day.',w:'studies',hint:'Present simple, third person.'},
  {p:'They (be) very happy right now.',w:'are',hint:'Present tense plural.'},
  {p:'He (swim) in the pool tomorrow.',w:'will swim',hint:'Future tense.'},
  {p:'We (eat) dinner when she called.',w:'were eating',hint:'Past continuous.'},
  {p:'She (already/finish) her homework.',w:'has already finished',hint:'Present perfect.'},
];
const PS=[
  {q:'Identify the noun.',sent:'The beautiful garden bloomed.',opts:['beautiful','garden','bloomed','the'],ans:1,hint:'A person, place, or thing.'},
  {q:'Which word is an adjective?',sent:'She wore a red dress.',opts:['She','wore','red','dress'],ans:2,hint:'Describes the noun.'},
  {q:'Find the verb.',sent:'The children played outside.',opts:['children','played','outside','The'],ans:1,hint:'An action word.'},
  {q:'Which is an adverb?',sent:'He runs quickly every morning.',opts:['runs','quickly','every','morning'],ans:1,hint:'Modifies the verb.'},
  {q:'Identify the preposition.',sent:'The cat sat on the mat.',opts:['cat','sat','on','mat'],ans:2,hint:'Shows position or relation.'},
  {q:'Which is a conjunction?',sent:'I like tea and coffee.',opts:['like','tea','and','coffee'],ans:2,hint:'Connects two words.'},
];
const SVA=[
  {q:'The group of students ___ studying.',opts:['is','are','were','be'],ans:0,hint:'Collective noun = singular.'},
  {q:'Neither the teacher nor the students ___ ready.',opts:['is','are','was','am'],ans:1,hint:'Closer subject is plural.'},
  {q:'Everyone ___ invited.',opts:['are','is','were','am'],ans:1,hint:"Everyone is singular."},
  {q:'The news ___ shocking.',opts:['are','is','were','have'],ans:1,hint:'News is uncountable singular.'},
  {q:'Mathematics ___ my favorite subject.',opts:['are','is','were','am'],ans:1,hint:'Subject names are singular.'},
  {q:'Each of the players ___ a trophy.',opts:['receive','receives','receiving','received'],ans:1,hint:"'Each' is always singular."},
];
const CC=[
  {q:'It was raining, ___ we went for a walk.',opts:['but','so','because','and'],ans:0,hint:'Contrasting ideas.'},
  {q:'She studied hard ___ she wanted to pass.',opts:['but','although','because','however'],ans:2,hint:'Reason/cause.'},
  {q:'___ it was cold, she wore a thin jacket.',opts:['Because','Although','So','And'],ans:1,hint:'Unexpected contrast.'},
  {q:'He can speak French ___ German.',opts:['but','or','and','because'],ans:2,hint:'Adding similar items.'},
  {q:'You can have tea ___ coffee.',opts:['and','but','or','so'],ans:2,hint:'Choice between two.'},
  {q:'I was tired, ___ I went to bed early.',opts:['but','or','so','although'],ans:2,hint:'Result of being tired.'},
];
const VS=[
  {p:'The cake was eaten by the boy.',a:'The boy ate the cake.',hint:'Subject performs action.'},
  {p:'The letter was written by Sarah.',a:'Sarah wrote the letter.',hint:'Move agent to subject.'},
  {p:'The window was broken by the ball.',a:'The ball broke the window.',hint:'What caused the action?'},
  {p:'The song was sung by the choir.',a:'The choir sang the song.',hint:'Irregular past tense.'},
  {p:'The homework was completed by all students.',a:'All students completed the homework.',hint:'Plural subject acts.'},
  {p:'The movie was directed by Steven.',a:'Steven directed the movie.',hint:'Director becomes subject.'},
];
const QF=[
  {sent:'She likes chocolate.',q:'Does she like chocolate?',hint:'Use does for third person.'},
  {sent:'They went to Paris.',q:'Did they go to Paris?',hint:'Use did for past tense.'},
  {sent:'He is a doctor.',q:'Is he a doctor?',hint:'Invert subject and verb.'},
  {sent:'We can swim.',q:'Can we swim?',hint:'Move modal before subject.'},
  {sent:'She has finished.',q:'Has she finished?',hint:'Invert auxiliary and subject.'},
  {sent:'They will come tomorrow.',q:'Will they come tomorrow?',hint:'Move will before subject.'},
];
const AI=[
  {q:'I saw ___ elephant at the zoo.',opts:['a','an','the','no article'],ans:1,hint:'Vowel sound needs "an".'},
  {q:'___ sun rises in the east.',opts:['A','An','The','No article'],ans:2,hint:'Unique object uses "the".'},
  {q:'She is ___ honest person.',opts:['a','an','the','no article'],ans:1,hint:"Silent 'h' = vowel sound."},
  {q:'I need ___ water.',opts:['a','an','some','the'],ans:2,hint:'Uncountable noun.'},
  {q:'He plays ___ guitar beautifully.',opts:['a','an','the','no article'],ans:2,hint:'Musical instruments use "the".'},
  {q:'___ Mount Everest is very tall.',opts:['A','The','An','No article'],ans:3,hint:'Proper nouns of mountains.'},
];

// ── VOCABULARY ──
const FL=[{w:'Melancholy',def:'A feeling of pensive sadness.',ex:'He felt a wave of melancholy.'},{w:'Ephemeral',def:'Lasting a very short time.',ex:'The beauty of cherry blossoms is ephemeral.'},{w:'Ubiquitous',def:'Present everywhere.',ex:'Smartphones have become ubiquitous.'},{w:'Resilient',def:'Able to recover quickly.',ex:'She proved to be remarkably resilient.'},{w:'Pragmatic',def:'Dealing practically.',ex:'He took a pragmatic approach.'},{w:'Eloquent',def:'Fluent and persuasive.',ex:'She gave an eloquent speech.'}];
const SS=[{w:'Brave',opts:['Courageous','Timid','Weak','Angry'],ans:0,hint:'Having no fear.'},{w:'Happy',opts:['Sad','Joyful','Angry','Tired'],ans:1,hint:'A positive emotion.'},{w:'Smart',opts:['Dull','Clever','Slow','Weak'],ans:1,hint:'Mental ability.'},{w:'Rich',opts:['Poor','Wealthy','Cheap','Small'],ans:1,hint:'Having money.'},{w:'Fast',opts:['Slow','Swift','Heavy','Dull'],ans:1,hint:'Moving quickly.'},{w:'Beautiful',opts:['Ugly','Gorgeous','Plain','Dull'],ans:1,hint:'Pleasing to look at.'}];
const AS=[{w:'Hot',opts:['Cold','Warm','Mild','Cool'],ans:0,hint:'Temperature.'},{w:'Big',opts:['Huge','Small','Large','Tall'],ans:1,hint:'Size.'},{w:'Happy',opts:['Joyful','Sad','Glad','Excited'],ans:1,hint:'Emotion.'},{w:'Light',opts:['Bright','Dark','Dim','Pale'],ans:1,hint:'Brightness.'},{w:'Fast',opts:['Quick','Slow','Swift','Rapid'],ans:1,hint:'Speed.'},{w:'Old',opts:['Ancient','New','Aged','Vintage'],ans:1,hint:'Age.'}];
const CX=[{w:'Pragmatic',opts:['He took a pragmatic approach to the budget.','The pragmatics made it rain.','She felt pragmatic after coffee.','A pragmatic of birds.'],ans:0,hint:'Being practical.'},{w:'Inevitable',opts:['An inevitable conclusion.','I ate an inevitable.','She inevitable ran.','Inevitable the cat.'],ans:0,hint:'Cannot be avoided.'},{w:'Reluctant',opts:['He was reluctant to agree.','She ate reluctantly soup.','Reluctant the door.','I reluctant home.'],ans:0,hint:'Unwilling.'},{w:'Meticulous',opts:['She is meticulous about details.','The meticulous rained.','I meticulous ate.','He meticulous.'],ans:0,hint:'Very careful.'},{w:'Vivid',opts:['She has vivid memories.','He vivid the car.','Vivid ate dinner.','They vivid home.'],ans:0,hint:'Intensely clear.'}];
const PV=[{p:'His car broke down on the highway.',ph:'break down',opts:['Stop functioning','Start crying','Go faster','Turn left'],ans:0,hint:'Car stopped working.'},{p:'She came across an old photo.',ph:'come across',opts:['Found by chance','Threw away','Destroyed','Bought'],ans:0,hint:'Unexpected discovery.'},{p:'Please fill out this form.',ph:'fill out',opts:['Complete','Destroy','Read','Throw'],ans:0,hint:'Write information.'},{p:'He turned down the offer.',ph:'turn down',opts:['Rejected','Accepted','Liked','Found'],ans:0,hint:'Opposite of accept.'},{p:'She looks up to her mother.',ph:'look up to',opts:['Admires','Dislikes','Ignores','Fears'],ans:0,hint:'Respect and admire.'}];
const ID=[{idiom:'Under the weather',opts:['Feeling ill','Outside in rain','In a storm','Happy'],ans:0,hint:'Health related.'},{idiom:'Break the ice',opts:['Start conversation','Break something','Cool down','Make ice'],ans:0,hint:'Social situations.'},{idiom:'Piece of cake',opts:['Very easy','Delicious','Expensive','Complicated'],ans:0,hint:'Difficulty level.'},{idiom:'Hit the nail on the head',opts:['Exactly right','Made a mistake','Built something','Got angry'],ans:0,hint:'Accuracy.'},{idiom:'Cost an arm and a leg',opts:['Very expensive','Free','Cheap','Painful'],ans:0,hint:'Price related.'},{idiom:'Spill the beans',opts:['Reveal a secret','Make a mess','Cook beans','Drop food'],ans:0,hint:'Information sharing.'}];
const AW=[{s:'I need to get a new passport.',opts:['Obtain','Grab','Find','Buy'],ans:0,hint:'Official processes.'},{s:'He got a lot of money.',opts:['Acquired','Grabbed','Found','Took'],ans:0,hint:'Formal earning.'},{s:'She said sorry.',opts:['Apologized','Told','Spoke','Said'],ans:0,hint:'Formal regret.'},{s:'They got together to talk.',opts:['Convened','Met','Sat','Came'],ans:0,hint:'Formal meeting.'},{s:'He looked into the problem.',opts:['Investigated','Saw','Watched','Stared'],ans:0,hint:'Formal examination.'}];
const TV=[{topic:'Cooking',q:'Which word relates to cooking?',opts:['Sauté','Sprint','Orbit','Compose'],ans:0,hint:'Kitchen action.'},{topic:'Medicine',q:'Which is a medical term?',opts:['Diagnosis','Algorithm','Metaphor','Symphony'],ans:0,hint:'Doctor vocabulary.'},{topic:'Law',q:'Which is a legal term?',opts:['Verdict','Melody','Catalyst','Photon'],ans:0,hint:'Court vocabulary.'},{topic:'Science',q:'Which is a scientific term?',opts:['Hypothesis','Allegory','Sonnet','Concerto'],ans:0,hint:'Research vocabulary.'},{topic:'Business',q:'Which is a business term?',opts:['Revenue','Stanza','Nucleus','Crescendo'],ans:0,hint:'Finance vocabulary.'}];
const WF=[{v:'Inform',n:'Information',hint:'Act of informing.'},{v:'Create',n:'Creation',hint:'Act of creating.'},{v:'Decide',n:'Decision',hint:'Act of deciding.'},{v:'Educate',n:'Education',hint:'Act of educating.'},{v:'Discover',n:'Discovery',hint:'Act of discovering.'},{v:'Celebrate',n:'Celebration',hint:'Act of celebrating.'}];
const PX=[{q:"What is the common root of 'bicycle' and 'binary'?",opts:['Two','Circle','Machine','Fast'],ans:0,hint:'How many wheels?'},{q:"What does the prefix 'un-' mean?",opts:['Not','Again','Before','After'],ans:0,hint:'Unhappy means...'},{q:"What does '-ology' mean?",opts:['Study of','Fear of','Love of','Lack of'],ans:0,hint:'Biology, psychology...'},{q:"What does 'pre-' mean?",opts:['After','Before','During','Without'],ans:1,hint:'Preview means...'},{q:"What does 'anti-' mean?",opts:['For','Against','With','Under'],ans:1,hint:'Antibiotic fights...'}];

// ── ACCENT ──
const MP=[{text:'Ship',opts:['Ship','Sheep'],ans:0,hint:"Short 'i' sound."},{text:'Bit',opts:['Bit','Beat'],ans:0,hint:"Short vowel."},{text:'Pull',opts:['Pull','Pool'],ans:0,hint:"Short 'u'."},{text:'Cat',opts:['Cat','Cut'],ans:0,hint:"'a' as in apple."},{text:'Pan',opts:['Pan','Pen'],ans:0,hint:"'a' vs 'e'."},{text:'Sit',opts:['Sit','Set'],ans:0,hint:"'i' vs 'e'."}];
const IM=[{text:'Are you coming today?',opts:['Rising','Falling'],ans:0,hint:'Yes/No questions rise.'},{text:'Where do you live?',opts:['Rising','Falling'],ans:1,hint:'Wh-questions fall.'},{text:'She is beautiful.',opts:['Rising','Falling'],ans:1,hint:'Statements fall.'},{text:'Would you like some tea?',opts:['Rising','Falling'],ans:0,hint:'Offers rise.'},{text:'What time is it?',opts:['Rising','Falling'],ans:1,hint:'Information questions fall.'},{text:'Really?',opts:['Rising','Falling'],ans:0,hint:'Surprise rises.'}];
const SY=[{w:'ECONOMY',opts:['E-','-CON-','-O-','-MY'],ans:1,hint:'Second syllable.'},{w:'PHOTOGRAPH',opts:['PHO-','-TO-','-GRAPH'],ans:0,hint:'First syllable.'},{w:'DETERMINATION',opts:['DE-','-TER-','-MI-','-NA-'],ans:2,hint:'Third syllable.'},{w:'UNIVERSITY',opts:['U-','-NI-','-VER-','-SI-'],ans:2,hint:'Third syllable.'},{w:'BANANA',opts:['BA-','-NA-','-NA'],ans:1,hint:'Second syllable.'},{w:'COMPUTER',opts:['COM-','-PU-','-TER'],ans:1,hint:'Second syllable.'}];
const WL=[{text:"Would you like some tea?",q:"What blended sound?",opts:['/dʒ/','/d/','/y/','/z/'],ans:0,hint:"Sounds like 'Woud-ja'."},{text:"Did you eat?",q:"What blended sound?",opts:['/dʒ/','/t/','/d/','/z/'],ans:0,hint:"Sounds like 'Didja'."},{text:"Got to go.",q:"What blended sound?",opts:['/ɾ/','/t/','/d/','/g/'],ans:0,hint:"Sounds like 'Gotta'."},{text:"Want to play?",opts:['/ɾ/','/t/','/n/','/w/'],ans:0,hint:"Sounds like 'Wanna'."},{text:"Going to eat.",opts:['/n/','/ɾ/','/g/','/t/'],ans:0,hint:"Sounds like 'Gonna'."}];
const SH=[{text:'The early bird catches the worm.',hint:'Stress content words only.'},{text:'I cannot believe what happened yesterday.',hint:'Emphasize key words.'},{text:'Would you mind passing the salt please?',hint:'Softer on function words.'},{text:'She has been working here since January.',hint:'Stress the timeline.'},{text:'They would have gone if they had known.',hint:'Conditional stress pattern.'},{text:'The more you practice the better you get.',hint:'Comparative stress.'}];
const VD=[{q:"Select the option with /æ/ sound.",opts:['Cat','Cut','Cot','Coat'],ans:0,hint:"Short 'a' in 'back'."},{q:"Which has the /iː/ sound?",opts:['Bit','Beat','But','Bat'],ans:1,hint:"Long 'ee' sound."},{q:"Which has /ʊ/ sound?",opts:['Pool','Pull','Pole','Peel'],ans:1,hint:"Short 'oo'."},{q:"Which has /ɑː/ sound?",opts:['Cat','Cart','Cut','Cot'],ans:1,hint:"Long 'ah' sound."},{q:"Which has /ɔː/ sound?",opts:['Caught','Cut','Cat','Cot'],ans:0,hint:"'aw' sound."}];
const CN=[{w:'THINK',q:"Is 'th' voiced or unvoiced?",opts:['Voiced','Unvoiced'],ans:1,hint:'No throat vibration.'},{w:'THIS',q:"Is 'th' voiced or unvoiced?",opts:['Voiced','Unvoiced'],ans:0,hint:'Throat vibrates.'},{w:'THREE',q:"Is 'th' voiced or unvoiced?",opts:['Voiced','Unvoiced'],ans:1,hint:'No vibration.'},{w:'THAT',q:"Is 'th' voiced or unvoiced?",opts:['Voiced','Unvoiced'],ans:0,hint:'Vibrates.'},{w:'THROUGH',q:"Is 'th' voiced or unvoiced?",opts:['Voiced','Unvoiced'],ans:1,hint:'No vibration.'}];
const PP=[{text:'I am SO happy to see you!',q:'What emotion does the pitch convey?',opts:['Surprise','Boredom','Anger','Sadness'],ans:0,hint:'Rising pitch = enthusiasm.'},{text:'Oh great, another meeting.',q:'What tone is this?',opts:['Excited','Sarcastic','Happy','Nervous'],ans:1,hint:'Flat tone with negative words.'},{text:'Are you SURE about that?',q:'What does the emphasis suggest?',opts:['Doubt','Agreement','Joy','Anger'],ans:0,hint:'Stress on SURE = questioning.'},{text:'Well done, everyone!',q:'What emotion?',opts:['Anger','Pride','Sadness','Fear'],ans:1,hint:'Positive praise.'},{text:'I TOLD you so.',q:'What tone?',opts:['Apologetic','Vindicated','Sad','Confused'],ans:1,hint:'"I was right" feeling.'}];
const SV=[{text:"Whatcha gonna do?",full:'What are you going to do?',hint:'Fast casual speech.'},{text:"I dunno.",full:"I don't know.",hint:'Contracted form.'},{text:"Lemme see.",full:'Let me see.',hint:'Blended words.'},{text:"Shoulda done it.",full:'Should have done it.',hint:'Modal contraction.'},{text:"Kinda tired.",full:'Kind of tired.',hint:'Casual blending.'}];
const DD=[{text:'Schedule',opts:['SHED-yool (British)','SKED-yool (American)'],q:'Which is the British pronunciation?',ans:0,hint:'British uses "sh".'},{text:'Tomato',opts:['tuh-MAH-toh (British)','tuh-MAY-toh (American)'],q:'Which is American?',ans:1,hint:"Americans say 'may'."},{text:'Aluminium',opts:['al-yoo-MIN-ee-um (British)','ah-LOO-min-um (American)'],q:'Which is British?',ans:0,hint:'British has extra syllable.'},{text:'Garage',opts:['GARR-ij (British)','guh-RAHZH (American)'],q:'Which is American?',ans:1,hint:"American stresses second syllable."},{text:'Either',opts:['EYE-ther (British)','EE-ther (American)'],q:'Which is British?',ans:0,hint:'"Eye" vs "ee".'}];

// ── ROLEPLAY ──
const BD=[{last:"I'm sorry, we are all out of milk.",opts:["That's okay, I'll take soy milk.","I hate you.","Where is my car?","Give me milk now."],ans:0,hint:'Be polite, find alternatives.'},{last:"Your total comes to $45.50.",opts:["Here is my card, thank you.","That is too much, I refuse.","I have no money.","Why so expensive?"],ans:0,hint:'Pay politely.'},{last:"Would you like fries with that?",opts:["Yes please, and a drink too.","I don't eat.","Give me everything.","No, go away."],ans:0,hint:'Simple polite response.'},{last:"I think we should postpone the meeting.",opts:["I agree, let's reschedule for next week.","No, never.","I am busy forever.","What meeting?"],ans:0,hint:'Agree professionally.'},{last:"Could I see some identification?",opts:["Of course, here is my ID.","No, you can't.","Why?","I forgot everything."],ans:0,hint:'Comply politely.'}];
const SR=[{sit:'You accidentally bump into someone on the street.',opts:["Oh, I'm so sorry! Are you alright?","Watch where you're going!","That was your fault.","Keep walking."],ans:0,hint:'Apologize sincerely.'},{sit:'A stranger asks you for directions.',opts:["Sure, go straight and turn left.","I don't talk to strangers.","Figure it out yourself.","I am lost too."],ans:0,hint:'Be helpful.'},{sit:'Your food order is wrong at a restaurant.',opts:["Excuse me, I ordered the chicken, not fish.","This is terrible!","I want a refund NOW.","Whatever."],ans:0,hint:'Be clear but polite.'},{sit:'Someone compliments your presentation.',opts:["Thank you, I worked hard on it.","I know, I'm great.","It was nothing.","Obviously."],ans:0,hint:'Accept graciously.'},{sit:'You need to leave a meeting early.',opts:["I apologize, but I need to leave for an appointment.","Bye.","This is boring.","I'm leaving."],ans:0,hint:'Explain politely.'}];
const JI=[{q:"Why should we hire you?",s:'I have relevant experience and a strong work ethic.',hint:'Mention skills.'},{q:"What is your greatest weakness?",s:'I tend to be a perfectionist, but I am working on delegating more.',hint:'Turn weakness into positive.'},{q:"Where do you see yourself in five years?",s:'I see myself growing within this company in a leadership role.',hint:'Show ambition and loyalty.'},{q:"Tell me about yourself.",s:'I am a dedicated professional with five years of experience in marketing.',hint:'Keep it professional.'},{q:"Why did you leave your last job?",s:'I am looking for new challenges and growth opportunities.',hint:'Stay positive.'}];
const MC=[{dq:"Where exactly does it hurt?",s:'I have a sharp pain in my lower back.',hint:'Location and type of pain.'},{dq:"How long have you had these symptoms?",s:'The symptoms started about three days ago.',hint:'Mention the duration.'},{dq:"Are you taking any medications?",s:'Yes, I am currently taking blood pressure medication.',hint:'Be specific about medications.'},{dq:"Do you have any allergies?",s:'I am allergic to penicillin.',hint:'Name the specific allergy.'},{dq:"What brings you in today?",s:'I have had a persistent cough for over a week.',hint:'Describe the main complaint.'}];
const GO=[{sit:'You want to order at a restaurant.',opts:["I'd like the grilled salmon with a side salad, please.","Give me food.","Something good.","I want everything."],ans:0,hint:'Be specific and polite.'},{sit:'You want to ask about ingredients.',opts:["Does this dish contain any nuts?","What's in it?","Is it good?","I don't care."],ans:0,hint:'Ask about specific allergens.'},{sit:'The waiter recommends the special.',opts:["That sounds lovely, I'll try it.","No.","I don't trust you.","Whatever."],ans:0,hint:'Respond positively.'},{sit:'You want to send food back politely.',opts:["I'm sorry, but this steak is undercooked. Could I get it done more?","This is raw!","Cook it properly!","Terrible."],ans:0,hint:'Be specific about the issue.'}];
const TD=[{sit:'Your flight is delayed by 5 hours.',opts:["Could you tell me why the flight is delayed?","This is ridiculous!","I demand a refund.","Never flying again."],ans:0,hint:'Ask for information politely.'},{sit:'You need to change your hotel reservation.',opts:["I'd like to modify my reservation to check in a day later.","Change it.","I'm not coming.","Whatever."],ans:0,hint:'State the change clearly.'},{sit:'You lost your luggage at the airport.',opts:["I'd like to report a missing bag from flight BA247.","My stuff is gone!","Find it now!","This is theft."],ans:0,hint:'Provide flight details.'},{sit:'Asking for tourist recommendations.',opts:["Could you recommend some must-see attractions?","What's fun here?","Is there anything good?","I'm bored."],ans:0,hint:'Be specific about interests.'}];
const CR=[{sit:'Two colleagues disagree about a project approach.',opts:["I understand both perspectives. Perhaps we can find a middle ground.","You're both wrong.","Just do it my way.","I don't care."],ans:0,hint:'Acknowledge both sides.'},{sit:'A customer is angry about a delayed delivery.',opts:["I completely understand your frustration. Let me resolve this immediately.","It's not my fault.","Be patient.","That's how it works."],ans:0,hint:'Empathize first.'},{sit:'Your roommate plays music too loud.',opts:["Hey, would you mind turning it down a bit? I'm trying to study.","Shut up!","I'll call the police.","Move out."],ans:0,hint:'Use a friendly request.'},{sit:'A friend borrowed money and hasn\'t paid back.',opts:["Hey, remember the $50 from last month? I could really use it back.","Pay me now!","You're a thief.","I'll never lend again."],ans:0,hint:'Remind gently.'}];
const EP=[{topic:'Your new mobile app.',s:'Our app helps people learn languages 3x faster using AI-powered conversations.',hint:'Highlight unique value.'},{topic:'Your catering business.',s:'We provide fresh, locally-sourced meals for events of any size.',hint:'Key differentiator.'},{topic:'Your tutoring service.',s:'We offer personalized one-on-one tutoring that adapts to each student.',hint:'What makes it special?'},{topic:'Your cleaning service.',s:'We use eco-friendly products and guarantee satisfaction on every visit.',hint:'Highlight your guarantee.'},{topic:'Your fitness program.',s:'Our 30-day program combines nutrition and exercise for lasting results.',hint:'Mention the timeframe and results.'}];
const SP=[{line:"Hi! I just moved in next door.",opts:["Welcome! I'm John. Let me know if you need anything.","Who are you?","I'm busy.","The weather is nice."],ans:0,hint:'Welcome and introduce yourself.'},{line:"This is a great party, right?",opts:["It really is! The music is fantastic.","It's okay.","I want to leave.","Parties are boring."],ans:0,hint:'Show enthusiasm.'},{line:"Do you come here often?",opts:["First time actually! A friend recommended it.","None of your business.","Why?","Maybe."],ans:0,hint:'Share information openly.'},{line:"I love your jacket! Where did you get it?",opts:["Thank you! I got it from a little shop downtown.","Why do you care?","It's mine.","I don't remember."],ans:0,hint:'Accept compliment and share.'}];
const EH=[{dq:"Emergency services, what is the location?",s:'The fire is at 123 Maple Street.',hint:'Provide clear address.'},{dq:"What is the nature of the emergency?",s:'There has been a car accident with two vehicles involved.',hint:'Describe what happened.'},{dq:"Is anyone injured?",s:'Yes, one person appears to have a broken arm.',hint:'Describe injuries clearly.'},{dq:"Can you stay on the line?",s:'Yes, I will stay on the line until help arrives.',hint:'Confirm your cooperation.'},{dq:"Are you in a safe location?",s:'Yes, I am across the street from the incident.',hint:'Confirm your safety.'}];

// ── BUILD ──
function bld(sn,fn){let s=sn<=6?(sn-1)*30+1:181,e=sn<=6?sn*30:200;const q=[];for(let l=s;l<=e;l++)for(let i=1;i<=3;i++)q.push(fn(l,i));return{quests:q};}
function wr(cat,name,fn){const d=path.join(__dirname,'assets','curriculum',cat);mk(d);for(let s=1;s<=7;s++){const data=bld(s,fn);fs.writeFileSync(path.join(d,`${name}_s${s}.json`),JSON.stringify(data,null,2));console.log(`✅ ${name}_s${s}.json (${data.quests.length})`);};}

// Grammar generators
const grammarGens={
  grammar_quest:(l,i)=>{const b=pick(GQ,l,i);return{id:id('gq',l,i),instruction:b.q,difficulty:dif(l),subtype:'grammarQuest',interactionType:'choice',question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  sentence_correction:(l,i)=>{const b=pick(SC,l,i);return{id:id('sc',l,i),instruction:b.inst,difficulty:dif(l),subtype:'sentenceCorrection',interactionType:'writing',originalSentence:b.orig,correctAnswer:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  word_reorder:(l,i)=>{const b=pick(WR,l,i);return{id:id('wr',l,i),instruction:'Reorder words into a correct sentence.',difficulty:dif(l),subtype:'wordReorder',interactionType:'sequence',shuffledWords:b.words,correctOrder:b.order,hint:b.hint,xpReward:10,coinReward:10};},
  tense_mastery:(l,i)=>{const b=pick(TM,l,i);return{id:id('tm',l,i),instruction:'Fill in the correct verb form.',difficulty:dif(l),subtype:'tenseMastery',interactionType:'writing',passage:b.p,missingWord:b.w,hint:b.hint,xpReward:10,coinReward:10};},
  parts_of_speech:(l,i)=>{const b=pick(PS,l,i);return{id:id('pos',l,i),instruction:b.q,difficulty:dif(l),subtype:'partsOfSpeech',interactionType:'choice',sentence:b.sent,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  subject_verb_agreement:(l,i)=>{const b=pick(SVA,l,i);return{id:id('sva',l,i),instruction:b.q,difficulty:dif(l),subtype:'subjectVerbAgreement',interactionType:'choice',options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  clause_connector:(l,i)=>{const b=pick(CC,l,i);return{id:id('cc',l,i),instruction:'Choose the best conjunction.',difficulty:dif(l),subtype:'clauseConnector',interactionType:'choice',question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  voice_swap:(l,i)=>{const b=pick(VS,l,i);return{id:id('vs',l,i),instruction:'Change to active voice.',difficulty:dif(l),subtype:'voiceSwap',interactionType:'writing',passiveSentence:b.p,activeSentence:b.a,hint:b.hint,xpReward:10,coinReward:10};},
  question_formatter:(l,i)=>{const b=pick(QF,l,i);return{id:id('qf',l,i),instruction:'Convert to a question.',difficulty:dif(l),subtype:'questionFormatter',interactionType:'writing',statement:b.sent,correctQuestion:b.q,hint:b.hint,xpReward:10,coinReward:10};},
  article_insertion:(l,i)=>{const b=pick(AI,l,i);return{id:id('ai',l,i),instruction:'Select the correct article.',difficulty:dif(l),subtype:'articleInsertion',interactionType:'choice',question:b.q,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
};
const vocabGens={
  flashcards:(l,i)=>{const b=pick(FL,l,i);return{id:id('fl',l,i),instruction:'Match the word to its definition.',difficulty:dif(l),subtype:'flashcards',interactionType:'match',word:b.w,definition:b.def,example:b.ex,xpReward:10,coinReward:10};},
  synonym_search:(l,i)=>{const b=pick(SS,l,i);return{id:id('ss',l,i),instruction:'Pick the synonym.',difficulty:dif(l),subtype:'synonymSearch',interactionType:'choice',word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  antonym_search:(l,i)=>{const b=pick(AS,l,i);return{id:id('as',l,i),instruction:'Pick the antonym.',difficulty:dif(l),subtype:'antonymSearch',interactionType:'choice',word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  context_clues:(l,i)=>{const b=pick(CX,l,i);return{id:id('cx',l,i),instruction:'Select the correct usage.',difficulty:dif(l),subtype:'contextClues',interactionType:'choice',word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  phrasal_verbs:(l,i)=>{const b=pick(PV,l,i);return{id:id('pv',l,i),instruction:`What does '${b.ph}' mean here?`,difficulty:dif(l),subtype:'phrasalVerbs',interactionType:'choice',passage:b.p,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  idioms:(l,i)=>{const b=pick(ID,l,i);return{id:id('id',l,i),instruction:'Pick the correct meaning.',difficulty:dif(l),subtype:'idioms',interactionType:'choice',idiom:b.idiom,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  academic_word:(l,i)=>{const b=pick(AW,l,i);return{id:id('aw',l,i),instruction:'Select the formal equivalent.',difficulty:dif(l),subtype:'academicWord',interactionType:'choice',sentence:b.s,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  topic_vocab:(l,i)=>{const b=pick(TV,l,i);return{id:id('tv',l,i),instruction:b.q,difficulty:dif(l),subtype:'topicVocab',interactionType:'choice',topic:b.topic,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  word_formation:(l,i)=>{const b=pick(WF,l,i);return{id:id('wf',l,i),instruction:'Type the noun form.',difficulty:dif(l),subtype:'wordFormation',interactionType:'writing',verb:b.v,noun:b.n,hint:b.hint,xpReward:10,coinReward:10};},
  prefix_suffix:(l,i)=>{const b=pick(PX,l,i);return{id:id('px',l,i),instruction:b.q,difficulty:dif(l),subtype:'prefixSuffix',interactionType:'choice',options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
};
const accentGens={
  minimal_pairs:(l,i)=>{const b=pick(MP,l,i);return{id:id('mp',l,i),instruction:'Which word do you hear?',difficulty:dif(l),subtype:'minimalPairs',interactionType:'choice',textToSpeak:b.text,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  intonation_mimic:(l,i)=>{const b=pick(IM,l,i);return{id:id('im',l,i),instruction:'Select the intonation pattern.',difficulty:dif(l),subtype:'intonationMimic',interactionType:'choice',textToSpeak:b.text,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  syllable_stress:(l,i)=>{const b=pick(SY,l,i);return{id:id('sy',l,i),instruction:'Select the stressed syllable.',difficulty:dif(l),subtype:'syllableStress',interactionType:'choice',word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  word_linking:(l,i)=>{const b=pick(WL,l,i);return{id:id('wl',l,i),instruction:'What blended sound do you hear?',difficulty:dif(l),subtype:'wordLinking',interactionType:'choice',textToSpeak:b.text,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  shadowing_challenge:(l,i)=>{const b=pick(SH,l,i);return{id:id('sh',l,i),instruction:'Repeat following the same rhythm.',difficulty:dif(l),subtype:'shadowingChallenge',interactionType:'speech',textToSpeak:b.text,hint:b.hint,xpReward:10,coinReward:10};},
  vowel_distinction:(l,i)=>{const b=pick(VD,l,i);return{id:id('vd',l,i),instruction:b.q,difficulty:dif(l),subtype:'vowelDistinction',interactionType:'choice',options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  consonant_clarity:(l,i)=>{const b=pick(CN,l,i);return{id:id('cn',l,i),instruction:b.q,difficulty:dif(l),subtype:'consonantClarity',interactionType:'choice',word:b.w,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  pitch_pattern_match:(l,i)=>{const b=pick(PP,l,i);return{id:id('pp',l,i),instruction:b.q,difficulty:dif(l),subtype:'pitchPatternMatch',interactionType:'choice',textToSpeak:b.text,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  speed_variance:(l,i)=>{const b=pick(SV,l,i);return{id:id('sv',l,i),instruction:'Type the full formal sentence.',difficulty:dif(l),subtype:'speedVariance',interactionType:'writing',textToSpeak:b.text,correctAnswer:b.full,hint:b.hint,xpReward:10,coinReward:10};},
  dialect_drill:(l,i)=>{const b=pick(DD,l,i);return{id:id('dd',l,i),instruction:b.q,difficulty:dif(l),subtype:'dialectDrill',interactionType:'choice',word:b.text,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
};
const roleplayGens={
  branching_dialogue:(l,i)=>{const b=pick(BD,l,i);return{id:id('bd',l,i),instruction:'Select the best response.',difficulty:dif(l),subtype:'branchingDialogue',interactionType:'choice',lastLine:b.last,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  situational_response:(l,i)=>{const b=pick(SR,l,i);return{id:id('sr',l,i),instruction:'How would you respond?',difficulty:dif(l),subtype:'situationalResponse',interactionType:'choice',situation:b.sit,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  job_interview:(l,i)=>{const b=pick(JI,l,i);return{id:id('ji',l,i),instruction:'Respond to the interviewer.',difficulty:dif(l),subtype:'jobInterview',interactionType:'speech',interviewerQuestion:b.q,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  medical_consult:(l,i)=>{const b=pick(MC,l,i);return{id:id('mc',l,i),instruction:"Respond to the doctor's question.",difficulty:dif(l),subtype:'medicalConsult',interactionType:'speech',doctorQuestion:b.dq,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  gourmet_order:(l,i)=>{const b=pick(GO,l,i);return{id:id('go',l,i),instruction:'What do you say?',difficulty:dif(l),subtype:'gourmetOrder',interactionType:'choice',situation:b.sit,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  travel_desk:(l,i)=>{const b=pick(TD,l,i);return{id:id('td',l,i),instruction:'What do you say to the agent?',difficulty:dif(l),subtype:'travelDesk',interactionType:'choice',situation:b.sit,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  conflict_resolver:(l,i)=>{const b=pick(CR,l,i);return{id:id('cr',l,i),instruction:'How do you handle this?',difficulty:dif(l),subtype:'conflictResolver',interactionType:'choice',situation:b.sit,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  elevator_pitch:(l,i)=>{const b=pick(EP,l,i);return{id:id('ep',l,i),instruction:'Pitch your idea.',difficulty:dif(l),subtype:'elevatorPitch',interactionType:'speech',topic:b.topic,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
  social_spark:(l,i)=>{const b=pick(SP,l,i);return{id:id('sp',l,i),instruction:'What do you say?',difficulty:dif(l),subtype:'socialSpark',interactionType:'choice',neighborLine:b.line,options:b.opts,correctAnswerIndex:b.ans,hint:b.hint,xpReward:10,coinReward:10};},
  emergency_hub:(l,i)=>{const b=pick(EH,l,i);return{id:id('eh',l,i),instruction:'Speak to the dispatcher.',difficulty:dif(l),subtype:'emergencyHub',interactionType:'speech',dispatcherQuestion:b.dq,sampleAnswer:b.s,hint:b.hint,xpReward:10,coinReward:10};},
};

// ── RUN ──
console.log('\n📝 Phase 5: GRAMMAR\n');
for(const[n,fn]of Object.entries(grammarGens))wr('grammar',n,fn);
console.log('\n📚 Phase 6: VOCABULARY\n');
for(const[n,fn]of Object.entries(vocabGens))wr('vocabulary',n,fn);
console.log('\n🗣️ Phase 7: ACCENT\n');
for(const[n,fn]of Object.entries(accentGens))wr('accent',n,fn);
console.log('\n🎭 Phase 8: ROLEPLAY\n');
for(const[n,fn]of Object.entries(roleplayGens))wr('roleplay',n,fn);
console.log('\n✅ All 40 games generated!\n');
