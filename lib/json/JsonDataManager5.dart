import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager5 {
  static const String moduleJsonData = '''
  {
  "module": "Module 5",
  "levels": [
    {
      "level": "Level 1 (Acquire)",
      "scenarios": [
        {
          "id": 56,
          "title": "Evolving Role in the AI Era",
          "description": "Ms. Farzana attends a staff meeting where AI tools in education are discussed. She begins to wonder how her teaching role is expected to evolve in this changing environment.",
          "question": "What should Ms. Farzana do first to stay professionally relevant?",
          "options": [
            "Memorize AI definitions and wait for official training",
            "Reflect on how AI is changing educational expectations and update her skillset accordingly",
            "Avoid AI tools because they may replace her role"
          ],
          "correctAnswer": 2,
          "feedback": "Reflecting on how AI is changing her role shows that Ms. Farzana understands the need for continuous learning and professional evolution in the AI era.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Professional Mindset Check",
            "description": "You are evaluating two teacher profiles to determine which reflects an appropriate understanding of the teacher's evolving role in an AI-rich education system.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Profile A: Mr. Faisal believes that AI tools are just accessories and continues with traditional teaching methods. He thinks his main role is delivering content without considering technology integration.",
                "options": [
                  "This reflects appropriate AI-era mindset",
                  "This needs improvement for AI era teaching"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Profile B: Ms. Aneeza sees AI as a support system that changes how she facilitates learning. She focuses on guiding students in inquiry, reflection, and ethical AI use.",
                "options": [
                  "This reflects appropriate AI-era mindset",
                  "This needs improvement for AI era teaching"
                ]
              }
            ],
            "idealPath": "B-A",
            "idealEnding": "Ms. Aneeza reflects the evolving role of educators in the AI era by shifting from content delivery to learning facilitation. Embracing AI as a co-teacher and guide prepares teachers for the demands of modern classrooms.",
            "badEnding": "Mr. Faisal's static view may limit professional growth and student engagement in the AI era."
          }
        },
        {
          "id": 57,
          "title": "Identifying Learning Gaps with AI",
          "description": "Ms. Rozina finds several online AI courses but is unsure which align with her needs. She wonders how to assess what AI knowledge and skills she actually lacks.",
          "question": "What is the next best step for her?",
          "options": [
            "Take the most popular AI course without reflection",
            "Use a self-assessment tool to identify specific gaps",
            "Stop learning until formal PD is provided"
          ],
          "correctAnswer": 2,
          "feedback": "Using a self-assessment tool allows Ms. Rozina to make an informed decision about her professional development journey based on her actual needs.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Learning Gap Assessment",
            "description": "You are comparing two professional development approaches taken by teachers to identify which reflects informed use of AI for identifying learning needs.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Option A: Mr. Taimoor randomly selects online AI courses based on popularity and struggles to complete them due to lack of relevance.",
                "options": [
                  "This demonstrates informed learning approach",
                  "This approach lacks direction and planning"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Option B: Ms. Shagufta completes an AI-readiness self-assessment that identifies her gaps in ethical use and classroom applications. She then enrolls in targeted courses based on her needs.",
                "options": [
                  "This demonstrates informed learning approach",
                  "This approach lacks direction and planning"
                ]
              }
            ],
            "idealPath": "B-A",
            "idealEnding": "Ms. Shagufta uses a structured, self-assessment-based approach to guide her learning, ensuring the courses align with her competency needs. This shows effective planning and self-awareness, key to professional growth in the AI era.",
            "badEnding": "Mr. Taimoor's approach lacks direction and is less effective for meaningful professional development."
          }
        },
        {
          "id": 58,
          "title": "Reflective Practice with AI Tools",
          "description": "Mr. Karim wants to understand which of his lessons are less engaging for students. He explores whether AI can help him reflect on and improve his teaching.",
          "question": "Which option best supports this goal?",
          "options": [
            "Use an AI tool that analyzes classroom audio for engagement trends",
            "Use a general video editor",
            "Use a PDF converter"
          ],
          "correctAnswer": 1,
          "feedback": "By selecting an AI tool focused on reflection and classroom analysis, Mr. Karim can gain actionable insights to improve his teaching.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Effective Reflection Comparison",
            "description": "You are comparing two teachers' approaches to professional reflection to determine which is more effective.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Option A: Mr. Bilal uses a basic notepad to reflect on lessons occasionally. He does not track patterns or outcomes and rarely revisits past entries.",
                "options": [
                  "This approach promotes effective reflection",
                  "This approach lacks depth and consistency"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Option B: Ms. Huma uses an AI tool that analyzes her recorded lessons and provides visual reports on student engagement. She adjusts her strategies based on the insights.",
                "options": [
                  "This approach promotes effective reflection",
                  "This approach lacks depth and consistency"
                ]
              }
            ],
            "idealPath": "B-A",
            "idealEnding": "Ms. Huma's use of an AI-supported tool allows her to gain data-driven insights into her teaching, making her reflection process more precise and impactful.",
            "badEnding": "Mr. Bilal's manual method lacks consistency and depth needed for systematic improvement."
          }
        },
        {
          "id": 59,
          "title": "Using AI for Content Mastery",
          "description": "Ms. Sana uses an AI platform that reviews her lesson recordings and suggests weak spots. She notices it consistently flags her fraction lessons as low in engagement.",
          "question": "How is this helping her professional growth?",
          "options": [
            "It reduces her need to plan",
            "It helps her target specific improvement areas",
            "It replaces her teaching tasks"
          ],
          "correctAnswer": 2,
          "feedback": "By helping Ms. Sana identify content gaps, the AI supports her in focusing on continuous improvement in teaching specific topics.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Personalized Learning Strategy",
            "description": "You are evaluating which teacher is leveraging AI for personalized professional development.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Option A: Ms. Seema uses an AI platform that adapts learning content to her needs and suggests peer mentors based on her skill gaps.",
                "options": [
                  "This leverages AI for personalized development",
                  "This approach is too technology-dependent"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Option B: Mr. Danish prefers to follow a fixed course list chosen by his supervisor without considering his individual needs or performance data.",
                "options": [
                  "This leverages AI for personalized development",
                  "This approach lacks personalization"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Ms. Seema's approach demonstrates effective use of AI to tailor her learning journey, while also benefiting from peer support.",
            "badEnding": "Mr. Danish's method is static and lacks the personalization needed for effective professional growth."
          }
        },
        {
          "id": 60,
          "title": "Avoiding AI Content Bubbles",
          "description": "Ms. Nilofer notices her AI news feed only shows articles that match her existing teaching style. She is concerned this might be limiting her exposure to new ideas.",
          "question": "What should she do to stay professionally diverse?",
          "options": [
            "Stick to the feed—it likely shows what's most relevant to her profile",
            "Actively explore content and communities beyond what the AI suggests",
            "Turn off the AI tool entirely to avoid bias in recommendations"
          ],
          "correctAnswer": 2,
          "feedback": "Exploring beyond algorithm-driven content helps Ms. Nilofer avoid echo chambers and stay open to new educational practices.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Professional Roadmap Planning",
            "description": "You are comparing two teachers' approaches to professional development planning to determine which shows thoughtful strategy.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Option A: Mr. Aslam uses his AI-readiness results to create a personalized plan with short-term and long-term goals, focusing on tools relevant to his subject area.",
                "options": [
                  "This demonstrates effective planning strategy",
                  "This approach is overly complicated"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Option B: Ms. Shaista copies her colleague's development plan, assuming that what worked for him will work for her too, regardless of their different teaching contexts.",
                "options": [
                  "This demonstrates effective planning strategy",
                  "This approach lacks individualization"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Mr. Aslam's roadmap is grounded in self-assessment and aligned with his professional needs, showing strategic thinking.",
            "badEnding": "Ms. Shaista's approach overlooks individual learning paths, which are critical for meaningful progress."
          }
        }
      ]
    },
    {
      "level": "Level 2 (Deepen)",
      "scenarios": [
        {
          "id": 61,
          "title": "Peer Feedback or Platform Insights?",
          "description": "Ms. Fareeda is designing a professional development session and wants to base it on actual gaps in teaching practices. She has access to both peer feedback and AI-generated performance analytics.",
          "question": "Which should she prioritize to best understand evolving teacher needs?",
          "options": [
            "Only use peer opinions to avoid over-relying on technology",
            "Combine peer feedback with insights from AI analytics",
            "Rely only on AI data since it is more objective"
          ],
          "correctAnswer": 2,
          "feedback": "Combining AI data with peer insights enables a balanced, contextualized understanding of teaching practices. AI alone may miss nuance, while peer feedback alone might lack data precision.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Professional Circle Expansion",
            "description": "You are observing two teachers using a professional AI platform to find mentors and evaluating who is managing algorithmic bias better.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Only accepts AI mentor suggestions, all of whom match his subject and teaching style.",
                "options": [
                  "This demonstrates thoughtful AI use",
                  "This creates an echo chamber effect"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Explores mentors outside the AI list by searching for different teaching styles and regions.",
                "options": [
                  "This demonstrates thoughtful AI use",
                  "This creates unnecessary complexity"
                ]
              }
            ],
            "idealPath": "B-A",
            "idealEnding": "Teacher B avoids echo chambers and gains richer perspectives by actively seeking diversity beyond algorithm suggestions.",
            "badEnding": "Teacher A limits professional growth by staying within algorithmic comfort zones."
          }
        },
        {
          "id": 62,
          "title": "Self-Assessment and Data Privacy",
          "description": "Mr. Tanveer uses a self-assessment AI app that stores his teaching data on external servers.",
          "question": "What is the best course of action?",
          "options": [
            "Use the tool but review its privacy policy and settings",
            "Avoid any AI app that stores data",
            "Trust all tools provided by vendors"
          ],
          "correctAnswer": 1,
          "feedback": "Teachers should be informed users—leveraging tools while safeguarding their professional data through privacy awareness.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Data Protection Awareness",
            "description": "You are comparing two teachers using AI self-assessment tools for teaching reflection to determine who is more privacy-aware.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Reads the platform's privacy settings, restricts unnecessary data sharing, and updates security preferences.",
                "options": [
                  "This shows appropriate data protection",
                  "This is overly cautious and limits functionality"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Uses the tool as-is, assuming school-vetted platforms don't need personal scrutiny.",
                "options": [
                  "This shows appropriate data protection",
                  "This lacks necessary privacy awareness"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Responsible AI use includes understanding how your data is stored and shared. Trust must be earned, not assumed.",
            "badEnding": "Blind trust in platforms can lead to privacy vulnerabilities and data misuse."
          }
        },
        {
          "id": 63,
          "title": "Algorithm Bias in Peer Recommendations",
          "description": "While using an AI PD platform, Mr. Bilal notices he is repeatedly recommended the same type of peers for mentoring—those who match his existing style.",
          "question": "How should he respond to broaden his learning?",
          "options": [
            "Follow recommendations without question",
            "Manually seek mentors with different expertise and viewpoints",
            "Quit using the platform and rely only on his school community"
          ],
          "correctAnswer": 2,
          "feedback": "Manually diversifying mentors ensures he avoids algorithmic echo chambers and fosters richer professional growth. AI suggestions should be a guide, not a limit.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Bias Management Strategy",
            "description": "You are evaluating two teachers using a professional AI platform to determine who is managing algorithmic bias better.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Only accepts AI mentor suggestions, all of whom match his subject and teaching style.",
                "options": [
                  "This demonstrates thoughtful AI use",
                  "This creates professional limitations"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Explores mentors outside the AI list by searching for different teaching styles and regions.",
                "options": [
                  "This demonstrates thoughtful AI use",
                  "This ignores helpful AI recommendations"
                ]
              }
            ],
            "idealPath": "B-A",
            "idealEnding": "Teacher B avoids echo chambers and gains richer perspectives by actively seeking diversity beyond algorithm suggestions.",
            "badEnding": "Teacher A limits growth by accepting only similar mentors, missing valuable diverse perspectives."
          }
        },
        {
          "id": 64,
          "title": "Evaluating PD Resources",
          "description": "Ms. Rukhsana comes across two AI-based PD resources. One has peer-reviewed validation but fewer features; the other is flashy but lacks transparency.",
          "question": "Which should she choose for sustainable PD?",
          "options": [
            "Choose the validated one that aligns with ethical standards",
            "Go with the one that's more interactive",
            "Use both without evaluating"
          ],
          "correctAnswer": 1,
          "feedback": "Validated, ethically sound tools provide reliable learning over time. Flashy tools lacking transparency may compromise quality or values.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Platform Sustainability Assessment",
            "description": "You are choosing between two AI platforms for teacher PD to determine which supports deeper, long-term professional learning.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Platform A: Offers AI-backed resources validated by peer reviews and local educators.",
                "options": [
                  "This supports sustainable learning",
                  "This seems too traditional and slow"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Platform B: Looks appealing but lacks clear information on how its content is generated or reviewed.",
                "options": [
                  "This offers innovative possibilities",
                  "This lacks necessary transparency"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Validated and ethically developed content ensures lasting value and reliable professional growth.",
            "badEnding": "Flashy tools without transparency can mislead and dilute PD quality over time."
          }
        },
        {
          "id": 65,
          "title": "AI in Collaborative Communities",
          "description": "A teacher group in Hunza is using an AI tool to share PD resources, but the platform rarely promotes contributions from local teachers.",
          "question": "What's the best action for inclusivity?",
          "options": [
            "Let the platform function as is",
            "Propose the inclusion of local voices and advocate for algorithmic changes",
            "Create a separate non-AI group"
          ],
          "correctAnswer": 2,
          "feedback": "Advocating for inclusive algorithmic design ensures local representation in professional growth spaces. It supports contextual relevance.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "AI Tool Management",
            "description": "You are comparing two teachers who subscribe to several AI PD platforms to determine who is managing AI tools for maximum benefit.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Reviews each platform's offerings, eliminates redundant ones, and focuses on tools aligned with her learning goals.",
                "options": [
                  "This shows effective AI management",
                  "This eliminates potentially useful resources"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Subscribes to all platforms, hoping AI will eventually recommend what's best.",
                "options": [
                  "This maximizes available resources",
                  "This creates information overload"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Teacher A demonstrates intentionality and focus, critical for effective PD. AI should support—not drown—professional growth.",
            "badEnding": "Teacher B becomes overwhelmed by too many tools, reducing effectiveness of professional development."
          }
        }
      ]
    },
    {
      "level": "Level 3 (Create)",
      "scenarios": [
        {
          "id": 66,
          "title": "Leading AI Pedagogy Circles",
          "description": "Mr. Salman decides to initiate a teacher learning circle focused on using AI tools for professional growth. Some teachers resist, fearing they will be replaced by AI.",
          "question": "What should Mr. Salman do to build engagement?",
          "options": [
            "Reassure them AI will never affect teaching jobs and move on",
            "Lead open discussions that address fears, showcase success stories, and encourage co-creation of AI integration practices",
            "Ignore resistant teachers and only work with willing participants"
          ],
          "correctAnswer": 2,
          "feedback": "This offers a collaborative and empathetic approach that respects concerns, promotes trust, and supports collective transformation through AI use.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Professional Growth Leadership",
            "description": "You are comparing two teachers starting AI-based pedagogy groups in their schools to determine who fosters deeper engagement.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Starts with open dialogue, addresses concerns about AI, and co-creates goals with team members.",
                "options": [
                  "This fosters real professional growth",
                  "This takes too much time on preliminaries"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Launches the group with a fixed agenda and discourages questions to avoid delays.",
                "options": [
                  "This ensures efficient progress",
                  "This limits authentic engagement"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Teacher A builds trust and empowers peers, fostering sustainable, collaborative growth. Successful AI integration in PD relies on collective participation, not top-down enforcement.",
            "badEnding": "Teacher B's approach may create compliance but not genuine engagement or transformation."
          }
        },
        {
          "id": 67,
          "title": "Building Inclusive Tools",
          "description": "Ms. Farzana wants to create a professional learning plan for her colleagues using an AI tool, but the tool lacks features for teachers with visual impairments.",
          "question": "How can she make this tool more inclusive?",
          "options": [
            "Replace the tool with a non-AI resource that works for everyone",
            "Use the AI tool as it is but pair it with separate support sessions for those who need accommodations",
            "Advocate for the AI tool to be improved while supplementing it with assistive technologies to ensure all teachers benefit"
          ],
          "correctAnswer": 3,
          "feedback": "This supports long-term equity and inclusion while still leveraging the tool's potential. It balances innovation with fairness.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Inclusive AI Implementation",
            "description": "You are comparing two school leaders introducing AI tools for teacher development to determine who promotes equitable AI use.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Leader A: Tests the tool with differently-abled users, integrates assistive tech, and shares feedback with developers.",
                "options": [
                  "This promotes equitable AI use",
                  "This overcomplicates the implementation"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Leader B: Deploys the tool as-is and encourages staff to find workarounds if needed.",
                "options": [
                  "This ensures quick deployment",
                  "This ignores accessibility needs"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Leader A shows inclusive planning, ensuring all teachers benefit from AI. Equity should be embedded in AI-enabled PD from the start, not added later.",
            "badEnding": "Leader B's approach may exclude teachers with disabilities and create inequitable professional development opportunities."
          }
        },
        {
          "id": 68,
          "title": "Peer-Led AI Innovation",
          "description": "A teacher peer group wants to co-design AI-based modules for science instruction. They invite Mr. Haris to lead the initiative.",
          "question": "What leadership approach would be most effective?",
          "options": [
            "Take full control and assign roles to ensure quick delivery",
            "Encourage shared ownership by co-developing the module with the group's input and reflecting on iterations together",
            "Avoid changes to traditional modules unless administration mandates it"
          ],
          "correctAnswer": 2,
          "feedback": "This promotes ownership, creativity, and adaptability—key traits of professional development leadership in the AI era.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Collaborative Innovation Leadership",
            "description": "You are comparing two facilitators co-designing AI-enhanced PD content with peers to determine who strengthens peer-led innovation.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Facilitator A: Collects input from peers, invites co-authorship, and shares decisions throughout development.",
                "options": [
                  "This enables teacher voice and innovation",
                  "This slows down the development process"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Facilitator B: Designs the content solo, asking for feedback only after finalizing it.",
                "options": [
                  "This ensures consistent quality",
                  "This limits peer ownership and creativity"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Facilitator A promotes ownership, creativity, and innovation—key outcomes of teacher-driven professional learning in the AI age.",
            "badEnding": "Facilitator B's approach may create good content but misses opportunities for peer empowerment and collaborative innovation."
          }
        },
        {
          "id": 69,
          "title": "Evaluating EdTech Platforms",
          "description": "Ms. Noreen wants to integrate a new AI-based learning management system (LMS) for teacher training.",
          "question": "How should she evaluate whether it's suitable?",
          "options": [
            "Check how many schools are already using it",
            "Review the AI features in light of her teachers' needs, alignment with PD goals, and ethical data practices",
            "Use it on a trial basis without detailed review and decide later"
          ],
          "correctAnswer": 2,
          "feedback": "This enables responsible decision-making by aligning tools with actual needs, ensuring long-term impact and trust.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Responsible Platform Selection",
            "description": "You are comparing two educators choosing AI tools for teacher PD to determine who is practicing responsible decision-making.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Educator A: Reviews ethical considerations, teacher needs, and alignment with goals before selection.",
                "options": [
                  "This demonstrates responsible decision-making",
                  "This creates unnecessary delays in implementation"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Educator B: Chooses a tool because it's popular in high-ranking schools.",
                "options": [
                  "This leverages proven success",
                  "This ignores contextual needs"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Educator A models intentional, context-aware evaluation. Responsible AI integration requires critical assessment beyond popularity.",
            "badEnding": "Educator B's approach may lead to tools that don't fit the specific needs and context of their teachers."
          }
        },
        {
          "id": 70,
          "title": "Supporting Contextual Innovation",
          "description": "Mr. Bilal is customizing an AI-powered training module for rural teachers who lack access to high-speed internet.",
          "question": "What should be his priority?",
          "options": [
            "Use the same modules developed for urban teachers",
            "Optimize the module with offline capabilities and examples from rural contexts",
            "Wait until internet access improves"
          ],
          "correctAnswer": 2,
          "feedback": "This demonstrates adaptability and inclusivity, allowing AI to serve all contexts without widening the digital divide.",
          "activity": {
            "type": "Interactive Simulation",
            "name": "Contextual AI Adaptation",
            "description": "You are comparing two teachers using AI modules in different school contexts to determine who ensures effective contextual implementation.",
            "scenes": [
              {
                "sceneNumber": 1,
                "description": "Teacher A: Localizes content, ensures offline access, and tailors examples to students' realities.",
                "options": [
                  "This ensures effective contextual implementation",
                  "This requires too much customization effort"
                ]
              },
              {
                "sceneNumber": 2,
                "description": "Teacher B: Applies the same AI modules developed for urban schools, regardless of differences.",
                "options": [
                  "This maintains consistency across contexts",
                  "This ignores important contextual differences"
                ]
              }
            ],
            "idealPath": "A-B",
            "idealEnding": "Teacher A adapts AI meaningfully, enhancing access and relevance. AI for PD should serve diverse teaching environments, not ignore them.",
            "badEnding": "Teacher B's approach may result in tools that are irrelevant or inaccessible in certain contexts."
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