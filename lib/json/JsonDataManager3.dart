// import 'dart:convert';
//
// import '../models/JsonModel.dart';
//
// class JsonDataManager3 {
//   static const String moduleJsonData = '''
//   {
//     "module": "Module 3",
//     "levels": [
//       {
//         "level": "Level 7 (Acquire)",
//         "scenarios": [
//           {
//             "id": 31,
//             "title": "Understanding AI Definition and Basic Concepts",
//             "description": "Ayesha, a pre-service teacher, is asked by her mentor to explain the difference between a basic calculator and an AI-powered chatbot used for student queries. She's unsure how to define AI in simple terms.",
//             "question": "Which of the following best explains the difference?",
//             "options": [
//               "A calculator can make decisions like a chatbot.",
//               "A chatbot uses data and algorithms to simulate human-like conversation.",
//               "Both perform the same function in different forms."
//             ],
//             "correctAnswer": 2,
//             "feedback": "A chatbot uses data and algorithms to simulate human-like conversation, demonstrating adaptive behavior and learning from interaction, which are key features of artificial intelligence. In contrast, calculators follow static rules without learning or adapting.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Which one is AI?",
//               "description": "You are comparing two tools to determine which one qualifies as AI and demonstrates artificial intelligence characteristics.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Tool A: A math app that solves equations using built-in formulas and always gives the same answer.",
//                   "options": [
//                     "This demonstrates AI characteristics",
//                     "This follows static rules without learning"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Tool B: A chatbot that adapts its replies based on user questions and previous interactions.",
//                   "options": [
//                     "This demonstrates AI characteristics",
//                     "This follows static rules without learning"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "Tool B demonstrates AI because it uses adaptive behavior and learns from interaction, which are key features of artificial intelligence. In contrast, Tool A follows static rules without learning or adapting.",
//               "badEnding": "Tool A lacks the adaptive and learning capabilities that define artificial intelligence systems."
//             }
//           },
//           {
//             "id": 32,
//             "title": "Identifying AI vs Rule-Based Tools",
//             "description": "Mr. Karim is teaching about AI and uses MS Word's spellchecker and Google Translate as examples. A student asks if both are AI-based tools. Karim pauses, unsure how to respond.",
//             "question": "Which tool demonstrates actual AI functionality?",
//             "options": [
//               "Both are AI because they correct language.",
//               "Only MS Word's spellchecker, because it follows pre-set rules.",
//               "Only Google Translate, because it adapts and improves through data."
//             ],
//             "correctAnswer": 3,
//             "feedback": "Google Translate uses machine learning to improve translations over time, which is a core feature of AI. Spellcheckers rely on fixed rule sets and dictionaries, not adaptive algorithms.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Who's really smart?",
//               "description": "You are comparing two language learning apps to determine which one uses AI technology for personalized learning.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "App A: Uses a list of grammar rules to underline mistakes and suggest corrections.",
//                   "options": [
//                     "This app is AI-powered",
//                     "This app uses rule-based correction"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "App B: Analyzes writing styles over time and starts giving personalized grammar and tone suggestions.",
//                   "options": [
//                     "This app is AI-powered",
//                     "This app uses rule-based correction"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "Personalized and adaptive features that improve with user data are signs of AI. App B demonstrates artificial intelligence through its ability to learn and adapt.",
//               "badEnding": "Rule-based correction systems like App A follow predetermined patterns without learning or adaptation capabilities."
//             }
//           },
//           {
//             "id": 33,
//             "title": "Training Data and Algorithms",
//             "description": "Shahid attends a workshop where he hears that AI tools like facial recognition use 'training data' and 'algorithms.' He wonders how these two work together.",
//             "question": "What best describes the role of training data in AI?",
//             "options": [
//               "Training data teaches the AI system to identify patterns through repeated exposure.",
//               "Training data is irrelevant once the AI tool is deployed.",
//               "Algorithms replace the need for training data."
//             ],
//             "correctAnswer": 1,
//             "feedback": "Training data helps the AI learn by recognizing and generalizing from patterns, which is essential for tasks like facial recognition and other AI applications.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "How does the AI learn?",
//               "description": "You are comparing two systems to determine which one relies on training data to improve its performance over time.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "System A: A weather app that shows forecast based on real-time sensor input.",
//                   "options": [
//                     "This relies on training data to improve",
//                     "This responds to current input without learning"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "System B: An AI assistant that predicts what a user wants to do next, based on past user actions and data.",
//                   "options": [
//                     "This relies on training data to improve",
//                     "This responds to current input without learning"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "System B uses historical user data to identify patterns and make predictions, which is a hallmark of AI learning through training data.",
//               "badEnding": "System A responds to current input without learning from past patterns, lacking the training data dependency of AI systems."
//             }
//           },
//           {
//             "id": 34,
//             "title": "Identifying AI Tools",
//             "description": "Mr. Naveed wants to introduce AI tools in his digital literacy class. He lists Grammarly, Google Translate, and a calculator. He's not sure if all qualify as AI.",
//             "question": "Which of the following are true AI-based tools?",
//             "options": [
//               "All three tools are AI because they support learning.",
//               "Only Grammarly and Google Translate, because they adapt based on user input.",
//               "Only the calculator, as it is used in every classroom."
//             ],
//             "correctAnswer": 2,
//             "feedback": "Grammarly and Google Translate adapt to inputs and improve over time, showing AI characteristics. Calculators follow static, rule-based functions without learning capabilities.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Which one uses AI?",
//               "description": "You are helping a school choose between two reading apps by identifying which one uses artificial intelligence technology.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "App A: Reads a fixed set of stories aloud in a robotic voice with no customization.",
//                   "options": [
//                     "This app uses AI technology",
//                     "This app lacks AI capabilities"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "App B: Analyzes a student's reading pace and pronunciation errors and adjusts the story complexity accordingly.",
//                   "options": [
//                     "This app uses AI technology",
//                     "This app lacks AI capabilities"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "App B uses AI because it analyzes individual student behavior and adapts its responses, demonstrating intelligent, personalized decision-making based on data—key traits of AI systems.",
//               "badEnding": "App A lacks the analytical and adaptive capabilities that characterize AI-powered educational tools."
//             }
//           },
//           {
//             "id": 35,
//             "title": "Tool Selection Based on Effectiveness",
//             "description": "Saima tests two AI reading tools: one accurate but complex, the other easy but inconsistent. She wants to use the best option for early readers.",
//             "question": "How should she make her decision?",
//             "options": [
//               "Choose the one with better reviews online",
//               "Select the tool that balances ease of use and reliability",
//               "Pick whichever is recommended by a friend"
//             ],
//             "correctAnswer": 2,
//             "feedback": "Effective educational tools must be both user-friendly and accurate, especially when used with young learners who need accessible yet reliable learning support.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Which tool suits your learners?",
//               "description": "You are choosing a vocabulary tool for primary students and need to pick the most effective option for young learners.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Tool A: Offers correct definitions but has a complex interface and no audio support.",
//                   "options": [
//                     "This tool is more effective for young learners",
//                     "This tool lacks age-appropriate features"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Tool B: Includes voice narration and interactive games, though it sometimes gives slightly simplified meanings.",
//                   "options": [
//                     "This tool is more effective for young learners",
//                     "This tool compromises accuracy for engagement"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "Tool B better supports young learners through voice narration and interactive elements that match their developmental needs, even if definitions are simplified—making learning more accessible and engaging.",
//               "badEnding": "Tool A's complexity and lack of interactive features make it less suitable for primary students despite its accuracy."
//             }
//           }
//         ]
//       },
//       {
//         "level": "Level 8 (Deepen)",
//         "scenarios": [
//           {
//             "id": 36,
//             "title": "Predictive Grading Bias",
//             "description": "Mr. Asim uses an AI-powered grading system in his English class. He notices students from rural schools are consistently marked lower in writing assignments despite strong content. On checking, he finds the model was trained mostly on urban student data.",
//             "question": "What should Mr. Asim do to ensure fair grading for all students?",
//             "options": [
//               "Keep using the tool and adjust scores manually later.",
//               "Ask students to change their writing style to match the training data.",
//               "Analyze the dataset, discuss with the provider, and advocate for a retrained or alternative tool."
//             ],
//             "correctAnswer": 3,
//             "feedback": "This response reflects a deeper understanding of bias in training data and the ethical responsibility to ensure fairness and inclusivity in AI-powered assessment tools.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Fair Grading: Whose Data Counts?",
//               "description": "You are comparing two schools' approaches to AI grading to determine which demonstrates more ethical and fair use of AI assessment tools.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "School A: Uses data from a wide range of student backgrounds, regularly updates the model, and reviews flagged results.",
//                   "options": [
//                     "This demonstrates ethical AI grading",
//                     "This approach is unnecessarily complicated"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "School B: Trains its AI only on high-performing urban student essays and uses it without review.",
//                   "options": [
//                     "This ensures consistent high standards",
//                     "This creates unfair bias in grading"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "School A demonstrates ethical AI use by including diverse data and human oversight, ensuring fair assessment for all students regardless of background.",
//               "badEnding": "School B's approach creates systematic bias that unfairly disadvantages students from different backgrounds or writing styles."
//             }
//           },
//           {
//             "id": 37,
//             "title": "Misleading Recommendations",
//             "description": "Mr. Bilal uses an AI tool that suggests different learning resources based on student profiles. He finds that students labeled as 'slow learners' are only recommended basic materials, regardless of their progress.",
//             "question": "How should Mr. Bilal respond to this issue?",
//             "options": [
//               "Use the AI tool for all recommendations regardless.",
//               "Rely on his judgment to override AI suggestions when needed.",
//               "Analyze how the tool makes decisions and balance AI output with his own assessments."
//             ],
//             "correctAnswer": 3,
//             "feedback": "This demonstrates the teacher's ability to evaluate AI recommendation logic and apply it responsibly in practice, ensuring students receive appropriate challenges.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Smart Teaching or Blind Trust?",
//               "description": "You are comparing two teachers using AI-based learning resource tools to determine who demonstrates deeper understanding and responsible AI use.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Teacher A: Accepts all AI recommendations and assigns them directly to students without review.",
//                   "options": [
//                     "This demonstrates efficient AI use",
//                     "This shows over-reliance on AI"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Teacher B: Checks the logic behind recommendations, adapts them to students' progress, and provides feedback.",
//                   "options": [
//                     "This demonstrates responsible AI use",
//                     "This undermines the AI system's efficiency"
//                   ]
//                 }
//               ],
//               "idealPath": "B-A",
//               "idealEnding": "Teacher B balances AI insights with professional judgment, ensuring recommendations serve actual student needs rather than algorithmic assumptions.",
//               "badEnding": "Teacher A's blind trust in AI recommendations may perpetuate unfair limitations on student potential and growth."
//             }
//           },
//           {
//             "id": 38,
//             "title": "Privacy in Data Sharing",
//             "description": "Ms. Hina uses an AI writing tool that stores and learns from student submissions. She discovers that some essays were accessible through online search.",
//             "question": "What should Ms. Hina prioritize in her response?",
//             "options": [
//               "Warn students to avoid personal content in essays.",
//               "Continue using the tool without changes.",
//               "Pause tool usage, review data handling policies, and report the breach."
//             ],
//             "correctAnswer": 3,
//             "feedback": "This reinforces data privacy and student protection responsibilities, emphasizing the need for immediate action when student data is compromised.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Whose Essay Is It Anyway?",
//               "description": "You are comparing two educators' approaches to AI writing tools to determine who practices more responsible and ethical AI use regarding student data.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Educator A: Checks the tool's privacy policy, obtains student consent, and ensures anonymized data.",
//                   "options": [
//                     "This shows responsible data practices",
//                     "This creates unnecessary barriers to tool use"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Educator B: Starts using the tool without checking how student essays are stored or shared.",
//                   "options": [
//                     "This enables quick implementation",
//                     "This ignores critical privacy concerns"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Educator A prioritizes transparency and student rights, ensuring that AI tool use respects privacy and maintains trust.",
//               "badEnding": "Educator B's approach risks exposing student work and violating privacy, potentially causing serious harm to students."
//             }
//           },
//           {
//             "id": 39,
//             "title": "Ethical Implications of AI Surveillance",
//             "description": "To reduce cheating, Mr. Tariq activates an AI proctoring tool that tracks eye movement and facial expressions. Students report anxiety and claim they are unfairly flagged.",
//             "question": "What should Mr. Tariq consider?",
//             "options": [
//               "Keep using the tool to maintain discipline.",
//               "Ask students not to worry about alerts.",
//               "Evaluate the psychological impact and explore less intrusive solutions."
//             ],
//             "correctAnswer": 3,
//             "feedback": "This emphasizes ethical judgment in choosing and applying AI tools, considering the broader impact on student wellbeing and learning environment.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Watchful Eyes",
//               "description": "You are comparing two schools' approaches to AI exam monitoring to determine which is more aligned with ethical AI principles.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "School X: Informs students about surveillance, allows opt-outs, and tests for bias in the monitoring system.",
//                   "options": [
//                     "This approach respects student rights",
//                     "This approach is too lenient on cheating"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "School Y: Monitors students using eye tracking and facial recognition without disclosure or consent options.",
//                   "options": [
//                     "This ensures comprehensive monitoring",
//                     "This violates ethical AI principles"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "School X prioritizes informed consent and student wellbeing while still maintaining academic integrity through transparent, ethical AI use.",
//               "badEnding": "School Y's intrusive surveillance creates anxiety and violates student agency, potentially harming the learning environment."
//             }
//           },
//           {
//             "id": 40,
//             "title": "Assessing Tool Appropriateness",
//             "description": "Vendors offer Mr. Nadeem several AI-based tutoring apps. He wants to ensure the tool he chooses is aligned with his curriculum and student needs.",
//             "question": "How should he proceed?",
//             "options": [
//               "Select the most popular tool.",
//               "Try them all randomly with students.",
//               "Use evaluation criteria (e.g., transparency, accessibility, ethics) to compare and select."
//             ],
//             "correctAnswer": 3,
//             "feedback": "This encourages structured evaluation of AI tools based on educational, ethical, and technical principles rather than popularity or trial-and-error approaches.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Choosing the Right AI Tool",
//               "description": "You are comparing two teachers' approaches to selecting AI tutoring apps to determine who demonstrates deeper professional AI evaluation.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Teacher Faiza: Uses a checklist to evaluate learning objectives, ethical impact, and user accessibility.",
//                   "options": [
//                     "This shows systematic tool evaluation",
//                     "This approach is overly time-consuming"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Teacher Yawar: Picks the app with the highest rating on the app store without further evaluation.",
//                   "options": [
//                     "This leverages crowd wisdom effectively",
//                     "This lacks professional evaluation criteria"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Teacher Faiza applies evaluation criteria aligned to educational needs, ensuring the selected tool truly serves her students' learning goals.",
//               "badEnding": "Teacher Yawar's reliance on popularity ratings may result in tools that don't match his specific curriculum or student needs."
//             }
//           }
//         ]
//       },
//       {
//         "level": "Level 9 (Create)",
//         "scenarios": [
//           {
//             "id": 41,
//             "title": "Co-Creating with Students",
//             "description": "Ms. Sana introduces a block-based AI tool in her coding club and invites students to co-design a chatbot that can support peer learning. Some students suggest adding humor, while others raise privacy concerns about data logging.",
//             "question": "How should Ms. Sana balance creativity, ethics, and student agency in this co-creation?",
//             "options": [
//               "Let students implement their ideas freely and address concerns if problems arise later",
//               "Facilitate a structured co-design session where students reflect on design and ethical implications",
//               "Use a ready-made chatbot template to limit risks while reducing student involvement"
//             ],
//             "correctAnswer": 2,
//             "feedback": "Structured co-design with ethical reflection promotes ownership and responsibility in student-driven AI projects while ensuring thoughtful consideration of implications.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Ethical Co-Creation in AI Tools",
//               "description": "You are comparing two teachers introducing AI chatbots in their classrooms to determine who demonstrates more ethical and inclusive co-creation practices.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Teacher Anila: Includes students in the design process, discussing privacy, tone, and use cases throughout development.",
//                   "options": [
//                     "This fosters ethical co-creation",
//                     "This slows down the development process"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Teacher Bashir: Builds the chatbot alone and asks students to use it without explanation of its design decisions.",
//                   "options": [
//                     "This ensures quality control",
//                     "This limits student agency and learning"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Teacher Anila involves learners and fosters ethical awareness, creating ownership and understanding of responsible AI design principles.",
//               "badEnding": "Teacher Bashir misses opportunities to develop students' critical thinking about AI ethics and design considerations."
//             }
//           },
//           {
//             "id": 42,
//             "title": "Ethical Algorithm Tweaking",
//             "description": "While customizing an AI-based reading level detector, Ms. Farida realizes it underestimates the performance of students with learning disabilities. She plans to tweak the model's algorithmic weights.",
//             "question": "What ethical concerns should she address before modifying the AI system?",
//             "options": [
//               "Whether students with disabilities should be evaluated using different criteria",
//               "If adjusting the algorithm could unintentionally marginalize other learner groups",
//               "How to increase the model's speed while reducing complexity"
//             ],
//             "correctAnswer": 2,
//             "feedback": "Algorithmic fairness requires a careful balance to prevent unintended bias against any student group while addressing known inequities.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Balancing Accuracy and Fairness",
//               "description": "You are comparing two teachers using AI to assess student reading levels to determine who demonstrates a responsible approach to AI customization.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Teacher Rabia: Notices unfair results and adjusts the model after consulting diverse student data and checking for unintended consequences.",
//                   "options": [
//                     "This shows responsible AI customization",
//                     "This creates unnecessary complexity"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Teacher Saqib: Sticks to default settings to avoid tampering with the system, despite noticing bias.",
//                   "options": [
//                     "This maintains system integrity",
//                     "This ignores ethical responsibility"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Teacher Rabia actively checks for fairness and makes thoughtful adjustments, demonstrating responsible AI customization that serves all students.",
//               "badEnding": "Teacher Saqib's inaction perpetuates bias and fails to address known inequities in the AI system."
//             }
//           },
//           {
//             "id": 43,
//             "title": "Inclusive Design Decisions",
//             "description": "A group of teachers in Hunza develop an AI tutor and debate whether to use open-source models or licensed platforms. One model lacks gender representation in datasets, while another is costly but inclusive.",
//             "question": "How should they make an ethical and inclusive tool selection decision?",
//             "options": [
//               "Choose the model that aligns with the majority of students' needs",
//               "Select the tool that has transparency in its dataset and design process, even if it costs more",
//               "Use whichever model passes basic functionality tests and monitor for ethical concerns later"
//             ],
//             "correctAnswer": 2,
//             "feedback": "Ethical AI selection must consider inclusion, fairness, and data integrity, even if it comes at a higher cost, to ensure equitable educational outcomes.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Tool Selection Based on Inclusion",
//               "description": "You are comparing two school teams choosing AI tutoring apps to determine which shows better AI selection practices for diverse student populations.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Team A: Prioritizes tools that represent diverse languages and gender perspectives, even if they cost more.",
//                   "options": [
//                     "This demonstrates inclusive AI selection",
//                     "This prioritizes ideology over functionality"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Team B: Selects the fastest, cheapest tool with minimal evaluation of representation or bias.",
//                   "options": [
//                     "This shows practical decision-making",
//                     "This ignores important equity considerations"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Team A considers representation and fairness, ensuring the AI tool serves all students effectively and equitably.",
//               "badEnding": "Team B's approach may result in tools that exclude or misrepresent certain student groups, perpetuating educational inequities."
//             }
//           },
//           {
//             "id": 44,
//             "title": "Human-AI Role Clarity",
//             "description": "Ms. Neelum integrates a planning AI that designs entire lesson plans. Her colleagues start depending on it without reviewing the content. She's concerned about the diminishing human judgment in pedagogy.",
//             "question": "How can Ms. Neelum promote responsible human-AI collaboration in teaching?",
//             "options": [
//               "Encourage total automation to reduce teacher workload",
//               "Stop using AI altogether to preserve traditional roles",
//               "Emphasize human judgment while using AI as a support tool"
//             ],
//             "correctAnswer": 3,
//             "feedback": "Teachers should retain pedagogical authority while using AI as a supportive and transparent aid, maintaining the essential human elements of education.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Role of Teachers with AI Assistants",
//               "description": "You are comparing two teachers using AI for lesson planning to determine who demonstrates stronger professional responsibility with AI tools.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Teacher Komal: Uses AI as a starting point but revises content based on learner needs and pedagogical judgment.",
//                   "options": [
//                     "This shows responsible AI collaboration",
//                     "This undermines AI efficiency"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Teacher Qasim: Follows AI suggestions exactly as generated without reviewing content or considering context.",
//                   "options": [
//                     "This maximizes AI benefits",
//                     "This shows over-dependence on AI"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Teacher Komal uses AI as support, not substitute, ensuring content fits her learners and maintains pedagogical expertise.",
//               "badEnding": "Teacher Qasim's approach diminishes professional judgment and may result in inappropriate or irrelevant lesson content."
//             }
//           },
//           {
//             "id": 45,
//             "title": "Student-Led Problem Solving Using AI",
//             "description": "In a problem-based learning module, students use an open-source AI model to identify causes of school dropouts in Gilgit. One student uses a biased dataset that blames only parental illiteracy.",
//             "question": "What guidance should the teacher provide to ensure responsible and balanced AI use in student projects?",
//             "options": [
//               "Approve the project without reviewing the dataset",
//               "Encourage critical examination of dataset bias and community impact",
//               "Replace AI with manual analysis to avoid bias"
//             ],
//             "correctAnswer": 2,
//             "feedback": "Critical thinking about datasets helps students identify bias and develop responsible AI practices while maintaining the learning benefits of AI tools.",
//             "activity": {
//               "type": "Interactive Simulation",
//               "name": "Dataset Evaluation in Student Projects",
//               "description": "You are comparing two student groups using AI in community problem-solving projects to determine which applies responsible AI practices.",
//               "scenes": [
//                 {
//                   "sceneNumber": 1,
//                   "description": "Group A: Selects their dataset critically, checking for bias and relevance, and validates findings with community members.",
//                   "options": [
//                     "This demonstrates responsible AI use",
//                     "This overcomplicated the project requirements"
//                   ]
//                 },
//                 {
//                   "sceneNumber": 2,
//                   "description": "Group B: Uses a dataset found online without validation and accepts AI conclusions without question.",
//                   "options": [
//                     "This shows efficient project completion",
//                     "This lacks critical evaluation skills"
//                   ]
//                 }
//               ],
//               "idealPath": "A-B",
//               "idealEnding": "Group A critically evaluates and adapts data, ensuring AI outcomes are accurate, unbiased, and meaningful to their community context.",
//               "badEnding": "Group B's approach may perpetuate harmful stereotypes and produce inaccurate conclusions about complex social issues."
//             }
//           }
//         ]
//       }
//     ]
//   }''';
//
//   static EducationModule getModule() {
//     final jsonData = json.decode(moduleJsonData);
//     return EducationModule.fromJson(jsonData);
//   }
//
//   // Legacy methods for backward compatibility
//   static Map<String, dynamic> getModuleData() {
//     return json.decode(moduleJsonData);
//   }
//
//   static List<Level> getLevels() {
//     return getModule().levels;
//   }
//
//   static List<Scenario> getScenariosByLevel(String levelName) {
//     final module = getModule();
//     final level = module.getLevelByName(levelName);
//     return level?.scenarios ?? [];
//   }
//
//   static String getModuleTitle() {
//     return getModule().moduleName;
//   }
//
//   static List<dynamic> getScenarios() {
//     final moduleData = getModuleData();
//     return moduleData['scenarios'] ?? [];
//   }
//
//   static String getModuleName() {
//     return getModule().moduleName;
//   }
//
//   // New helper methods using models
//   static Scenario? getScenarioById(int id) {
//     return getModule().getScenarioById(id);
//   }
//
//   static Level? getLevelByNumber(int levelNumber) {
//     return getModule().getLevelByNumber(levelNumber);
//   }
//
//   static List<Scenario> getAllScenarios() {
//     return getModule().allScenarios;
//   }
// }


import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager3 {

  static const String moduleJsonData = '''
  {
    "module": "Module 3",
    "levels": [
      {
         "level": "Level 1(Acquire)",
        "scenarios": [
          {
              "id": "1",
  "title": "What Makes a Tool Truly AI?",
  "description": "Ayesha, a pre-service teacher, is asked during her practicum to explain the difference between a rule-based grammar correction app and an AI-powered writing assistant. She's unsure how to define AI in educational tools. Which of the following best explains the difference?",
  "options": [
    "Both tools provide feedback, but one is more recent in design.",
    "Rule-based tools are part of AI because they follow programmed instructions.",
    "AI tools adjust their responses based on patterns in user input over time."
  ],
  "correctAnswer": "AI tools adjust their responses based on patterns in user input over time.",
  "feedback": "AI tools go beyond fixed rules—they analyze user data and improve their output over time, offering dynamic, personalized support. This adaptive behavior is what distinguishes them from static, rule-based educational software.",
  "activity": {
    "type": "Comparison",
    "name": "Which one is AI?",
    "description": "Compare the following two tools and select which one demonstrates characteristics of AI.",
    "scenes": [
      {
        "sceneNumber": "1",
        "description": "Tool A: An educational quiz app that shows hints and explanations for correct answers based on pre-programmed rules.",
        "options": [
          "This tool demonstrates AI characteristics",
          "This tool lacks AI capabilities"
        ]
      },
      {
        "sceneNumber": "2",
        "description": "Tool B: An intelligent writing assistant that suggests personalized feedback by analyzing the student's writing style over time.",
        "options": [
          "This tool demonstrates AI characteristics",
          "This tool lacks AI capabilities"
        ]
      }
    ],
    "idealPath": "Identify Tool B as AI because it adapts feedback based on student writing patterns.",
    "idealEnding": "Correct—Tool B demonstrates AI as it learns and evolves from user interactions.",
    "badEnding": "Incorrect—Tool A is rule-based and does not learn over time."
  }
},
  {
    "id": "2",
    "title": "Identifying AI vs Rule-Based Tools",
    "description": "Mr. Karim is teaching about AI and uses MS Word’s spellchecker and Google Translate as examples. A student asks if both are AI-based tools. Karim pauses, unsure how to respond. Which tool demonstrates actual AI functionality?",
    "options": [
      "Only Google Translate, because it adapts and improves through data.",
      "Both are AI because they correct language.",
      "Only MS Word’s spellchecker, because it follows pre-set rules."
    ],
    "correctAnswer": "Only Google Translate, because it adapts and improves through data.",
    "feedback": "Google Translate uses machine learning to improve translations over time, which is a core feature of AI. Spellcheckers rely on fixed rule sets and dictionaries, not adaptive algorithms.",
    "activity": {
      "type": "Comparison",
      "name": "Who’s really 'smart'?",
      "description": "Two apps help users improve language skills. Decide which one uses AI.",
      "scenes": [
        {
          "sceneNumber": 1,
          "description": "App A: Uses a list of grammar rules to underline mistakes and suggest corrections.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        },
        {
          "sceneNumber": 2,
          "description": "App B: Analyzes writing styles over time and starts giving personalized grammar and tone suggestions.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        }
      ],
      "idealPath": "Identify App B as AI because it adapts and learns from user writing data.",
      "idealEnding": "Correct—App B demonstrates AI through personalized and adaptive learning.",
      "badEnding": "Incorrect—App A is rule-based and does not learn over time."
    }
  },
  {
    "id": 3,
    "title": "Training Data and Algorithms",
    "description": "Shahid attends a workshop where he hears that AI tools like facial recognition use 'training data' and 'algorithms.' He wonders how these two work together. What best describes the role of training data in AI?",
    "options": [
      "Training data teaches the AI system to identify patterns through repeated exposure.",
      "Training data is irrelevant once the AI tool is deployed.",
      "Algorithms replace the need for training data."
    ],
    "correctAnswer": "Training data teaches the AI system to identify patterns through repeated exposure.",
    "feedback": "Training data helps the AI learn by recognizing and generalizing from patterns, which is essential for tasks like facial recognition.",
    "activity": {
      "type": "Comparison",
      "name": "How does the AI learn?",
      "description": "Compare these two systems and select which one relies on training data.",
      "scenes": [
        {
          "sceneNumber": 1,
          "description": "System A: A weather app that shows forecast based on real-time sensor input.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        },
        {
          "sceneNumber": 2,
          "description": "System B: An AI assistant that predicts what a user wants to do next, based on past user actions and data.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        }
      ],
      "idealPath": "Identify System B as AI because it uses training data to learn and predict.",
      "idealEnding": "Correct—System B demonstrates AI by learning from historical user data.",
      "badEnding": "Incorrect—System A reacts only to real-time input and does not learn patterns."
    }
  },
  {
    "id": 4,
    "title": "Identifying AI Tools",
    "description": "Mr. Naveed wants to introduce AI tools in his digital literacy class. He lists Grammarly, Google Translate, and a calculator. He’s not sure if all qualify as AI. Which of the following are true AI-based tools?",
    "options": [
      "All three tools are AI because they support learning.",
      "Only Grammarly and Google Translate, because they adapt based on user input.",
      "Only the calculator, as it is used in every classroom."
    ],
    "correctAnswer": "Only Grammarly and Google Translate, because they adapt based on user input.",
    "feedback": "Grammarly and Google Translate adapt to inputs and improve over time, showing AI characteristics. Calculators follow static, rule-based functions.",
    "activity": {
      "type": "Comparison",
      "name": "Which one uses AI?",
      "description": "You’re helping a school choose between two reading apps. Identify the one that uses AI.",
      "scenes": [
        {
          "sceneNumber": 1,
          "description": "App A: Reads a fixed set of stories aloud in a robotic voice with no customization.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        },
        {
          "sceneNumber": 2,
          "description": "App B: Analyzes a student’s reading pace and pronunciation errors and adjusts the story complexity accordingly.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        }
      ],
      "idealPath": "Identify App B as AI because it adapts reading difficulty based on student performance.",
      "idealEnding": "Correct—App B demonstrates AI through adaptive and personalized feedback.",
      "badEnding": "Incorrect—App A is pre-programmed and does not adapt to learners."
    }
  },
  {
    "id": 5,
    "title": "Tool Selection Based on Effectiveness",
    "description": "Saima tests two AI reading tools: one accurate but complex, the other easy but inconsistent. She wants to use the best option for early readers. How should she make her decision?",
    "options": [
      "Choose the one with better reviews online.",
      "Pick whichever is recommended by a friend.",
      "Look for an alternate tool that balances ease of use and reliability."
    ],
    "correctAnswer": "Look for an alternate tool that balances ease of use and reliability.",
    "feedback": "Effective educational tools must be both user-friendly and accurate, especially when used with young learners.",
    "activity": {
      "type": "Comparison",
      "name": "Which tool suits your learners?",
      "description": "You're choosing a tool for primary students learning vocabulary. Pick the most effective one.",
      "scenes": [
        {
          "sceneNumber": 1,
          "description": "Tool A: Offers correct definitions but has a complex interface and no audio.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        },
        {
          "sceneNumber": 2,
          "description": "Tool B: Includes voice narration and interactive games, though it sometimes gives slightly simplified meanings.",
          "options": [
            "This tool demonstrates AI characteristics",
            "This tool lacks AI capabilities"
          ]
        }
      ],
      "idealPath": "Identify Tool B as more effective because it engages learners with narration and interaction.",
      "idealEnding": "Correct—Tool B better supports young learners’ needs with interactive, accessible features.",
      "badEnding": "Incorrect—Tool A is too complex for young learners and lacks engagement."
    }
  }
]
      },
      {
       "level": "Level 2 (Deepen)",
        "scenarios": [
            {
            "id": 1,
            "title": "Predictive Grading Bias",
            "description": "Mr. Asim uses an AI-powered grading system in his English class. He notices students from rural schools are consistently marked lower in writing assignments despite strong content. On checking, he finds the model was trained mostly on urban student data.",
            "question": "What should Mr. Asim do to ensure fair grading for all students?",
            "options": [
              "Keep using the tool and adjust scores manually later.",
              "Ask students to change their writing style to match the training data.",
              "Analyze the dataset, discuss with the provider, and ask to retrain the tool."
            ],
            "correctAnswer": 3,
            "feedback": "This response reflects a deeper understanding of bias in training data and the ethical responsibility to ensure fairness and inclusivity in AI-powered assessment tools.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Fair Grading: Whose Data Counts?",
              "description": "Two schools use AI for grading essays. Compare their approaches.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "School A: Uses data from a wide range of student backgrounds, regularly updates the model, and reviews flagged results.",
                  "options": [
                    "This demonstrates ethical AI grading",
                    "This approach is unnecessarily complicated"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "School B: Trains its AI only on high-performing urban student essays and uses it without review.",
                  "options": [
                    "This ensures consistent high standards",
                    "This creates unfair bias in grading"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "School A demonstrates ethical AI use by including diverse data and human oversight, ensuring fair assessment for all students regardless of background.",
              "badEnding": "School B's approach creates systematic bias that unfairly disadvantages students from different backgrounds or writing styles."
            }
          },
          {
            "id": 2,
            "title": "Explaining the Inner Workings of an AI Feedback Tool",
            "description": "Ms. Hina, a pre-service teacher, is attending an AI-integrated teaching practicum. Her mentor asks her to explain how an AI essay feedback tool works, from submission to feedback. To help other teachers, she creates a simple visual guide showing how the tool is trained, what data it uses, and how it evaluates student writing.",
            "question": "Which of the following visual breakdowns would best demonstrate Ms. Hina's understanding of how the AI system works?",
            "options": [
              "A flowchart showing data collection, training with labeled essays, model application, and feedback output.",
              "A single image showing before-and-after versions of a student's essay.",
              "A list of generic AI terms like 'deep learning' and 'accuracy' without linking them to the tool."
            ],
            "correctAnswer": 1,
            "feedback": "This shows an understanding of the AI lifecycle—from data collection and model training to deployment—by visually mapping how input (student essays) is processed through an algorithm to provide adaptive feedback.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Understanding the AI Lifecycle",
              "description": "Two teachers use an AI-powered learning platform that generates personalized content for students based on their performance data.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Carefully reviews the tool's output reports and customizes assignments based on student progress charts.",
                  "options": [
                    "This shows deeper understanding of AI systems",
                    "This shows surface-level tool use"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Explores how the tool was trained, what types of data were used, and considers whether the content aligns with her learners' backgrounds before assigning it.",
                  "options": [
                    "This shows deeper understanding of AI systems",
                    "This shows surface-level tool use"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B demonstrates deeper understanding by analyzing the tool's design, training data, and contextual relevance before use. Understanding the AI lifecycle involves more than just using output—it's about critically evaluating how the system was trained.",
              "badEnding": "While Teacher A interprets data insights effectively, deeper AI understanding requires examining the system's development and training process."
            }
          },
          {
            "id": 3,
            "title": "Customizing a Behavior Monitoring Tool",
            "description": "Mr. Saleem, a pre-service teacher, is using a digital behavior monitoring tool that sends automated alerts to parents after every three incidents of disruptive behavior. He notices that some students are being flagged too quickly without context. The platform allows teachers to adjust the behavior rules using a simple if–then logic editor. Mr. Saleem considers revising the rule to include a time window (e.g., '3 incidents within 2 days') and exclude minor issues.",
            "question": "What should Mr. Saleem do to make the tool more effective and fair?",
            "options": [
              "Disable the alerts entirely and track everything manually.",
              "Keep the default rules and just explain to students how the system works.",
              "Customize the tool's logic using the rule editor."
            ],
            "correctAnswer": 3,
            "feedback": "Adapting the logic shows Mr. Saleem's ability to apply knowledge of data and rule-based systems to make AI tools more context-aware and supportive of students' needs.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Algorithm Awareness in Daily Use",
              "description": "Two teachers use classroom analytics to group students for a project.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Relies on default groupings generated by an algorithm based on recent test scores.",
                  "options": [
                    "This demonstrates better algorithmic understanding",
                    "This shows surface-level algorithm use"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Checks how the algorithm groups students, adds a condition, and adjusts based on classroom observations.",
                  "options": [
                    "This demonstrates better algorithmic understanding",
                    "This shows surface-level algorithm use"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B demonstrates better understanding by adapting automated logic based on context and professional role. Applying algorithmic understanding in context helps educators create more meaningful and equitable learning experiences.",
              "badEnding": "Teacher A's approach of following data-driven outputs without contextual adjustment shows surface-level algorithm use."
            }
          },
          {
            "id": 4,
            "title": "Predictive AI for Student Performance",
            "description": "Mr. Haris uses an AI tool that flags 'at-risk' students based on academic history. He notices it disproportionately targets students from under-resourced schools. This raises concerns about bias in the tool's training data and its effect on fairness.",
            "question": "What is the most responsible step Mr. Haris should take?",
            "options": [
              "Raise questions about the model's training data and its impact on equity before acting.",
              "Continue using the tool since it's based on real performance data.",
              "Ignore the predictions and manage the class using his own observations."
            ],
            "correctAnswer": 1,
            "feedback": "Understanding the ethics of AI means evaluating how biased training data can unfairly influence decisions, especially in diverse classroom settings.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Evaluating Data Bias in AI Tools",
              "description": "Two teachers use AI tools to monitor student progress.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Selects tools based solely on accuracy scores from developer reports.",
                  "options": [
                    "This demonstrates ethical AI evaluation",
                    "This lacks ethical consideration"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Examines what data the tool was trained on and whether it represents her students' backgrounds.",
                  "options": [
                    "This demonstrates ethical AI evaluation",
                    "This lacks ethical consideration"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B demonstrates a more ethical approach by considering data origin and fairness. Ethical use of AI requires looking beyond performance metrics to understand how training data can impact fairness, representation, and equity in the classroom.",
              "badEnding": "Teacher A's reliance on performance metrics alone without considering ethical implications shows incomplete AI evaluation."
            }
          },
          {
            "id": 5,
            "title": "Assessing Tool Appropriateness",
            "description": "A Vendors offer Mr. Nadeem several AI-based tutoring apps. He wants to ensure the tool he chooses is aligned with his curriculum and student needs.",
            "question": "How should he proceed?",
            "options": [
              "Select the most popular tool.",
              "Try them all randomly with students.",
              "Use evaluation criteria (e.g., transparency, accessibility, ethics) to compare and select."
            ],
            "correctAnswer": 3,
            "feedback": "This encourages structured evaluation of AI tools based on educational, ethical, and technical principles rather than popularity or trial-and-error approaches.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Choosing the Right AI Tool",
              "description": "Two teachers are selecting AI tutoring apps.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher Faiza: Uses a checklist to evaluate learning objectives, ethical impact, and user accessibility.",
                  "options": [
                    "This shows systematic tool evaluation",
                    "This approach is overly time-consuming"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher Yawar: Picks the app with the highest rating on the app store without further evaluation.",
                  "options": [
                    "This leverages crowd wisdom effectively",
                    "This lacks professional evaluation criteria"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Teacher Faiza applies evaluation criteria aligned to educational needs, ensuring the selected tool truly serves her students' learning goals. This demonstrates deeper professional AI evaluation.",
              "badEnding": "Teacher Yawar's reliance on popularity ratings may result in tools that don't match his specific curriculum or student needs."
            }
          }
        ]
        },
        {
         "level": "Level 3 (Create)",
        "scenarios": [
            {
            "id": 1,
            "title": "Co-Creating with Students",
            "description": "Ms. Sana introduces a block-based AI tool in her coding club and invites students to co-design a chatbot that can support peer learning. Some students suggest adding humor, while others raise privacy concerns about data logging.",
            "question": "How should Ms. Sana balance creativity, ethics, and student agency in this co-creation?",
            "options": [
              "Let students implement their ideas freely and address concerns if problems arise later",
              "Facilitate a structured co-design session where students reflect on design and ethical implications",
              "Use a ready-made chatbot template to limit risks while reducing student involvement"
            ],
            "correctAnswer": 2,
            "feedback": "Structured co-design with ethical reflection promotes ownership and responsibility in student-driven AI projects while ensuring thoughtful consideration of implications.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Ethical Co-Creation in AI Tools",
              "description": "Two teachers are introducing AI chatbots in their classrooms.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher Anila: Includes students in the design process, discussing privacy, tone, and use cases throughout development.",
                  "options": [
                    "This fosters ethical co-creation",
                    "This slows down the development process"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher Bashir: Builds the chatbot alone and asks students to use it without explanation of its design decisions.",
                  "options": [
                    "This ensures quality control",
                    "This limits student agency and learning"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Teacher Anila involves learners and fosters ethical awareness, creating ownership and understanding of responsible AI design principles. This demonstrates more ethical and inclusive co-creation.",
              "badEnding": "Teacher Bashir misses opportunities to develop students' critical thinking about AI ethics and design considerations."
            }
          },
          {
            "id": 2,
            "title": "Smart Tutoring System Design",
            "description": "Ms. Rabia is developing an AI tutor to predict student learning needs. The initial model uses standardized English exam data. She teaches in a bilingual region where students often write answers using both English and Urdu, and their reasoning style differs from that typically found in test formats.",
            "question": "How should she adapt the system for better alignment with her context?",
            "options": [
              "Preprocess student responses to fit the existing model's format",
              "Use translation tools to convert all inputs to standard English and use the English version.",
              "Explore training a model using local student data that reflects language use and expression patterns."
            ],
            "correctAnswer": 3,
            "feedback": "Designing context-aware AI systems requires aligning the model's training data and features with actual user behavior, including language, expression, and reasoning patterns.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Effective Model Training",
              "description": "Two teachers are preparing datasets to train an AI model for classroom use.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Uses a large dataset from a national repository that doesn't match the learning styles of her students.",
                  "options": [
                    "This dataset is more appropriate",
                    "This dataset lacks local relevance"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Uses a smaller but diverse set of local student responses that reflect real classroom behavior.",
                  "options": [
                    "This dataset is more appropriate",
                    "This dataset is too limited in size"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B's dataset is more appropriate because the data is locally relevant and context-aware. Training an AI model effectively isn't just about data size—it's about relevance. Using authentic, local data ensures the AI learns patterns that reflect actual user behavior and needs.",
              "badEnding": "Teacher A's large dataset from a national repository may not reflect local learning patterns and contexts, limiting the model's effectiveness."
            }
          },
          {
            "id": 3,
            "title": "Customizing AI for Localized Book Suggestions",
            "description": "A small-town library wants an AI tool to recommend books based on students past borrowing history, reading preferences, and local language choices (since many books are in regional languages). They have a dataset of past borrowings but need an affordable and efficient solution.",
            "question": "To build this AI book recommendation system, which of the following steps is most critical in ensuring the model works well for local needs?",
            "options": [
              "Data Preprocessing – Clean the borrowing data, handle missing entries, and normalize regional language text.",
              "Algorithm Selection – Choose a collaborative filtering model or a content-based approach.",
              "Model Fine-Tuning – Take an open-source recommendation model and train it on the library's dataset."
            ],
            "correctAnswer": 1,
            "feedback": "Without clean and well-structured data (especially for regional languages), even the best AI model will fail. Proper preprocessing ensures the model gets meaningful input.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Tool Selection Based on Inclusion",
              "description": "Two school teams are choosing an AI tutoring app.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Team A: Prioritizes tools that represent diverse languages and gender perspectives, even if they cost more.",
                  "options": [
                    "This demonstrates inclusive AI selection",
                    "This prioritizes ideology over functionality"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Team B: Selects the fastest, cheapest tool with minimal evaluation of representation or bias.",
                  "options": [
                    "This shows practical decision-making",
                    "This ignores important equity considerations"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Team A considers representation and fairness, ensuring the AI tool serves all students effectively and equitably. This shows better AI selection practices for diverse student populations.",
              "badEnding": "Team B's approach may result in tools that exclude or misrepresent certain student groups, perpetuating educational inequities."
            }
          },
          {
            "id": 4,
            "title": "Customizing an AI Grading Assistant",
            "description": "A school wants an AI tool to grade short essays in regional languages (e.g., Balochi and Urdu). They have a small dataset of 500 graded essays (some with errors), limited computing power (no high-end GPUs), and need quick, affordable results.",
            "question": "What is the most efficient technical approach to build this AI grader?",
            "options": [
              "Fine-tune an open-source LLM on the regional language essays.",
              "Train a neural network from scratch using the 500 essays.",
              "Use a pre-trained English GPT-4 API without adjustments."
            ],
            "correctAnswer": 1,
            "feedback": "Fine-tuning leverages existing AI models while adapting them to local needs—ideal for small datasets and low-resource settings.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "When to Train vs. Fine-Tune",
              "description": "Two teachers are working with small datasets in regional languages (about 500 examples each).",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Trains a neural network from scratch using 500 samples.",
                  "options": [
                    "This shows technical soundness",
                    "This approach has limitations for small data"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Fine-tunes a pre-trained transformer model with the same data on a basic laptop.",
                  "options": [
                    "This shows technical soundness",
                    "This approach lacks full model control"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B applies the most technically sound approach because fine-tuning uses fewer resources and performs better with small data. Training from scratch requires thousands of examples and high-end GPUs to avoid overfitting and poor generalization.",
              "badEnding": "Teacher A's approach may lead to overfitting with limited data and requires significantly more computational resources."
            }
          },
          {
            "id": 5,
            "title": "Student-Led Problem Solving Using AI",
            "description": "In a problem-based learning module, students use an open-source AI model to identify causes of school dropouts in Karachi. One student uses a biased dataset that blames only parental illiteracy.",
            "question": "What guidance should the teacher provide to ensure responsible and balanced AI use in student projects?",
            "options": [
              "Approve the project without reviewing the dataset",
              "Encourage critical examination of dataset bias and community impact",
              "Replace AI with manual analysis to avoid bias"
            ],
            "correctAnswer": 2,
            "feedback": "Critical thinking about datasets helps students identify bias and develop responsible AI practices while maintaining the learning benefits of AI tools.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Dataset Evaluation in Student Projects",
              "description": "Two student groups use AI in a community problem-solving project.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Group A: Selects their dataset critically, checking for bias and relevance, and validates findings with community members.",
                  "options": [
                    "This demonstrates responsible AI use",
                    "This overcomplicated the project requirements"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Group B: Uses a dataset found online without validation and accepts AI conclusions without question.",
                  "options": [
                    "This shows efficient project completion",
                    "This lacks critical evaluation skills"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Group A critically evaluates and adapts data, ensuring AI outcomes are accurate, unbiased, and meaningful to their community context. This applies responsible AI practices.",
              "badEnding": "Group B's approach may perpetuate harmful stereotypes and produce inaccurate conclusions about complex social issues."
            }
          }
        ]
        }
    ]
  }''';


  // static const String moduleJsonData = '''
  // {
  //   "module": "Module 3",
  //   "levels": [
  //     {
  //       "level": "Level 7 (Acquire)",
  //       "scenarios": [
  //         {
  //           "id": 31,
  //           "title": "Understanding AI Definition and Basic Concepts",
  //           "description": "Ayesha, a pre-service teacher, is asked during her practicum to explain the difference between a rule-based grammar correction app and an AI-powered writing assistant. She's unsure how to define AI in educational tools.",
  //           "question": "Which of the following best explains the difference?",
  //           "options": [
  //             "Both tools provide feedback, but one is more recent in design.",
  //             "Rule-based tools are part of AI because they follow programmed instructions.",
  //             "AI tools adjust their responses based on patterns in user input over time."
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "AI tools go beyond fixed rules—they analyze user data and improve their output over time, offering dynamic, personalized support. This adaptive behavior is what distinguishes them from static, rule-based educational software.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Which one is AI?",
  //             "description": "Compare the following two tools and select which one demonstrates characteristics of AI.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Tool A: An educational quiz app that shows hints and explanations for correct answers based on pre-programmed rules.",
  //                 "options": [
  //                   "This tool demonstrates AI characteristics",
  //                   "This tool lacks AI capabilities"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Tool B: An intelligent writing assistant that suggests personalized feedback by analyzing the student's writing style over time.",
  //                 "options": [
  //                   "This tool demonstrates AI characteristics",
  //                   "This tool lacks AI capabilities"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Tool B demonstrates AI characteristics because it analyzes patterns in individual student work and adapts its feedback accordingly, learning and evolving from user interaction. Tool A, while interactive, follows fixed rules and doesn't learn or improve over time.",
  //             "badEnding": "Tool A lacks the analytical and adaptive capabilities that characterize AI-powered educational tools."
  //           }
  //         },
  //         {
  //           "id": 32,
  //           "title": "Identifying AI vs Rule-Based Tools",
  //           "description": "Mr. Karim is teaching about AI and uses MS Word's spellchecker and Google Translate as examples. A student asks if both are AI-based tools. Karim pauses, unsure how to respond.",
  //           "question": "Which tool demonstrates actual AI functionality?",
  //           "options": [
  //             "Only Google Translate, because it adapts and improves through data.",
  //             "Both are AI because they correct language.",
  //             "Only MS Word's spellchecker, because it follows pre-set rules."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "Google Translate uses machine learning to improve translations over time, which is a core feature of AI. Spellcheckers rely on fixed rule sets and dictionaries, not adaptive algorithms.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Who's really smart?",
  //             "description": "Two apps help users improve language skills. Decide which one uses AI.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "App A: Uses a list of grammar rules to underline mistakes and suggest corrections.",
  //                 "options": [
  //                   "This app is AI-powered",
  //                   "This app uses rule-based correction"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "App B: Analyzes writing styles over time and starts giving personalized grammar and tone suggestions.",
  //                 "options": [
  //                   "This app is AI-powered",
  //                   "This app uses rule-based correction"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Personalized and adaptive features that improve with user data are signs of AI. App B is AI-powered because it learns from user patterns and adapts its suggestions accordingly.",
  //             "badEnding": "App A uses rule-based correction systems that follow predetermined patterns without learning or adaptation capabilities."
  //           }
  //         },
  //         {
  //           "id": 33,
  //           "title": "Training Data and Algorithms",
  //           "description": "Shahid attends a workshop where he hears that AI tools like facial recognition use 'training data' and 'algorithms.' He wonders how these two work together.",
  //           "question": "What best describes the role of training data in AI?",
  //           "options": [
  //             "Training data teaches the AI system to identify patterns through repeated exposure.",
  //             "Training data is irrelevant once the AI tool is deployed.",
  //             "Algorithms replace the need for training data."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "Training data helps the AI learn by recognizing and generalizing from patterns, which is essential for tasks like facial recognition and other AI applications.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "How does the AI learn?",
  //             "description": "Compare these two systems and select which one relies on training data.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "System A: A weather app that shows forecast based on real-time sensor input.",
  //                 "options": [
  //                   "This relies on training data to improve",
  //                   "This responds to current input without learning"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "System B: An AI assistant that predicts what a user wants to do next, based on past user actions and data.",
  //                 "options": [
  //                   "This relies on training data to improve",
  //                   "This responds to current input without learning"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "System B uses historical user data to identify patterns and make predictions, which is a hallmark of AI learning through training data.",
  //             "badEnding": "System A responds to current input without learning from past patterns, lacking the training data dependency of AI systems."
  //           }
  //         },
  //         {
  //           "id": 34,
  //           "title": "Identifying AI Tools",
  //           "description": "Mr. Naveed wants to introduce AI tools in his digital literacy class. He lists Grammarly, Google Translate, and a calculator. He's not sure if all qualify as AI.",
  //           "question": "Which of the following are true AI-based tools?",
  //           "options": [
  //             "All three tools are AI because they support learning.",
  //             "Only Grammarly and Google Translate, because they adapt based on user input.",
  //             "Only the calculator, as it is used in every classroom."
  //           ],
  //           "correctAnswer": 2,
  //           "feedback": "Grammarly and Google Translate adapt to inputs and improve over time, showing AI characteristics. Calculators follow static, rule-based functions without learning capabilities.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Which one uses AI?",
  //             "description": "You're helping a school choose between two reading apps. Identify the one that uses AI.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "App A: Reads a fixed set of stories aloud in a robotic voice with no customization.",
  //                 "options": [
  //                   "This app uses AI technology",
  //                   "This app lacks AI capabilities"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "App B: Analyzes a student's reading pace and pronunciation errors and adjusts the story complexity accordingly.",
  //                 "options": [
  //                   "This app uses AI technology",
  //                   "This app lacks AI capabilities"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "App B uses AI because it analyzes individual student behavior and adapts its responses, demonstrating intelligent, personalized decision-making based on data—key traits of AI systems.",
  //             "badEnding": "App A lacks the analytical and adaptive capabilities that characterize AI-powered educational tools."
  //           }
  //         },
  //         {
  //           "id": 35,
  //           "title": "Tool Selection Based on Effectiveness",
  //           "description": "Saima tests two AI reading tools: one accurate but complex, the other easy but inconsistent. She wants to use the best option for early readers.",
  //           "question": "How should she make her decision?",
  //           "options": [
  //             "Choose the one with better reviews online",
  //             "Pick whichever is recommended by a friend",
  //             "Look for an alternate tool that balances ease of use and reliability"
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "Effective educational tools must be both user-friendly and accurate, especially when used with young learners who need accessible yet reliable learning support.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Which tool suits your learners?",
  //             "description": "You're choosing a tool for primary students learning vocabulary. Pick the most effective one.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Tool A: Offers correct definitions but has a complex interface and no audio support.",
  //                 "options": [
  //                   "This tool is more effective for young learners",
  //                   "This tool lacks age-appropriate features"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Tool B: Includes voice narration and interactive games, though it sometimes gives slightly simplified meanings.",
  //                 "options": [
  //                   "This tool is more effective for young learners",
  //                   "This tool compromises accuracy for engagement"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Tool B better supports young learners through voice narration and interactive elements that match their developmental needs, even if definitions are simplified—making learning more accessible and engaging.",
  //             "badEnding": "Tool A's complexity and lack of interactive features make it less suitable for primary students despite its accuracy."
  //           }
  //         }
  //       ]
  //     },
  //     {
  //       "level": "Level 8 (Deepen)",
  //       "scenarios": [
  //         {
  //           "id": 36,
  //           "title": "Predictive Grading Bias",
  //           "description": "Mr. Asim uses an AI-powered grading system in his English class. He notices students from rural schools are consistently marked lower in writing assignments despite strong content. On checking, he finds the model was trained mostly on urban student data.",
  //           "question": "What should Mr. Asim do to ensure fair grading for all students?",
  //           "options": [
  //             "Keep using the tool and adjust scores manually later.",
  //             "Ask students to change their writing style to match the training data.",
  //             "Analyze the dataset, discuss with the provider, and ask to retrain the tool."
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "This response reflects a deeper understanding of bias in training data and the ethical responsibility to ensure fairness and inclusivity in AI-powered assessment tools.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Fair Grading: Whose Data Counts?",
  //             "description": "Two schools use AI for grading essays. Compare their approaches.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "School A: Uses data from a wide range of student backgrounds, regularly updates the model, and reviews flagged results.",
  //                 "options": [
  //                   "This demonstrates ethical AI grading",
  //                   "This approach is unnecessarily complicated"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "School B: Trains its AI only on high-performing urban student essays and uses it without review.",
  //                 "options": [
  //                   "This ensures consistent high standards",
  //                   "This creates unfair bias in grading"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "A-B",
  //             "idealEnding": "School A demonstrates ethical AI use by including diverse data and human oversight, ensuring fair assessment for all students regardless of background.",
  //             "badEnding": "School B's approach creates systematic bias that unfairly disadvantages students from different backgrounds or writing styles."
  //           }
  //         },
  //         {
  //           "id": 37,
  //           "title": "Explaining the Inner Workings of an AI Feedback Tool",
  //           "description": "Ms. Hina, a pre-service teacher, is attending an AI-integrated teaching practicum. Her mentor asks her to explain how an AI essay feedback tool works, from submission to feedback. To help other teachers, she creates a simple visual guide showing how the tool is trained, what data it uses, and how it evaluates student writing.",
  //           "question": "Which of the following visual breakdowns would best demonstrate Ms. Hina's understanding of how the AI system works?",
  //           "options": [
  //             "A flowchart showing data collection, training with labeled essays, model application, and feedback output.",
  //             "A single image showing before-and-after versions of a student's essay.",
  //             "A list of generic AI terms like 'deep learning' and 'accuracy' without linking them to the tool."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "This shows an understanding of the AI lifecycle—from data collection and model training to deployment—by visually mapping how input (student essays) is processed through an algorithm to provide adaptive feedback.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Understanding the AI Lifecycle",
  //             "description": "Two teachers use an AI-powered learning platform that generates personalized content for students based on their performance data.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher A: Carefully reviews the tool's output reports and customizes assignments based on student progress charts.",
  //                 "options": [
  //                   "This shows deeper understanding of AI systems",
  //                   "This shows surface-level tool use"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher B: Explores how the tool was trained, what types of data were used, and considers whether the content aligns with her learners' backgrounds before assigning it.",
  //                 "options": [
  //                   "This shows deeper understanding of AI systems",
  //                   "This shows surface-level tool use"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Teacher B demonstrates deeper understanding by analyzing the tool's design, training data, and contextual relevance before use. Understanding the AI lifecycle involves more than just using output—it's about critically evaluating how the system was trained.",
  //             "badEnding": "While Teacher A interprets data insights effectively, deeper AI understanding requires examining the system's development and training process."
  //           }
  //         },
  //         {
  //           "id": 38,
  //           "title": "Customizing a Behavior Monitoring Tool",
  //           "description": "Mr. Saleem, a pre-service teacher, is using a digital behavior monitoring tool that sends automated alerts to parents after every three incidents of disruptive behavior. He notices that some students are being flagged too quickly without context. The platform allows teachers to adjust the behavior rules using a simple if–then logic editor. Mr. Saleem considers revising the rule to include a time window (e.g., '3 incidents within 2 days') and exclude minor issues.",
  //           "question": "What should Mr. Saleem do to make the tool more effective and fair?",
  //           "options": [
  //             "Disable the alerts entirely and track everything manually.",
  //             "Keep the default rules and just explain to students how the system works.",
  //             "Customize the tool's logic using the rule editor."
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "Adapting the logic shows Mr. Saleem's ability to apply knowledge of data and rule-based systems to make AI tools more context-aware and supportive of students' needs.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Algorithm Awareness in Daily Use",
  //             "description": "Two teachers use classroom analytics to group students for a project.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher A: Relies on default groupings generated by an algorithm based on recent test scores.",
  //                 "options": [
  //                   "This demonstrates better algorithmic understanding",
  //                   "This shows surface-level algorithm use"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher B: Checks how the algorithm groups students, adds a condition, and adjusts based on classroom observations.",
  //                 "options": [
  //                   "This demonstrates better algorithmic understanding",
  //                   "This shows surface-level algorithm use"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Teacher B demonstrates better understanding by adapting automated logic based on context and professional role. Applying algorithmic understanding in context helps educators create more meaningful and equitable learning experiences.",
  //             "badEnding": "Teacher A's approach of following data-driven outputs without contextual adjustment shows surface-level algorithm use."
  //           }
  //         },
  //         {
  //           "id": 39,
  //           "title": "Predictive AI for Student Performance",
  //           "description": "Mr. Haris uses an AI tool that flags 'at-risk' students based on academic history. He notices it disproportionately targets students from under-resourced schools. This raises concerns about bias in the tool's training data and its effect on fairness.",
  //           "question": "What is the most responsible step Mr. Haris should take?",
  //           "options": [
  //             "Raise questions about the model's training data and its impact on equity before acting.",
  //             "Continue using the tool since it's based on real performance data.",
  //             "Ignore the predictions and manage the class using his own observations."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "Understanding the ethics of AI means evaluating how biased training data can unfairly influence decisions, especially in diverse classroom settings.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Evaluating Data Bias in AI Tools",
  //             "description": "Two teachers use AI tools to monitor student progress.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher A: Selects tools based solely on accuracy scores from developer reports.",
  //                 "options": [
  //                   "This demonstrates ethical AI evaluation",
  //                   "This lacks ethical consideration"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher B: Examines what data the tool was trained on and whether it represents her students' backgrounds.",
  //                 "options": [
  //                   "This demonstrates ethical AI evaluation",
  //                   "This lacks ethical consideration"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Teacher B demonstrates a more ethical approach by considering data origin and fairness. Ethical use of AI requires looking beyond performance metrics to understand how training data can impact fairness, representation, and equity in the classroom.",
  //             "badEnding": "Teacher A's reliance on performance metrics alone without considering ethical implications shows incomplete AI evaluation."
  //           }
  //         },
  //         {
  //           "id": 40,
  //           "title": "Assessing Tool Appropriateness",
  //           "description": "Vendors offer Mr. Nadeem several AI-based tutoring apps. He wants to ensure the tool he chooses is aligned with his curriculum and student needs.",
  //           "question": "How should he proceed?",
  //           "options": [
  //             "Select the most popular tool.",
  //             "Try them all randomly with students.",
  //             "Use evaluation criteria (e.g., transparency, accessibility, ethics) to compare and select."
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "This encourages structured evaluation of AI tools based on educational, ethical, and technical principles rather than popularity or trial-and-error approaches.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Choosing the Right AI Tool",
  //             "description": "Two teachers are selecting AI tutoring apps.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher Faiza: Uses a checklist to evaluate learning objectives, ethical impact, and user accessibility.",
  //                 "options": [
  //                   "This shows systematic tool evaluation",
  //                   "This approach is overly time-consuming"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher Yawar: Picks the app with the highest rating on the app store without further evaluation.",
  //                 "options": [
  //                   "This leverages crowd wisdom effectively",
  //                   "This lacks professional evaluation criteria"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "A-B",
  //             "idealEnding": "Teacher Faiza applies evaluation criteria aligned to educational needs, ensuring the selected tool truly serves her students' learning goals. This demonstrates deeper professional AI evaluation.",
  //             "badEnding": "Teacher Yawar's reliance on popularity ratings may result in tools that don't match his specific curriculum or student needs."
  //           }
  //         }
  //       ]
  //     },
  //     {
  //       "level": "Level 9 (Create)",
  //       "scenarios": [
  //         {
  //           "id": 41,
  //           "title": "Co-Creating with Students",
  //           "description": "Ms. Sana introduces a block-based AI tool in her coding club and invites students to co-design a chatbot that can support peer learning. Some students suggest adding humor, while others raise privacy concerns about data logging.",
  //           "question": "How should Ms. Sana balance creativity, ethics, and student agency in this co-creation?",
  //           "options": [
  //             "Let students implement their ideas freely and address concerns if problems arise later",
  //             "Facilitate a structured co-design session where students reflect on design and ethical implications",
  //             "Use a ready-made chatbot template to limit risks while reducing student involvement"
  //           ],
  //           "correctAnswer": 2,
  //           "feedback": "Structured co-design with ethical reflection promotes ownership and responsibility in student-driven AI projects while ensuring thoughtful consideration of implications.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Ethical Co-Creation in AI Tools",
  //             "description": "Two teachers are introducing AI chatbots in their classrooms.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher Anila: Includes students in the design process, discussing privacy, tone, and use cases throughout development.",
  //                 "options": [
  //                   "This fosters ethical co-creation",
  //                   "This slows down the development process"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher Bashir: Builds the chatbot alone and asks students to use it without explanation of its design decisions.",
  //                 "options": [
  //                   "This ensures quality control",
  //                   "This limits student agency and learning"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "A-B",
  //             "idealEnding": "Teacher Anila involves learners and fosters ethical awareness, creating ownership and understanding of responsible AI design principles. This demonstrates more ethical and inclusive co-creation.",
  //             "badEnding": "Teacher Bashir misses opportunities to develop students' critical thinking about AI ethics and design considerations."
  //           }
  //         },
  //         {
  //           "id": 42,
  //           "title": "Smart Tutoring System Design",
  //           "description": "Ms. Rabia is developing an AI tutor to predict student learning needs. The initial model uses standardized English exam data. She teaches in a bilingual region where students often write answers using both English and Urdu, and their reasoning style differs from that typically found in test formats.",
  //           "question": "How should she adapt the system for better alignment with her context?",
  //           "options": [
  //             "Preprocess student responses to fit the existing model's format",
  //             "Use translation tools to convert all inputs to standard English and use the English version.",
  //             "Explore training a model using local student data that reflects language use and expression patterns."
  //           ],
  //           "correctAnswer": 3,
  //           "feedback": "Designing context-aware AI systems requires aligning the model's training data and features with actual user behavior, including language, expression, and reasoning patterns.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Effective Model Training",
  //             "description": "Two teachers are preparing datasets to train an AI model for classroom use.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher A: Uses a large dataset from a national repository that doesn't match the learning styles of her students.",
  //                 "options": [
  //                   "This dataset is more appropriate",
  //                   "This dataset lacks local relevance"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher B: Uses a smaller but diverse set of local student responses that reflect real classroom behavior.",
  //                 "options": [
  //                   "This dataset is more appropriate",
  //                   "This dataset is too limited in size"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Teacher B's dataset is more appropriate because the data is locally relevant and context-aware. Training an AI model effectively isn't just about data size—it's about relevance. Using authentic, local data ensures the AI learns patterns that reflect actual user behavior and needs.",
  //             "badEnding": "Teacher A's large dataset from a national repository may not reflect local learning patterns and contexts, limiting the model's effectiveness."
  //           }
  //         },
  //         {
  //           "id": 43,
  //           "title": "Customizing AI for Localized Book Suggestions",
  //           "description": "A small-town library wants an AI tool to recommend books based on students past borrowing history, reading preferences, and local language choices (since many books are in regional languages). They have a dataset of past borrowings but need an affordable and efficient solution.",
  //           "question": "To build this AI book recommendation system, which of the following steps is most critical in ensuring the model works well for local needs?",
  //           "options": [
  //             "Data Preprocessing – Clean the borrowing data, handle missing entries, and normalize regional language text.",
  //             "Algorithm Selection – Choose a collaborative filtering model (like k-NN) or a content-based approach (like TF-IDF).",
  //             "Model Fine-Tuning – Take an open-source recommendation model (like LightFM) and train it on the library's dataset."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "Without clean and well-structured data (especially for regional languages), even the best AI model will fail. Proper preprocessing ensures the model gets meaningful input.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Tool Selection Based on Inclusion",
  //             "description": "Two school teams are choosing an AI tutoring app.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Team A: Prioritizes tools that represent diverse languages and gender perspectives, even if they cost more.",
  //                 "options": [
  //                   "This demonstrates inclusive AI selection",
  //                   "This prioritizes ideology over functionality"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Team B: Selects the fastest, cheapest tool with minimal evaluation of representation or bias.",
  //                 "options": [
  //                   "This shows practical decision-making",
  //                   "This ignores important equity considerations"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "A-B",
  //             "idealEnding": "Team A considers representation and fairness, ensuring the AI tool serves all students effectively and equitably. This shows better AI selection practices for diverse student populations.",
  //             "badEnding": "Team B's approach may result in tools that exclude or misrepresent certain student groups, perpetuating educational inequities."
  //           }
  //         },
  //         {
  //           "id": 44,
  //           "title": "Customizing an AI Grading Assistant",
  //           "description": "A school wants an AI tool to grade short essays in regional languages (e.g., Balochi and Urdu). They have a small dataset of 500 graded essays (some with errors), limited computing power (no high-end GPUs), and need quick, affordable results.",
  //           "question": "What is the most efficient technical approach to build this AI grader?",
  //           "options": [
  //             "Fine-tune an open-source LLM (like Mistral or BERT) on the regional language essays.",
  //             "Train a neural network from scratch using the 500 essays.",
  //             "Use a pre-trained English GPT-4 API without adjustments."
  //           ],
  //           "correctAnswer": 1,
  //           "feedback": "Fine-tuning leverages existing AI models while adapting them to local needs—ideal for small datasets and low-resource settings.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "When to Train vs. Fine-Tune",
  //             "description": "Two teachers are working with small datasets in regional languages (about 500 examples each).",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Teacher A: Trains a neural network from scratch using 500 samples.",
  //                 "options": [
  //                   "This shows technical soundness",
  //                   "This approach has limitations for small data"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Teacher B: Fine-tunes a pre-trained transformer model (e.g., mBERT or DistilBERT) with the same data on a basic laptop.",
  //                 "options": [
  //                   "This shows technical soundness",
  //                   "This approach lacks full model control"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "B-A",
  //             "idealEnding": "Teacher B applies the most technically sound approach because fine-tuning uses fewer resources and performs better with small data. Training from scratch requires thousands of examples and high-end GPUs to avoid overfitting and poor generalization.",
  //             "badEnding": "Teacher A's approach may lead to overfitting with limited data and requires significantly more computational resources."
  //           }
  //         },
  //         {
  //           "id": 45,
  //           "title": "Student-Led Problem Solving Using AI",
  //           "description": "In a problem-based learning module, students use an open-source AI model to identify causes of school dropouts in Karachi. One student uses a biased dataset that blames only parental illiteracy.",
  //           "question": "What guidance should the teacher provide to ensure responsible and balanced AI use in student projects?",
  //           "options": [
  //             "Approve the project without reviewing the dataset",
  //             "Encourage critical examination of dataset bias and community impact",
  //             "Replace AI with manual analysis to avoid bias"
  //           ],
  //           "correctAnswer": 2,
  //           "feedback": "Critical thinking about datasets helps students identify bias and develop responsible AI practices while maintaining the learning benefits of AI tools.",
  //           "activity": {
  //             "type": "Interactive Simulation",
  //             "name": "Dataset Evaluation in Student Projects",
  //             "description": "Two student groups use AI in a community problem-solving project.",
  //             "scenes": [
  //               {
  //                 "sceneNumber": 1,
  //                 "description": "Group A: Selects their dataset critically, checking for bias and relevance, and validates findings with community members.",
  //                 "options": [
  //                   "This demonstrates responsible AI use",
  //                   "This overcomplicated the project requirements"
  //                 ]
  //               },
  //               {
  //                 "sceneNumber": 2,
  //                 "description": "Group B: Uses a dataset found online without validation and accepts AI conclusions without question.",
  //                 "options": [
  //                   "This shows efficient project completion",
  //                   "This lacks critical evaluation skills"
  //                 ]
  //               }
  //             ],
  //             "idealPath": "A-B",
  //             "idealEnding": "Group A critically evaluates and adapts data, ensuring AI outcomes are accurate, unbiased, and meaningful to their community context. This applies responsible AI practices.",
  //             "badEnding": "Group B's approach may perpetuate harmful stereotypes and produce inaccurate conclusions about complex social issues."
  //           }
  //         }
  //       ]
  //     }
  //   ]
  // }''';

  static EducationModule getModule() {
    final jsonData = json.decode(moduleJsonData);
    return EducationModule.fromJson(jsonData);
  }

  // Legacy methods for backward compatibility
  static Map<String, dynamic> getModuleData() {
    return json.decode(moduleJsonData);
  }

  static List<Level> getLevels() {
    return getModule().levels;
  }

  static List<Scenario> getScenariosByLevel(String levelName) {
    final module = getModule();
    final level = module.getLevelByName(levelName);
    return level?.scenarios ?? [];
  }

  static String getModuleTitle() {
    return getModule().moduleName;
  }

  static List<dynamic> getScenarios() {
    final moduleData = getModuleData();
    return moduleData['scenarios'] ?? [];
  }

  static String getModuleName() {
    return getModule().moduleName;
  }

  // New helper methods using models
  static Scenario? getScenarioById(int id) {
    return getModule().getScenarioById(id);
  }

  static Level? getLevelByNumber(int levelNumber) {
    return getModule().getLevelByNumber(levelNumber);
  }

  static List<Scenario> getAllScenarios() {
    return getModule().allScenarios;
  }
}