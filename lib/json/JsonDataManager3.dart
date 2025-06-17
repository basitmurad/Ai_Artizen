import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager3 {
  static const String moduleJsonData = '''
  {
    "module": "Module 3",
    "levels": [
      {
        "level": "Level 1 (Acquire)",
        "scenarios": [
          {
            "id": 31,
            "title": "Understanding AI Definition and Basic Concepts",
            "description": "Ayesha, a pre-service teacher, is asked by her mentor to explain the difference between a basic calculator and an AI-powered chatbot used for student queries. She's unsure how to define AI in simple terms.",
            "question": "Which of the following best explains the difference?",
            "options": [
              "A calculator can make decisions like a chatbot.",
              "A chatbot uses data and algorithms to simulate human-like conversation.",
              "Both perform the same function in different forms."
            ],
            "correctAnswer": 2,
            "feedback": "A chatbot uses data and algorithms to simulate human-like conversation, demonstrating adaptive behavior and learning from interaction, which are key features of artificial intelligence. In contrast, calculators follow static rules without learning or adapting.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Which one is AI?",
              "description": "You are comparing two tools to determine which one qualifies as AI and demonstrates artificial intelligence characteristics.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Tool A: A math app that solves equations using built-in formulas and always gives the same answer.",
                  "options": [
                    "This demonstrates AI characteristics",
                    "This follows static rules without learning"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Tool B: A chatbot that adapts its replies based on user questions and previous interactions.",
                  "options": [
                    "This demonstrates AI characteristics",
                    "This follows static rules without learning"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Tool B demonstrates AI because it uses adaptive behavior and learns from interaction, which are key features of artificial intelligence. In contrast, Tool A follows static rules without learning or adapting.",
              "badEnding": "Tool A lacks the adaptive and learning capabilities that define artificial intelligence systems."
            }
          },
          {
            "id": 32,
            "title": "Identifying AI vs Rule-Based Tools",
            "description": "Mr. Karim is teaching about AI and uses MS Word's spellchecker and Google Translate as examples. A student asks if both are AI-based tools. Karim pauses, unsure how to respond.",
            "question": "Which tool demonstrates actual AI functionality?",
            "options": [
              "Both are AI because they correct language.",
              "Only MS Word's spellchecker, because it follows pre-set rules.",
              "Only Google Translate, because it adapts and improves through data."
            ],
            "correctAnswer": 3,
            "feedback": "Google Translate uses machine learning to improve translations over time, which is a core feature of AI. Spellcheckers rely on fixed rule sets and dictionaries, not adaptive algorithms.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Who's really smart?",
              "description": "You are comparing two language learning apps to determine which one uses AI technology for personalized learning.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "App A: Uses a list of grammar rules to underline mistakes and suggest corrections.",
                  "options": [
                    "This app is AI-powered",
                    "This app uses rule-based correction"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "App B: Analyzes writing styles over time and starts giving personalized grammar and tone suggestions.",
                  "options": [
                    "This app is AI-powered",
                    "This app uses rule-based correction"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Personalized and adaptive features that improve with user data are signs of AI. App B demonstrates artificial intelligence through its ability to learn and adapt.",
              "badEnding": "Rule-based correction systems like App A follow predetermined patterns without learning or adaptation capabilities."
            }
          },
          {
            "id": 33,
            "title": "Training Data and Algorithms",
            "description": "Shahid attends a workshop where he hears that AI tools like facial recognition use 'training data' and 'algorithms.' He wonders how these two work together.",
            "question": "What best describes the role of training data in AI?",
            "options": [
              "Training data teaches the AI system to identify patterns through repeated exposure.",
              "Training data is irrelevant once the AI tool is deployed.",
              "Algorithms replace the need for training data."
            ],
            "correctAnswer": 1,
            "feedback": "Training data helps the AI learn by recognizing and generalizing from patterns, which is essential for tasks like facial recognition and other AI applications.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "How does the AI learn?",
              "description": "You are comparing two systems to determine which one relies on training data to improve its performance over time.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "System A: A weather app that shows forecast based on real-time sensor input.",
                  "options": [
                    "This relies on training data to improve",
                    "This responds to current input without learning"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "System B: An AI assistant that predicts what a user wants to do next, based on past user actions and data.",
                  "options": [
                    "This relies on training data to improve",
                    "This responds to current input without learning"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "System B uses historical user data to identify patterns and make predictions, which is a hallmark of AI learning through training data.",
              "badEnding": "System A responds to current input without learning from past patterns, lacking the training data dependency of AI systems."
            }
          },
          {
            "id": 34,
            "title": "Identifying AI Tools",
            "description": "Mr. Naveed wants to introduce AI tools in his digital literacy class. He lists Grammarly, Google Translate, and a calculator. He's not sure if all qualify as AI.",
            "question": "Which of the following are true AI-based tools?",
            "options": [
              "All three tools are AI because they support learning.",
              "Only Grammarly and Google Translate, because they adapt based on user input.",
              "Only the calculator, as it is used in every classroom."
            ],
            "correctAnswer": 2,
            "feedback": "Grammarly and Google Translate adapt to inputs and improve over time, showing AI characteristics. Calculators follow static, rule-based functions without learning capabilities.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Which one uses AI?",
              "description": "You are helping a school choose between two reading apps by identifying which one uses artificial intelligence technology.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "App A: Reads a fixed set of stories aloud in a robotic voice with no customization.",
                  "options": [
                    "This app uses AI technology",
                    "This app lacks AI capabilities"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "App B: Analyzes a student's reading pace and pronunciation errors and adjusts the story complexity accordingly.",
                  "options": [
                    "This app uses AI technology",
                    "This app lacks AI capabilities"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "App B uses AI because it analyzes individual student behavior and adapts its responses, demonstrating intelligent, personalized decision-making based on data—key traits of AI systems.",
              "badEnding": "App A lacks the analytical and adaptive capabilities that characterize AI-powered educational tools."
            }
          },
          {
            "id": 35,
            "title": "Tool Selection Based on Effectiveness",
            "description": "Saima tests two AI reading tools: one accurate but complex, the other easy but inconsistent. She wants to use the best option for early readers.",
            "question": "How should she make her decision?",
            "options": [
              "Choose the one with better reviews online",
              "Select the tool that balances ease of use and reliability",
              "Pick whichever is recommended by a friend"
            ],
            "correctAnswer": 2,
            "feedback": "Effective educational tools must be both user-friendly and accurate, especially when used with young learners who need accessible yet reliable learning support.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Which tool suits your learners?",
              "description": "You are choosing a vocabulary tool for primary students and need to pick the most effective option for young learners.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Tool A: Offers correct definitions but has a complex interface and no audio support.",
                  "options": [
                    "This tool is more effective for young learners",
                    "This tool lacks age-appropriate features"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Tool B: Includes voice narration and interactive games, though it sometimes gives slightly simplified meanings.",
                  "options": [
                    "This tool is more effective for young learners",
                    "This tool compromises accuracy for engagement"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Tool B better supports young learners through voice narration and interactive elements that match their developmental needs, even if definitions are simplified—making learning more accessible and engaging.",
              "badEnding": "Tool A's complexity and lack of interactive features make it less suitable for primary students despite its accuracy."
            }
          }
        ]
      },
      {
        "level": "Level 2 (Deepen)",
        "scenarios": [
          {
            "id": 36,
            "title": "Predictive Grading Bias",
            "description": "Mr. Asim uses an AI-powered grading system in his English class. He notices students from rural schools are consistently marked lower in writing assignments despite strong content. On checking, he finds the model was trained mostly on urban student data.",
            "question": "What should Mr. Asim do to ensure fair grading for all students?",
            "options": [
              "Keep using the tool and adjust scores manually later.",
              "Ask students to change their writing style to match the training data.",
              "Analyze the dataset, discuss with the provider, and advocate for a retrained or alternative tool."
            ],
            "correctAnswer": 3,
            "feedback": "This response reflects a deeper understanding of bias in training data and the ethical responsibility to ensure fairness and inclusivity in AI-powered assessment tools.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Fair Grading: Whose Data Counts?",
              "description": "You are comparing two schools' approaches to AI grading to determine which demonstrates more ethical and fair use of AI assessment tools.",
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
            "id": 37,
            "title": "Misleading Recommendations",
            "description": "Mr. Bilal uses an AI tool that suggests different learning resources based on student profiles. He finds that students labeled as 'slow learners' are only recommended basic materials, regardless of their progress.",
            "question": "How should Mr. Bilal respond to this issue?",
            "options": [
              "Use the AI tool for all recommendations regardless.",
              "Rely on his judgment to override AI suggestions when needed.",
              "Analyze how the tool makes decisions and balance AI output with his own assessments."
            ],
            "correctAnswer": 3,
            "feedback": "This demonstrates the teacher's ability to evaluate AI recommendation logic and apply it responsibly in practice, ensuring students receive appropriate challenges.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Smart Teaching or Blind Trust?",
              "description": "You are comparing two teachers using AI-based learning resource tools to determine who demonstrates deeper understanding and responsible AI use.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher A: Accepts all AI recommendations and assigns them directly to students without review.",
                  "options": [
                    "This demonstrates efficient AI use",
                    "This shows over-reliance on AI"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher B: Checks the logic behind recommendations, adapts them to students' progress, and provides feedback.",
                  "options": [
                    "This demonstrates responsible AI use",
                    "This undermines the AI system's efficiency"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Teacher B balances AI insights with professional judgment, ensuring recommendations serve actual student needs rather than algorithmic assumptions.",
              "badEnding": "Teacher A's blind trust in AI recommendations may perpetuate unfair limitations on student potential and growth."
            }
          },
          {
            "id": 38,
            "title": "Privacy in Data Sharing",
            "description": "Ms. Hina uses an AI writing tool that stores and learns from student submissions. She discovers that some essays were accessible through online search.",
            "question": "What should Ms. Hina prioritize in her response?",
            "options": [
              "Warn students to avoid personal content in essays.",
              "Continue using the tool without changes.",
              "Pause tool usage, review data handling policies, and report the breach."
            ],
            "correctAnswer": 3,
            "feedback": "This reinforces data privacy and student protection responsibilities, emphasizing the need for immediate action when student data is compromised.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Whose Essay Is It Anyway?",
              "description": "You are comparing two educators' approaches to AI writing tools to determine who practices more responsible and ethical AI use regarding student data.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Educator A: Checks the tool's privacy policy, obtains student consent, and ensures anonymized data.",
                  "options": [
                    "This shows responsible data practices",
                    "This creates unnecessary barriers to tool use"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Educator B: Starts using the tool without checking how student essays are stored or shared.",
                  "options": [
                    "This enables quick implementation",
                    "This ignores critical privacy concerns"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Educator A prioritizes transparency and student rights, ensuring that AI tool use respects privacy and maintains trust.",
              "badEnding": "Educator B's approach risks exposing student work and violating privacy, potentially causing serious harm to students."
            }
          },
          {
            "id": 39,
            "title": "Ethical Implications of AI Surveillance",
            "description": "To reduce cheating, Mr. Tariq activates an AI proctoring tool that tracks eye movement and facial expressions. Students report anxiety and claim they are unfairly flagged.",
            "question": "What should Mr. Tariq consider?",
            "options": [
              "Keep using the tool to maintain discipline.",
              "Ask students not to worry about alerts.",
              "Evaluate the psychological impact and explore less intrusive solutions."
            ],
            "correctAnswer": 3,
            "feedback": "This emphasizes ethical judgment in choosing and applying AI tools, considering the broader impact on student wellbeing and learning environment.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Watchful Eyes",
              "description": "You are comparing two schools' approaches to AI exam monitoring to determine which is more aligned with ethical AI principles.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "School X: Informs students about surveillance, allows opt-outs, and tests for bias in the monitoring system.",
                  "options": [
                    "This approach respects student rights",
                    "This approach is too lenient on cheating"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "School Y: Monitors students using eye tracking and facial recognition without disclosure or consent options.",
                  "options": [
                    "This ensures comprehensive monitoring",
                    "This violates ethical AI principles"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "School X prioritizes informed consent and student wellbeing while still maintaining academic integrity through transparent, ethical AI use.",
              "badEnding": "School Y's intrusive surveillance creates anxiety and violates student agency, potentially harming the learning environment."
            }
          },
          {
            "id": 40,
            "title": "Assessing Tool Appropriateness",
            "description": "Vendors offer Mr. Nadeem several AI-based tutoring apps. He wants to ensure the tool he chooses is aligned with his curriculum and student needs.",
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
              "description": "You are comparing two teachers' approaches to selecting AI tutoring apps to determine who demonstrates deeper professional AI evaluation.",
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
              "idealEnding": "Teacher Faiza applies evaluation criteria aligned to educational needs, ensuring the selected tool truly serves her students' learning goals.",
              "badEnding": "Teacher Yawar's reliance on popularity ratings may result in tools that don't match his specific curriculum or student needs."
            }
          }
        ]
      },
      {
        "level": "Level 3 (Create)",
        "scenarios": [
          {
            "id": 41,
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
              "description": "You are comparing two teachers introducing AI chatbots in their classrooms to determine who demonstrates more ethical and inclusive co-creation practices.",
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
              "idealEnding": "Teacher Anila involves learners and fosters ethical awareness, creating ownership and understanding of responsible AI design principles.",
              "badEnding": "Teacher Bashir misses opportunities to develop students' critical thinking about AI ethics and design considerations."
            }
          },
          {
            "id": 42,
            "title": "Ethical Algorithm Tweaking",
            "description": "While customizing an AI-based reading level detector, Ms. Farida realizes it underestimates the performance of students with learning disabilities. She plans to tweak the model's algorithmic weights.",
            "question": "What ethical concerns should she address before modifying the AI system?",
            "options": [
              "Whether students with disabilities should be evaluated using different criteria",
              "If adjusting the algorithm could unintentionally marginalize other learner groups",
              "How to increase the model's speed while reducing complexity"
            ],
            "correctAnswer": 2,
            "feedback": "Algorithmic fairness requires a careful balance to prevent unintended bias against any student group while addressing known inequities.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Balancing Accuracy and Fairness",
              "description": "You are comparing two teachers using AI to assess student reading levels to determine who demonstrates a responsible approach to AI customization.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher Rabia: Notices unfair results and adjusts the model after consulting diverse student data and checking for unintended consequences.",
                  "options": [
                    "This shows responsible AI customization",
                    "This creates unnecessary complexity"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher Saqib: Sticks to default settings to avoid tampering with the system, despite noticing bias.",
                  "options": [
                    "This maintains system integrity",
                    "This ignores ethical responsibility"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Teacher Rabia actively checks for fairness and makes thoughtful adjustments, demonstrating responsible AI customization that serves all students.",
              "badEnding": "Teacher Saqib's inaction perpetuates bias and fails to address known inequities in the AI system."
            }
          },
          {
            "id": 43,
            "title": "Inclusive Design Decisions",
            "description": "A group of teachers in Hunza develop an AI tutor and debate whether to use open-source models or licensed platforms. One model lacks gender representation in datasets, while another is costly but inclusive.",
            "question": "How should they make an ethical and inclusive tool selection decision?",
            "options": [
              "Choose the model that aligns with the majority of students' needs",
              "Select the tool that has transparency in its dataset and design process, even if it costs more",
              "Use whichever model passes basic functionality tests and monitor for ethical concerns later"
            ],
            "correctAnswer": 2,
            "feedback": "Ethical AI selection must consider inclusion, fairness, and data integrity, even if it comes at a higher cost, to ensure equitable educational outcomes.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Tool Selection Based on Inclusion",
              "description": "You are comparing two school teams choosing AI tutoring apps to determine which shows better AI selection practices for diverse student populations.",
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
              "idealEnding": "Team A considers representation and fairness, ensuring the AI tool serves all students effectively and equitably.",
              "badEnding": "Team B's approach may result in tools that exclude or misrepresent certain student groups, perpetuating educational inequities."
            }
          },
          {
            "id": 44,
            "title": "Human-AI Role Clarity",
            "description": "Ms. Neelum integrates a planning AI that designs entire lesson plans. Her colleagues start depending on it without reviewing the content. She's concerned about the diminishing human judgment in pedagogy.",
            "question": "How can Ms. Neelum promote responsible human-AI collaboration in teaching?",
            "options": [
              "Encourage total automation to reduce teacher workload",
              "Stop using AI altogether to preserve traditional roles",
              "Emphasize human judgment while using AI as a support tool"
            ],
            "correctAnswer": 3,
            "feedback": "Teachers should retain pedagogical authority while using AI as a supportive and transparent aid, maintaining the essential human elements of education.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Role of Teachers with AI Assistants",
              "description": "You are comparing two teachers using AI for lesson planning to determine who demonstrates stronger professional responsibility with AI tools.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Teacher Komal: Uses AI as a starting point but revises content based on learner needs and pedagogical judgment.",
                  "options": [
                    "This shows responsible AI collaboration",
                    "This undermines AI efficiency"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Teacher Qasim: Follows AI suggestions exactly as generated without reviewing content or considering context.",
                  "options": [
                    "This maximizes AI benefits",
                    "This shows over-dependence on AI"
                  ]
                }
              ],
              "idealPath": "A-B",
              "idealEnding": "Teacher Komal uses AI as support, not substitute, ensuring content fits her learners and maintains pedagogical expertise.",
              "badEnding": "Teacher Qasim's approach diminishes professional judgment and may result in inappropriate or irrelevant lesson content."
            }
          },
          {
            "id": 45,
            "title": "Student-Led Problem Solving Using AI",
            "description": "In a problem-based learning module, students use an open-source AI model to identify causes of school dropouts in Gilgit. One student uses a biased dataset that blames only parental illiteracy.",
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
              "description": "You are comparing two student groups using AI in community problem-solving projects to determine which applies responsible AI practices.",
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
              "idealEnding": "Group A critically evaluates and adapts data, ensuring AI outcomes are accurate, unbiased, and meaningful to their community context.",
              "badEnding": "Group B's approach may perpetuate harmful stereotypes and produce inaccurate conclusions about complex social issues."
            }
          }
        ]
      }
    ]
  }''';

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