import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager4 {
  static const String moduleJsonData = '''
  {
  "module": "Module 4",
  "levels": [
    {
      "level": "Level 10 (Acquire)",
      "scenarios": [
        {
          "id": 46,
          "title": "AI Lesson Planner Confusion",
          "description": "Zara uses an AI-powered lesson planner. It suggests activities aligned with the national curriculum, but they seem too advanced for her Grade 4 students.",
          "question": "What is the most appropriate way for Zara to proceed?",
          "options": [
            "Trust the AI suggestions since they're curriculum-aligned and save time.",
            "Skip the tool for now and design the lesson from scratch.",
            "Analyze the suggestions, adjust them for her students' level, and evaluate during practice."
          ],
          "correctAnswer": 3,
          "feedback": "Adapting AI-generated suggestions based on learner needs reflects effective pedagogical judgment and responsible tool use.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Adapt or Not?",
            "cards": [
              {
                "statement": "An AI suggests an activity meant for Grade 8 students, but the teacher is teaching Grade 5.",
                "correct": "Unfair",
                "feedback": "Blindly following AI without adapting to learners' levels can lead to confusion. Responsible teaching includes tailoring AI suggestions to your classroom context."
              },
              {
                "statement": "The teacher modifies the AI-generated lesson to better suit her multilingual students.",
                "correct": "Fair",
                "feedback": "Customizing AI content to meet students' language and learning needs shows good pedagogy and a human-centred mindset."
              },
              {
                "statement": "The AI lesson plan includes culturally inappropriate content, but the teacher skips reviewing it.",
                "correct": "Unfair",
                "feedback": "Teachers should always vet AI-generated materials. Neglecting this can undermine inclusivity and trust."
              }
            ],
            "completionMessage": "Great job! AI tools are helpful, but it's your teacher judgment that ensures relevance, fairness, and student success."
          }
        },
        {
          "id": 47,
          "title": "Cross-Subject AI Use",
          "description": "Fatima wants to promote AI use across subjects in a peer training session. She plans to showcase tools that she used in her English class.",
          "question": "What strategy would best help her peers apply the tools in other subjects?",
          "options": [
            "Present her lesson in detail and ask peers to replicate it.",
            "Show the lesson, then co-design examples with peers for math, science, or languages.",
            "Recommend each teacher find their own way of using the tool."
          ],
          "correctAnswer": 2,
          "feedback": "Collaboratively building cross-subject examples ensures deeper understanding of AI's pedagogical transferability.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Transferable or Not?",
            "cards": [
              {
                "statement": "A math teacher uses an AI diagram tool originally made for biology to illustrate geometric shapes.",
                "correct": "Fair",
                "feedback": "Using AI creatively across subjects shows flexible thinking and supports interdisciplinary learning."
              },
              {
                "statement": "An AI quiz generator designed for English is used without checking its suitability for science terms.",
                "correct": "Unfair",
                "feedback": "AI tools must be context-checked. Not all tools transfer well without adaptation."
              },
              {
                "statement": "The teacher trains students to use one AI tool for multiple subjects with slight modifications.",
                "correct": "Fair",
                "feedback": "Helping students apply AI tools across subjects builds their digital fluency and promotes efficient learning."
              }
            ],
            "completionMessage": "Well done! Knowing when and how to transfer AI use across subjects is part of thoughtful, student-centred teaching."
          }
        },
        {
          "id": 48,
          "title": "Ethical Use of Chatbot",
          "description": "Hassan suggests using a chatbot to answer students' questions. His colleague worries it might provide incorrect or manipulative answers.",
          "question": "How should Hassan address this concern?",
          "options": [
            "Continue using it and let students decide what's accurate.",
            "Pilot the chatbot with controlled prompts and review results before classroom use.",
            "Remove the chatbot from the plan entirely."
          ],
          "correctAnswer": 2,
          "feedback": "Ethical piloting and validation of AI tools fosters trust and safeguards learning integrity.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Safe or Unsafe?",
            "cards": [
              {
                "statement": "A chatbot provides emotional support to students without any human oversight.",
                "correct": "Unfair",
                "feedback": "AI should never replace human care in sensitive matters. Ethical use means setting limits and safeguards."
              },
              {
                "statement": "Before using a new AI assistant in class, the teacher checks its privacy policy and test results.",
                "correct": "Fair",
                "feedback": "Validating tools before use shows responsibility and protects students' rights and well-being."
              },
              {
                "statement": "An AI tool gives biased examples that stereotype certain communities, but the teacher continues using it.",
                "correct": "Unfair",
                "feedback": "Bias in AI must be addressed immediately. Inclusive education requires constant vigilance."
              }
            ],
            "completionMessage": "Excellent! Ethical AI teaching includes validation, transparency, and protecting every learner's dignity and safety."
          }
        },
        {
          "id": 49,
          "title": "Culturally Limited Content",
          "description": "Asma finds that an AI reading tool lacks regional stories and mainly promotes texts from Western contexts.",
          "question": "What should she do before deciding to use the tool?",
          "options": [
            "Use it anyway since it promotes global exposure.",
            "Include it in class but add culturally relevant texts manually.",
            "Document the limitation and discuss it during lesson planning to determine its suitability."
          ],
          "correctAnswer": 3,
          "feedback": "Recognizing and addressing cultural bias allows for inclusive and responsive teaching decisions.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Inclusive or Exclusive?",
            "cards": [
              {
                "statement": "An AI tool suggests only English resources, ignoring students' local languages.",
                "correct": "Unfair",
                "feedback": "Ignoring linguistic diversity limits student engagement. A human-centred approach embraces all learners."
              },
              {
                "statement": "A teacher supplements AI content with regionally relevant stories and examples.",
                "correct": "Fair",
                "feedback": "Enhancing AI materials with local relevance ensures better understanding and inclusion."
              },
              {
                "statement": "The AI platform allows students to translate learning materials into their preferred language.",
                "correct": "Fair",
                "feedback": "Multilingual support empowers learners and reflects equity and accessibility."
              }
            ],
            "completionMessage": "Nice work! Culturally inclusive AI promotes equity, engagement, and student identity in learning."
          }
        },
        {
          "id": 50,
          "title": "Choosing Between AI Tools",
          "description": "Farah must pick between two AI tools: one is designed for monolingual students, and the other supports multilingual learners but has fewer features.",
          "question": "How should she choose?",
          "options": [
            "Choose the tool with more features—it's more advanced.",
            "Pilot both and evaluate based on actual student engagement and performance.",
            "Use neither and stick to manual strategies."
          ],
          "correctAnswer": 2,
          "feedback": "Piloting tools with your students helps you select solutions grounded in actual learning impact.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Right Tool or Not?",
            "cards": [
              {
                "statement": "The teacher tests two AI tools with students before selecting the best fit for the class.",
                "correct": "Fair",
                "feedback": "Piloting tools helps ensure effectiveness and appropriateness — a core part of responsible AI integration."
              },
              {
                "statement": "The chosen tool has great features but doesn't work well on the school's limited devices.",
                "correct": "Unfair",
                "feedback": "A great tool is only useful if it's accessible. Context matters in AI selection."
              },
              {
                "statement": "The teacher picks the most popular AI tool without checking its alignment with curriculum goals.",
                "correct": "Unfair",
                "feedback": "Popularity doesn't equal suitability. AI must match learning goals and student needs."
              }
            ],
            "completionMessage": "Good job! Selecting the right AI tool means evaluating context, goals, and accessibility — not just features."
          }
        }
      ]
    },
    {
      "level": "Level 11 (Deepen)",
      "scenarios": [
        {
          "id": 51,
          "title": "Choosing the Right Tool",
          "description": "Ms. Hina is redesigning a lesson on climate change. She has access to a chatbot that provides quick facts and a simulation tool that models carbon emissions based on student input.",
          "question": "Which tool should Ms. Hina prioritize to foster critical thinking and inquiry-based learning?",
          "options": [
            "Use the chatbot to quickly answer student questions",
            "Use the simulation tool to let students explore carbon impacts",
            "Use both tools equally without considering the lesson goals"
          ],
          "correctAnswer": 2,
          "feedback": "Simulation encourages student engagement, inquiry, and higher-order thinking, aligning with student-centred pedagogy.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Inquiry-Based or Not?",
            "cards": [
              {
                "statement": "Students use an AI simulation tool to explore the effects of pollution on different ecosystems.",
                "correct": "Fair",
                "feedback": "Simulations support inquiry by encouraging exploration, experimentation, and student-led discovery."
              },
              {
                "statement": "An AI assistant presents information in a lecture format without interaction or follow-up questions.",
                "correct": "Unfair",
                "feedback": "Inquiry-based learning requires active engagement — not passive listening — for deeper understanding."
              },
              {
                "statement": "A teacher uses AI-generated prompts to spark debate and student inquiry in a social studies class.",
                "correct": "Fair",
                "feedback": "Prompts that provoke student questioning and exploration strengthen inquiry-based instruction."
              }
            ],
            "completionMessage": "Well done! AI tools can drive inquiry — but only when paired with opportunities for student questioning, reflection, and exploration."
          }
        },
        {
          "id": 52,
          "title": "Misusing Predictive AI",
          "description": "An AI app Mr. Danish uses labels students as \\"high potential\\" or \\"low engagement.\\\" He begins grouping students based on this data for projects.",
          "question": "How should he reflect on this practice?",
          "options": [
            "Continue—AI knows best",
            "Reassess whether the AI tool is influencing bias and student agency",
            "Stop using the tool immediately without further analysis"
          ],
          "correctAnswer": 2,
          "feedback": "Teachers must examine how AI may affect equity and student agency and maintain accountability.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Bias or Balanced?",
            "cards": [
              {
                "statement": "A teacher uses AI to sort students into ability groups without reviewing how the groups are created.",
                "correct": "Unfair",
                "feedback": "Unquestioned AI decisions can reinforce bias. Teachers must examine and validate AI-generated groupings."
              },
              {
                "statement": "The teacher uses AI data alongside student interviews to make group assignments.",
                "correct": "Fair",
                "feedback": "Blending AI insights with teacher judgment ensures more equitable and personalized decisions."
              },
              {
                "statement": "Students are labeled by the AI as \\"struggling\\" and never given leadership roles.",
                "correct": "Unfair",
                "feedback": "Rigid AI-driven labels can reduce student agency and limit growth. Teachers must remain flexible and inclusive."
              }
            ],
            "completionMessage": "Excellent! Ethical AI use means questioning bias, promoting agency, and using data to support — not define — learners."
          }
        },
        {
          "id": 53,
          "title": "Designing Assessments",
          "description": "Ms. Sara uses an AI system to grade student essays. It highlights grammar but misses creativity and originality.",
          "question": "What should she do next?",
          "options": [
            "Only rely on the AI feedback",
            "Combine AI feedback with human review for a holistic assessment",
            "Stop using AI for assessment entirely"
          ],
          "correctAnswer": 2,
          "feedback": "Human–AI collaboration in assessment upholds accountability and promotes well-rounded evaluation.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Assessment Fit or Flaw?",
            "cards": [
              {
                "statement": "An AI assessment tool focuses only on grammar and spelling in writing tasks.",
                "correct": "Unfair",
                "feedback": "Effective assessment must consider ideas, creativity, and structure — not just surface-level features."
              },
              {
                "statement": "A teacher combines AI feedback with self- and peer-assessment.",
                "correct": "Fair",
                "feedback": "Multiple sources of assessment provide a more complete and transparent view of student learning."
              },
              {
                "statement": "Students receive a score from the AI, but no explanation or rubric.",
                "correct": "Unfair",
                "feedback": "Assessment transparency matters. Students need to understand how they're being evaluated."
              }
            ],
            "completionMessage": "Nice work! AI can enhance assessment — but only when used in ways that are fair, transparent, and aligned with meaningful learning outcomes."
          }
        },
        {
          "id": 54,
          "title": "Integrating AI for Empathy",
          "description": "Mr. Umer asks students to use an AI storytelling app to create refugee stories. Students struggle to emotionally connect.",
          "question": "How can Mr. Umer redesign this task?",
          "options": [
            "Add reflection and peer-sharing activities to deepen empathy",
            "Replace the AI tool with a reading assignment",
            "Just let students finish the task silently"
          ],
          "correctAnswer": 1,
          "feedback": "Pairing AI tools with reflective practices enhances emotional learning and teacher–student interactions.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Empathy Engaged or Missed?",
            "cards": [
              {
                "statement": "The teacher adds reflective journaling after students use AI to create refugee narratives.",
                "correct": "Fair",
                "feedback": "Pairing AI creation with emotional reflection helps students connect with real-world human experiences."
              },
              {
                "statement": "Students use AI to generate stories, but there is no discussion or sharing.",
                "correct": "Unfair",
                "feedback": "AI alone doesn't build empathy — it must be supported by peer interaction and personal reflection."
              },
              {
                "statement": "The class uses AI-generated personas in role-playing exercises about social issues.",
                "correct": "Fair",
                "feedback": "AI tools can support social-emotional learning when integrated into interactive, human-centred experiences."
              }
            ],
            "completionMessage": "Great job! Empathy grows when AI supports meaningful human interaction — not when it replaces it."
          }
        },
        {
          "id": 55,
          "title": "Planning for Differentiated Learning",
          "description": "Ms. Noreen uses AI to personalize learning paths for her students in a physics unit. She notices some students are rushing through without understanding.",
          "question": "What should she do?",
          "options": [
            "Rely on AI tracking alone",
            "Mix AI-generated paths with formative checks and teacher conferences",
            "Give all students the same path again"
          ],
          "correctAnswer": 2,
          "feedback": "Differentiated learning must be paired with teacher oversight to ensure meaningful progress.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Differentiated or Not?",
            "cards": [
              {
                "statement": "An AI platform adapts content difficulty, and the teacher checks in with students weekly.",
                "correct": "Fair",
                "feedback": "Combining adaptive AI tools with regular teacher guidance promotes true differentiated learning."
              },
              {
                "statement": "All students are given the same AI-generated path regardless of their learning level.",
                "correct": "Unfair",
                "feedback": "Personalized learning requires that tools and tasks are adapted to student needs — not standardized."
              },
              {
                "statement": "The teacher uses AI to identify struggling students but relies only on the AI's suggestions.",
                "correct": "Unfair",
                "feedback": "AI insights should inform, not dictate. Teacher feedback and flexibility remain essential for effective support."
              }
            ],
            "completionMessage": "Well done! Differentiation works best when AI is combined with teacher insight to guide every learner's journey."
          }
        }
      ]
    },
    {
      "level": "Level 12 (Create)",
      "scenarios": [
        {
          "id": 56,
          "title": "Student-Designed AI Tutor",
          "description": "Ms. Noor teaches a technology and literature elective. She guides her students in co-creating an AI chatbot that recommends books based on emotions and interests. The students must consider inclusivity, cultural sensitivity, and student privacy.",
          "question": "What key role does Ms. Noor play in this scenario?",
          "options": [
            "Let students run the project independently and focus on the tech.",
            "Provide guidance on ethics, cultural relevance, and pedagogical value while encouraging creativity.",
            "Use the bot herself and demonstrate it in class."
          ],
          "correctAnswer": 2,
          "feedback": "Teachers support student-driven AI projects by embedding pedagogical, ethical, and inclusion-focused frameworks.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Human-Centred Co-Creation or Not?",
            "cards": [
              {
                "statement": "Students design an AI chatbot for peer mentoring and receive teacher feedback on language sensitivity.",
                "correct": "Fair",
                "feedback": "Teacher-supported student design helps ensure tools are inclusive, respectful, and pedagogically sound."
              },
              {
                "statement": "A class builds an AI quiz generator but only tests it with high-achieving students.",
                "correct": "Unfair",
                "feedback": "Inclusive AI design requires input and testing across diverse learner groups to ensure fairness and accessibility."
              },
              {
                "statement": "Students create an AI-powered storytelling app with emotional prompts and ethical review checkpoints.",
                "correct": "Fair",
                "feedback": "Embedding emotional learning and ethical considerations into student-driven AI projects promotes responsible innovation."
              }
            ],
            "completionMessage": "Well done! Empowering students to co-create AI tools is powerful — but must be paired with ethical thinking, cultural awareness, and inclusive design."
          }
        },
        {
          "id": 57,
          "title": "Hackathon for Local AI Solutions",
          "description": "Ms. Areeba hosts a student hackathon to design AI tools that solve school-based challenges like absenteeism and low motivation.",
          "question": "What's the best way for her to lead this initiative?",
          "options": [
            "Let students explore real issues and use design thinking to create tools",
            "Assign the same project to every team for consistency",
            "Ask students to replicate existing tools instead of designing new ones"
          ],
          "correctAnswer": 1,
          "feedback": "When students design solutions for real challenges, learning becomes meaningful, applied, and connected to their context.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Innovation with Purpose or Not?",
            "cards": [
              {
                "statement": "Students create an app that gives motivational messages based on real data trends.",
                "correct": "Fair",
                "feedback": "Using data to inform design helps create tools that are both useful and grounded in reality."
              },
              {
                "statement": "The project involves making an AI coloring game with no link to classroom needs.",
                "correct": "Unfair",
                "feedback": "Innovative tools should aim to address meaningful challenges or learning goals."
              },
              {
                "statement": "Students reflect on who benefits and who might be excluded from their AI solution.",
                "correct": "Fair",
                "feedback": "Designing with awareness of impact helps ensure technology is inclusive and responsible."
              }
            ],
            "completionMessage": "Nice work! Innovation in learning means solving real problems through creativity, reflection, and collaboration."
          }
        },
        {
          "id": 58,
          "title": "Teacher–Student AI Podcast",
          "description": "Mr. Haris launches a podcast series co-hosted by students, where they review AI tools and discuss how those tools impact learning, creativity, and equity.",
          "question": "How should Mr. Haris structure the project?",
          "options": [
            "Let students run it freely, focusing only on entertainment",
            "Encourage students to connect AI tools with classroom learning, ethics, and social impact",
            "Choose all the tools himself and write the podcast script alone"
          ],
          "correctAnswer": 2,
          "feedback": "Projects that combine student voice, analysis, and reflection offer a rich space to explore real-world technology critically.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Critical or Surface Reflection?",
            "cards": [
              {
                "statement": "Students record an episode analyzing how an AI grading tool affects fairness.",
                "correct": "Fair",
                "feedback": "Linking tech tools to broader learning issues helps develop informed and thoughtful users."
              },
              {
                "statement": "The podcast focuses only on AI tool features without discussion or critique.",
                "correct": "Unfair",
                "feedback": "Without deeper exploration, students miss the chance to understand the full impact of technology."
              },
              {
                "statement": "Students compare their experiences using different AI tools for group projects.",
                "correct": "Fair",
                "feedback": "Personal reflections connected to practice help students develop critical insights about tools."
              }
            ],
            "completionMessage": "Well done! Encouraging learners to reflect critically on their tech experiences builds awareness and thoughtful decision-making."
          }
        },
        {
          "id": 59,
          "title": "Designing with AI + SEL (Social-Emotional Learning)",
          "description": "Ms. Mehreen supports a group of students developing an AI storytelling tool that helps peers express school-related stress. Some students propose collecting emotion data and suggesting coping strategies. Others are concerned about student privacy and emotional safety.",
          "question": "How should Ms. Mehreen guide the project?",
          "options": [
            "Allow students to collect emotional data freely, as it increases realism",
            "Encourage students to design the tool with opt-in features and discuss boundaries for emotional safety",
            "Remove the emotional focus and redesign the tool to focus only on academic motivation"
          ],
          "correctAnswer": 2,
          "feedback": "Helping students think critically about emotional safety and consent while still pursuing their creative goals fosters both ethical awareness and innovation.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Emotionally Aware or Not?",
            "cards": [
              {
                "statement": "The tool gives users the option to skip emotional prompts and continue anonymously.",
                "correct": "Fair",
                "feedback": "Respecting emotional boundaries and allowing user control fosters trust and thoughtful engagement."
              },
              {
                "statement": "The tool automatically stores emotional reflections for teachers to review.",
                "correct": "Unfair",
                "feedback": "Collecting sensitive emotional data without consent risks violating trust and undermining psychological safety."
              },
              {
                "statement": "Students add content filters and mood-based prompts but don't clarify how data will be used.",
                "correct": "Unfair",
                "feedback": "Even creative designs need clear communication about how personal information is handled."
              }
            ],
            "completionMessage": "Designing AI tools that support well-being requires empathy, transparency, and respect for user agency. Responsible emotional tech puts care at the center."
          }
        },
        {
          "id": 60,
          "title": "Placeholder Scenario 5",
          "description": "This is a placeholder for an additional scenario to complete the level.",
          "question": "This is a placeholder question?",
          "options": [
            "Option A",
            "Option B", 
            "Option C"
          ],
          "correctAnswer": 2,
          "feedback": "This is placeholder feedback.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Placeholder Activity",
            "cards": [
              {
                "statement": "Placeholder statement 1",
                "correct": "Fair",
                "feedback": "Placeholder feedback 1"
              },
              {
                "statement": "Placeholder statement 2",
                "correct": "Unfair",
                "feedback": "Placeholder feedback 2"
              },
              {
                "statement": "Placeholder statement 3",
                "correct": "Fair",
                "feedback": "Placeholder feedback 3"
              }
            ],
            "completionMessage": "Placeholder completion message."
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