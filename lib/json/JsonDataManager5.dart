import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager5 {
  static const String moduleJsonData = '''
  {
  "module": "Module 5 - AI Ethics",
  "levels": [
    {
      "level": "Level 1 (Acquire)",
      "scenarios": [
        {
          "id": 51,
          "title": "Biased Language Detection",
          "description": "An AI system flags students from Armenia, who use minority languages, as \\"suspicious\\" due to translation errors and cultural misunderstandings.",
          "question": "What should the teacher do when they notice this bias?",
          "options": [
            "Continue using the system since it works for most students.",
            "Report the bias and temporarily disable the feature while seeking alternatives.",
            "Ignore the issue since it only affects a few students."
          ],
          "correctAnswer": 2,
          "feedback": "Recognizing and addressing AI bias protects vulnerable students and ensures equitable learning environments.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Bias or Fair?",
            "cards": [
              {
                "statement": "An AI assessment tool consistently gives lower scores to students with non-native accents.",
                "correct": "Unfair",
                "feedback": "AI systems should not discriminate based on accent or language background. This creates educational inequity."
              },
              {
                "statement": "A teacher notices AI bias and immediately seeks input from diverse community members.",
                "correct": "Fair",
                "feedback": "Involving diverse perspectives helps identify and address bias, promoting inclusive education."
              },
              {
                "statement": "The school uses an AI tool that has been tested across different cultural and linguistic groups.",
                "correct": "Fair",
                "feedback": "Testing AI across diverse populations helps ensure fair and equitable outcomes for all students."
              }
            ],
            "completionMessage": "Excellent! Recognizing and addressing AI bias is essential for creating fair and inclusive learning environments."
          }
        },
        {
          "id": 52,
          "title": "Privacy vs. Personalization",
          "description": "A learning platform wants access to students' personal data, browsing history, and social media to personalize their learning experience.",
          "question": "How should the school approach this request?",
          "options": [
            "Accept it since personalized learning improves outcomes.",
            "Evaluate what data is truly necessary and ensure transparent consent processes.",
            "Reject it completely to avoid any privacy risks."
          ],
          "correctAnswer": 2,
          "feedback": "Balancing personalization with privacy requires careful evaluation of data necessity and transparent consent.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Privacy Protected or Violated?",
            "cards": [
              {
                "statement": "An AI platform collects student location data to track attendance without informing parents.",
                "correct": "Unfair",
                "feedback": "Collecting location data without consent violates privacy. Transparency is essential in educational technology."
              },
              {
                "statement": "Students and parents are clearly informed about what data is collected and how it will be used.",
                "correct": "Fair",
                "feedback": "Transparency and informed consent are fundamental to ethical data use in education."
              },
              {
                "statement": "The school shares student performance data with third-party companies without permission.",
                "correct": "Unfair",
                "feedback": "Sharing student data without consent violates privacy rights and trust. Schools must protect student information."
              }
            ],
            "completionMessage": "Great work! Privacy protection requires transparency, consent, and careful consideration of data necessity."
          }
        },
        {
          "id": 53,
          "title": "Algorithmic Decision Making",
          "description": "An AI system recommends which students should be placed in advanced or remedial classes based on past performance and demographic data.",
          "question": "What ethical concerns should the school consider?",
          "options": [
            "Trust the AI completely since it removes human bias.",
            "Review AI recommendations alongside teacher observations and student input.",
            "Use the AI recommendations without question to save time."
          ],
          "correctAnswer": 2,
          "feedback": "Human oversight and multiple perspectives are essential when AI influences important educational decisions.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Decision Making: Ethical or Not?",
            "cards": [
              {
                "statement": "An AI places students in tracks based solely on socioeconomic data without considering individual potential.",
                "correct": "Unfair",
                "feedback": "Using socioeconomic status alone for placement can perpetuate inequality and limit student opportunities."
              },
              {
                "statement": "Teachers use AI insights as one factor among many when making student placement decisions.",
                "correct": "Fair",
                "feedback": "Combining AI insights with human judgment and multiple data sources leads to more equitable decisions."
              },
              {
                "statement": "Students have no opportunity to appeal or discuss AI-generated placement recommendations.",
                "correct": "Unfair",
                "feedback": "Students should have agency in decisions affecting their education. Appeals and discussions promote fairness."
              }
            ],
            "completionMessage": "Well done! Ethical AI decision-making requires human oversight, multiple perspectives, and student agency."
          }
        },
        {
          "id": 54,
          "title": "Emotional AI Concerns",
          "description": "A new AI system claims to detect student emotions and stress levels through facial recognition and voice analysis during online classes.",
          "question": "What should teachers consider before implementing this technology?",
          "options": [
            "Implement it immediately to better support student wellbeing.",
            "Consider privacy implications, accuracy concerns, and alternative support methods.",
            "Use it only for students who seem to be struggling."
          ],
          "correctAnswer": 2,
          "feedback": "Emotional AI raises significant privacy and accuracy concerns that require careful ethical consideration.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Emotional AI: Helpful or Harmful?",
            "cards": [
              {
                "statement": "An AI monitors student facial expressions without their knowledge to detect \\"engagement levels.\\"",
                "correct": "Unfair",
                "feedback": "Secret emotional monitoring violates privacy and autonomy. Students should know when and how they're being observed."
              },
              {
                "statement": "Teachers use AI emotion detection as one tool among many, with student consent and clear boundaries.",
                "correct": "Fair",
                "feedback": "When used transparently with consent, emotional AI can support student wellbeing if properly implemented."
              },
              {
                "statement": "The school relies entirely on AI emotion detection instead of building human relationships with students.",
                "correct": "Unfair",
                "feedback": "Technology cannot replace human connection and understanding in supporting student emotional needs."
              }
            ],
            "completionMessage": "Excellent! Emotional AI requires careful consideration of privacy, consent, and the irreplaceable value of human connection."
          }
        },
        {
          "id": 55,
          "title": "AI-Generated Content Verification",
          "description": "Students are using AI to generate essays and reports. Some content appears to contain factual errors and potential misinformation.",
          "question": "How should teachers address this ethically?",
          "options": [
            "Ban AI-generated content completely.",
            "Teach students to fact-check and cite AI-generated content appropriately.",
            "Allow unlimited AI use without verification requirements."
          ],
          "correctAnswer": 2,
          "feedback": "Teaching responsible AI use and verification skills prepares students for ethical technology use in their future.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "AI Content: Responsible or Risky?",
            "cards": [
              {
                "statement": "A student submits an AI-generated report without checking facts or adding personal analysis.",
                "correct": "Unfair",
                "feedback": "Submitting unverified AI content without original thinking undermines learning and academic integrity."
              },
              {
                "statement": "Students learn to use AI as a research starting point, then verify information and add their own insights.",
                "correct": "Fair",
                "feedback": "Using AI responsibly as a tool while maintaining critical thinking and verification skills promotes ethical learning."
              },
              {
                "statement": "The teacher helps students understand when and how to disclose AI assistance in their work.",
                "correct": "Fair",
                "feedback": "Transparency about AI use builds integrity and helps students develop responsible technology habits."
              }
            ],
            "completionMessage": "Great job! Teaching responsible AI use includes verification, transparency, and maintaining critical thinking skills."
          }
        }
      ]
    },
    {
      "level": "Level 2 (Deepen)",
      "scenarios": [
        {
          "id": 56,
          "title": "Surveillance vs. Safety",
          "description": "The school wants to install AI-powered cameras that can identify \\"suspicious behavior\\" and predict potential safety incidents.",
          "question": "What ethical balance should the school seek?",
          "options": [
            "Install the system immediately for maximum safety.",
            "Engage the community in discussions about privacy, effectiveness, and alternatives.",
            "Reject surveillance technology entirely."
          ],
          "correctAnswer": 2,
          "feedback": "Complex ethical decisions require community input and careful consideration of competing values.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Safety vs. Privacy: Balanced or Biased?",
            "cards": [
              {
                "statement": "AI cameras monitor hallways but students and families aren't informed about data collection policies.",
                "correct": "Unfair",
                "feedback": "Surveillance without transparency violates trust and privacy. Communities deserve clear information about monitoring."
              },
              {
                "statement": "The school conducts community forums to discuss surveillance technology before implementation.",
                "correct": "Fair",
                "feedback": "Community engagement ensures that safety measures reflect shared values and address legitimate concerns."
              },
              {
                "statement": "AI surveillance disproportionately flags students from certain ethnic backgrounds as \\"suspicious.\\"",
                "correct": "Unfair",
                "feedback": "Biased surveillance systems can perpetuate discrimination and create hostile environments for marginalized students."
              }
            ],
            "completionMessage": "Excellent! Balancing safety and privacy requires community input, transparency, and vigilance against bias."
          }
        },
        {
          "id": 57,
          "title": "AI Tutoring Dependency",
          "description": "Students have become heavily dependent on AI tutoring systems and no longer engage with human teachers or peers for help.",
          "question": "How should educators respond to this dependency?",
          "options": [
            "Encourage continued AI use since it's helping students learn.",
            "Design activities that require human collaboration and gradually reduce AI dependency.",
            "Immediately remove all AI tutoring tools."
          ],
          "correctAnswer": 2,
          "feedback": "Healthy learning environments balance technological tools with essential human connections and collaborative skills.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "AI Dependency: Helpful or Harmful?",
            "cards": [
              {
                "statement": "Students work exclusively with AI tutors and avoid asking questions in class or participating in group work.",
                "correct": "Unfair",
                "feedback": "Over-dependence on AI can limit social learning and critical thinking skills developed through human interaction."
              },
              {
                "statement": "Teachers design lessons that combine AI assistance with peer collaboration and discussion.",
                "correct": "Fair",
                "feedback": "Balanced approaches help students benefit from AI while maintaining essential human learning experiences."
              },
              {
                "statement": "Students use AI tutors for initial practice, then apply learning through human interaction and feedback.",
                "correct": "Fair",
                "feedback": "Using AI as a supplement rather than replacement for human interaction promotes comprehensive learning."
              }
            ],
            "completionMessage": "Well done! Healthy AI integration maintains the irreplaceable value of human connection in learning."
          }
        },
        {
          "id": 58,
          "title": "Algorithmic Fairness in Assessment",
          "description": "An AI grading system consistently gives higher scores to essays written in formal academic language, potentially disadvantaging students from diverse linguistic backgrounds.",
          "question": "How should the school address this fairness issue?",
          "options": [
            "Continue using the system since it maintains academic standards.",
            "Adjust the algorithm or supplement with human review to ensure linguistic diversity is valued.",
            "Lower standards to accommodate all language styles."
          ],
          "correctAnswer": 2,
          "feedback": "Fair assessment recognizes diverse strengths while maintaining meaningful evaluation standards.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair Assessment or Hidden Bias?",
            "cards": [
              {
                "statement": "An AI system penalizes creative writing that doesn't follow traditional Western narrative structures.",
                "correct": "Unfair",
                "feedback": "Assessment systems should recognize diverse forms of expression and cultural storytelling traditions."
              },
              {
                "statement": "Teachers train AI systems using diverse examples of excellent work from different cultural backgrounds.",
                "correct": "Fair",
                "feedback": "Inclusive training data helps AI systems recognize excellence across diverse cultural and linguistic expressions."
              },
              {
                "statement": "Assessment criteria are transparent and students understand how their diverse strengths are valued.",
                "correct": "Fair",
                "feedback": "Clear, inclusive criteria help students understand expectations while celebrating diverse approaches to excellence."
              }
            ],
            "completionMessage": "Great work! Fair assessment requires recognizing diverse strengths and addressing hidden biases in evaluation systems."
          }
        },
        {
          "id": 59,
          "title": "Data Ownership and Control",
          "description": "Students create digital art and stories using AI tools, but the platform claims ownership rights over student-generated content.",
          "question": "What should educators advocate for regarding student digital rights?",
          "options": [
            "Accept platform terms since the tools are free to use.",
            "Advocate for student ownership of their creative work and clear data rights.",
            "Stop using creative AI tools entirely."
          ],
          "correctAnswer": 2,
          "feedback": "Students should maintain ownership and control over their creative work, even when using AI assistance.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Digital Rights: Protected or Exploited?",
            "cards": [
              {
                "statement": "A platform uses student artwork created with AI to train new models without permission or compensation.",
                "correct": "Unfair",
                "feedback": "Using student work without permission exploits their creativity. Students deserve control over their digital creations."
              },
              {
                "statement": "Students retain full rights to work they create using AI tools, with clear terms about platform use.",
                "correct": "Fair",
                "feedback": "Protecting student ownership rights encourages creativity and respects intellectual property in digital learning."
              },
              {
                "statement": "The school educates students about digital rights and helps them make informed decisions about platform use.",
                "correct": "Fair",
                "feedback": "Digital literacy includes understanding rights and making informed choices about technology use and data sharing."
              }
            ],
            "completionMessage": "Excellent! Protecting student digital rights empowers learners and promotes ethical technology use."
          }
        },
        {
          "id": 60,
          "title": "AI and Academic Integrity",
          "description": "A student uses AI to solve math problems but claims the work as entirely their own. Other students report feeling pressured to use AI to keep up.",
          "question": "How should the school develop policies that promote integrity while embracing beneficial AI use?",
          "options": [
            "Ban all AI use to eliminate cheating concerns.",
            "Develop clear guidelines about AI disclosure and appropriate use for different assignments.",
            "Allow unlimited AI use without disclosure requirements."
          ],
          "correctAnswer": 2,
          "feedback": "Clear, thoughtful policies help students use AI ethically while maintaining academic integrity and learning goals.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Academic Integrity: Maintained or Compromised?",
            "cards": [
              {
                "statement": "Students use AI to check their work and understand mistakes before submitting assignments.",
                "correct": "Fair",
                "feedback": "Using AI as a learning support tool while maintaining personal effort promotes both integrity and learning."
              },
              {
                "statement": "A student submits AI-generated solutions without understanding the process or disclosing AI use.",
                "correct": "Unfair",
                "feedback": "Submitting AI work without understanding or disclosure undermines learning and violates academic integrity."
              },
              {
                "statement": "Teachers design assessments that require demonstrating understanding beyond what AI can provide.",
                "correct": "Fair",
                "feedback": "Thoughtful assessment design ensures students must demonstrate genuine learning while allowing beneficial AI support."
              }
            ],
            "completionMessage": "Great job! Academic integrity with AI requires clear guidelines, transparency, and focus on genuine learning."
          }
        }
      ]
    },
    {
      "level": "Level 3 (Create)",
      "scenarios": [
        {
          "id": 61,
          "title": "Designing Ethical AI Policies",
          "description": "Your school district is creating comprehensive AI ethics guidelines for educational use. You're leading a committee with teachers, students, parents, and community members.",
          "question": "What should be the foundational principle guiding your policy development?",
          "options": [
            "Maximizing AI efficiency and cost savings.",
            "Centering student wellbeing, equity, and educational value in all AI decisions.",
            "Following whatever policies other successful schools have implemented."
          ],
          "correctAnswer": 2,
          "feedback": "Student-centered ethical frameworks ensure AI serves educational goals while protecting learner rights and promoting equity.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Ethical Policy: Comprehensive or Incomplete?",
            "cards": [
              {
                "statement": "The policy includes input from students, families, teachers, and community members from diverse backgrounds.",
                "correct": "Fair",
                "feedback": "Inclusive policy development ensures diverse perspectives and needs are considered in AI ethics guidelines."
              },
              {
                "statement": "AI policies are created by administrators without consulting teachers or families.",
                "correct": "Unfair",
                "feedback": "Top-down policy making without stakeholder input often misses important concerns and lacks community buy-in."
              },
              {
                "statement": "The policy includes regular review processes to adapt to new AI developments and community needs.",
                "correct": "Fair",
                "feedback": "Adaptive policies that evolve with technology and community needs maintain relevance and effectiveness."
              }
            ],
            "completionMessage": "Excellent! Effective AI ethics policies require inclusive development, student-centered principles, and adaptive frameworks."
          }
        },
        {
          "id": 62,
          "title": "Building AI Literacy Programs",
          "description": "You're designing a school-wide AI literacy program to help students understand AI capabilities, limitations, and ethical considerations.",
          "question": "What approach would best prepare students for responsible AI citizenship?",
          "options": [
            "Focus primarily on technical skills and AI programming.",
            "Combine hands-on AI experiences with critical thinking about societal impacts and ethical decision-making.",
            "Emphasize potential dangers and risks of AI technology."
          ],
          "correctAnswer": 2,
          "feedback": "Comprehensive AI literacy includes both practical skills and critical understanding of ethical and societal implications.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "AI Literacy: Comprehensive or Limited?",
            "cards": [
              {
                "statement": "Students learn to identify AI-generated content and understand how different AI systems work.",
                "correct": "Fair",
                "feedback": "Understanding AI capabilities and limitations helps students become informed and critical technology users."
              },
              {
                "statement": "The curriculum only focuses on AI benefits without discussing potential risks or ethical concerns.",
                "correct": "Unfair",
                "feedback": "Balanced AI education must address both opportunities and challenges to prepare responsible digital citizens."
              },
              {
                "statement": "Students engage in discussions about AI bias, privacy, and fairness through real-world case studies.",
                "correct": "Fair",
                "feedback": "Examining real ethical dilemmas helps students develop critical thinking skills for responsible AI use."
              }
            ],
            "completionMessage": "Great work! Comprehensive AI literacy prepares students to be informed, ethical, and empowered technology users."
          }
        },
        {
          "id": 63,
          "title": "Community AI Ethics Initiative",
          "description": "You're launching a community-wide initiative to address AI ethics in education, involving multiple schools, families, and local organizations.",
          "question": "How should you structure this initiative for maximum impact and inclusivity?",
          "options": [
            "Focus on implementing the same AI tools and policies across all participating schools.",
            "Create collaborative networks that respect community differences while sharing ethical frameworks and resources.",
            "Develop separate programs for different socioeconomic communities."
          ],
          "correctAnswer": 2,
          "feedback": "Collaborative approaches that respect diversity while promoting shared ethical principles create stronger, more sustainable initiatives.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Community Initiative: Inclusive or Exclusive?",
            "cards": [
              {
                "statement": "The initiative provides translation services and culturally relevant examples for diverse community members.",
                "correct": "Fair",
                "feedback": "Accessible, culturally responsive programming ensures all community members can participate meaningfully."
              },
              {
                "statement": "Meetings are scheduled only during work hours, making it difficult for working parents to participate.",
                "correct": "Unfair",
                "feedback": "Inaccessible scheduling excludes important voices and perspectives from community decision-making processes."
              },
              {
                "statement": "The initiative includes youth voices and leadership opportunities for students in AI ethics discussions.",
                "correct": "Fair",
                "feedback": "Including student perspectives ensures AI ethics initiatives address real learner needs and experiences."
              }
            ],
            "completionMessage": "Excellent! Inclusive community initiatives create stronger AI ethics frameworks that serve all learners effectively."
          }
        },
        {
          "id": 64,
          "title": "Evaluating AI Impact on Learning",
          "description": "After implementing various AI tools in your educational context, you need to assess their impact on student learning, equity, and wellbeing.",
          "question": "What evaluation approach would provide the most comprehensive understanding of AI's educational impact?",
          "options": [
            "Focus only on test scores and academic performance metrics.",
            "Use multiple data sources including student voice, equity indicators, and long-term learning outcomes.",
            "Rely primarily on technology usage statistics and efficiency measures."
          ],
          "correctAnswer": 2,
          "feedback": "Comprehensive evaluation requires multiple perspectives and indicators to understand AI's full impact on learning and equity.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "AI Evaluation: Comprehensive or Narrow?",
            "cards": [
              {
                "statement": "Evaluation includes surveys asking students about their experiences, concerns, and suggestions regarding AI tools.",
                "correct": "Fair",
                "feedback": "Student voice provides essential insights into AI's real impact on learning experiences and wellbeing."
              },
              {
                "statement": "The school only measures whether AI tools increased test scores without considering equity or student experience.",
                "correct": "Unfair",
                "feedback": "Narrow evaluation misses important impacts on equity, engagement, and holistic learning outcomes."
              },
              {
                "statement": "Evaluation examines whether AI tools are helping or hindering different student populations equitably.",
                "correct": "Fair",
                "feedback": "Equity-focused evaluation ensures AI benefits all students and doesn't exacerbate existing educational disparities."
              }
            ],
            "completionMessage": "Great job! Comprehensive AI evaluation considers multiple perspectives and outcomes to ensure beneficial, equitable implementation."
          }
        },
        {
          "id": 65,
          "title": "Future-Proofing Ethical AI Education",
          "description": "As AI technology rapidly evolves, you're developing strategies to ensure your educational AI ethics approach remains relevant and effective.",
          "question": "What strategy would best prepare your educational community for unknown future AI developments?",
          "options": [
            "Create detailed rules for every possible AI scenario.",
            "Build flexible ethical frameworks and critical thinking skills that can adapt to new technologies.",
            "Wait to see what AI developments occur before making any policies."
          ],
          "correctAnswer": 2,
          "feedback": "Adaptable ethical frameworks and strong critical thinking skills provide the best foundation for navigating future AI developments.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Future-Ready or Outdated?",
            "cards": [
              {
                "statement": "Students learn general principles of digital ethics that can apply to new technologies as they emerge.",
                "correct": "Fair",
                "feedback": "Teaching transferable ethical reasoning skills prepares students for technologies that don't yet exist."
              },
              {
                "statement": "The school creates very specific rules about current AI tools but no framework for evaluating new technologies.",
                "correct": "Unfair",
                "feedback": "Rigid, technology-specific rules quickly become outdated. Flexible frameworks provide better long-term guidance."
              },
              {
                "statement": "The curriculum includes regular discussions about emerging technologies and their potential ethical implications.",
                "correct": "Fair",
                "feedback": "Ongoing dialogue about technological change helps students develop skills for lifelong ethical technology use."
              }
            ],
            "completionMessage": "Excellent! Future-proofing AI ethics education requires flexible frameworks and strong critical thinking skills."
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