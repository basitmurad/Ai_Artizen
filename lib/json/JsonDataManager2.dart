  import 'dart:convert';

  import '../models/JsonModel.dart';

  class JsonDataManager2 {
    static const String moduleJsonData = '''
    {
    "module": "Module 2",
    "levels": [
      {
        "level": "Level 1 (Acquire)",
        "scenarios": [
          {
            "id": 16,
            "title": "AI Surveillance & Privacy",
            "description": "Ms. Zara's school implements an AI tool to monitor students' online behavior, aiming to prevent cyberbullying. However, the system frequently flags students like Jameel and Sania, who use minority languages, as \\"suspicious,\\" due to translation errors and cultural misunderstandings.",
            "question": "What should Ms. Zara do to ensure student safety without compromising fairness and cultural inclusion?",
            "options": [
              "Continue using the tool but manually review flagged cases",
              "Disable the tool and rely solely on teacher observation",
              "Demand transparency and push for an audit to check for bias in the algorithm"
            ],
            "correctAnswer": 3,
            "feedback": "Advocating for transparent, unbiased AI helps protect student safety while respecting cultural diversity and fairness.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Audit the Algorithm",
              "description": "You are Ms. Zara. After noticing that minority-language students are unfairly flagged by your school's AI surveillance tool, you must decide what to do.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice Sania, a top student, has been flagged twice this week for using Wakhi phrases.",
                  "options": [
                    "Talk to the vice principal immediately",
                    "Collect more evidence from other students"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You collect 4 similar cases—Jameel, Nasreen, Hafiz, and Musa.",
                  "options": [
                    "File a report to the school ethics committee",
                    "Keep the report private and confront the AI company"
                  ]
                },
                {
                  "sceneNumber": 3,
                  "description": "The ethics committee agrees to review the AI tool.",
                  "options": [
                    "Recommend that the tool be paused until the audit completes",
                    "Recommend hiring a cultural linguist to retrain the tool"
                  ]
                }
              ],
              "idealPath": "A-A-A",
              "idealEnding": "The school pauses the tool and brings in experts to correct bias. Minority students feel safer and more included.",
              "badEnding": "The company refuses to acknowledge the issue. The tool continues to harm marginalized students."
            }
          },
          {
            "id": 16,
            "title": "Whose Language Counts?",
            "description": "Ms. Kulsoom's school adopts an AI language-learning app that supports only dominant languages like English and Spanish. However, students from indigenous and marginalized communities feel excluded, as their native languages are not recognized by the app.",
            "question": "How should Ms. Kulsoom respond to ensure all students feel included and valued?",
            "options": [
              "Use the app for most students and offer manual support to others",
              "Reject the app entirely and develop culturally inclusive resources herself",
              "Advocate with the developer to include local and indigenous languages in the app"
            ],
            "correctAnswer": 3,
            "feedback": "Advocating for linguistic inclusion in AI tools ensures every student's identity is respected and valued in the learning process.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Audit the App",
              "description": "You are Ms. Kulsoom. Your school has adopted an AI language-learning app that only supports dominant languages like English and Spanish. Students who speak indigenous languages like Wakhi and Shina feel excluded and disengaged.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice Karim and Sana quietly skip activities involving the AI app. Their native languages aren't supported.",
                  "options": [
                    "Raise the concern with the vice principal immediately",
                    "Offer manual worksheets to support excluded students"
                  ]
                }
              ],
              "idealPath": "A-B-B-A",
              "idealEnding": "The developer adds Wakhi and Shina support in the next update. Students are excited to see their languages respected. Engagement improves schoolwide.",
              "badEnding": "Without support, the developer drops the idea. Students continue feeling excluded, and the app drives further disengagement."
            }
          },
          {
            "id": 18,
            "title": "The Voice That Wasn't Heard",
            "description": "Mr. Imran introduces an AI-powered reading fluency app in his class. The app tracks and scores students' reading aloud skills using voice recognition. However, students with speech impairments and accents—like Areeba, who stutters, and Karim, who speaks with a regional accent—consistently receive lower scores.",
            "question": "What should Mr. Imran do to ensure inclusive and equitable learning for all students?",
            "options": [
              "Continue using the app, since it works well for most students",
              "Allow affected students to skip the app-based activity",
              "Raise concerns with the developers and provide an alternative assessment for excluded students"
            ],
            "correctAnswer": 3,
            "feedback": "AI tools must be inclusive of diverse speech patterns, disabilities, and accents to avoid unfair learning experiences.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Reading Fairly",
              "description": "You are Mr. Imran. You use a reading fluency app that rates students' speech, but those with accents or speech differences get unfairly low scores.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Karim, a fluent reader with a regional accent, is consistently marked as \\"below average.\\"",
                  "options": [
                    "Talk to the app provider about speech diversity",
                    "Let affected students skip the app and give them written tasks"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "Your advocacy leads to an inclusive update. All learners feel respected and assessed fairly.",
              "badEnding": "Alternative assessments help some students, but the app's bias remains unchallenged."
            }
          },
          {
            "id": 19,
            "title": "Not in the Picture",
            "description": "Ms. Hina's school deploys an AI-powered facial recognition system for automating attendance. The system promises efficiency, but within a week, she notices a troubling pattern—students with darker skin tones, those who wear traditional headscarves, and Faizan, a student with facial muscle paralysis due to a disability, are frequently marked absent.",
            "question": "What should Ms. Hina do next?",
            "options": [
              "Keep using the system and manually adjust the attendance afterward",
              "Ignore the issue—it's a technical limitation, not her responsibility",
              "Document the bias and formally report it to school leadership or the responsible authority"
            ],
            "correctAnswer": 3,
            "feedback": "Educators must identify and report algorithmic bias in AI tools to ensure no student is excluded based on appearance or disability.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Face the Bias",
              "description": "You are Ms. Hina. A facial recognition tool wrongly marks absent students with dark skin, headscarves, or facial disabilities.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice students like Faizan and Mahira are repeatedly misrecognized.",
                  "options": [
                    "Document the errors with photos and dates",
                    "Keep adjusting attendance manually without raising a fuss"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You collect 12 error cases over 2 weeks.",
                  "options": [
                    "Submit your report formally to school leadership",
                    "Discuss the issue informally with your colleague again"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "Your formal report leads to real change. Students stop being unfairly marked absent.",
              "badEnding": "The issue is brushed aside again. Students continue being harmed by the tool."
            }
          },
          {
            "id": 20,
            "title": "Whose Data, Whose Rules?",
            "description": "Ms. Shazia, a teacher in a private school in Karachi, is asked to implement a new AI-powered student analytics tool. The tool tracks academic performance, emotional responses via webcam, and online behavior patterns. The company claims the system is \\"secure\\" and follows global regulations like GDPR and FERPA. However, the software collects biometric and behavioral data without any formal consent from parents or students.",
            "question": "What should Ms. Shazia do to act ethically and responsibly?",
            "options": [
              "Proceed with the tool—it's already used internationally",
              "Raise the issue with the school administration and request clarity on Pakistan's Personal Data Protection Bill",
              "Use the tool but avoid sensitive features like webcam access"
            ],
            "correctAnswer": 2,
            "feedback": "Understanding and complying with local data protection laws is essential for ethical AI implementation in education.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Data in the Dark",
              "description": "You are Ms. Shazia. A new AI tool collects students' biometric and emotional data—but there's no mention of Pakistan's privacy laws.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You find out that parents and students were not asked for formal consent.",
                  "options": [
                    "Raise the concern with school leadership and ask for legal review",
                    "Use the tool with webcam off to avoid issues"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "The school realizes there's no reference to Pakistan's Personal Data Protection Bill in the tool agreement.",
                  "options": [
                    "Recommend pausing tool use until legal consultation is complete",
                    "Continue using the tool but only in non-sensitive subjects"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "You ensure legal and ethical compliance. Trust and transparency are restored.",
              "badEnding": "Students' data is still being collected without consent. Trust in the school's decisions declines."
            }
          }
        ]
      },
      {
        "level": "Level 2 (Deepen)",
        "scenarios": [
          {
            "id": 21,
            "title": "AI Career Bias in a Karachi School",
            "description": "A Lahore-based AI career counselor app recommends engineering/medicine only to male students and teaching/nursing to female students at a Karachi public school. Female students protest, but the principal insists the tool aligns with \\"market trends.\\"",
            "question": "How should the teacher address this?",
            "options": [
              "Accept the tool's recommendations as \\"culturally appropriate.\\"",
              "Manually suggest STEM fields to female students.",
              "Advocate for a bias audit with the Punjab IT Board."
            ],
            "correctAnswer": 3,
            "feedback": "AI tools must avoid reinforcing gender stereotypes. Pakistani schools should align with national policies like the Digital Pakistan Vision, which promotes inclusive tech.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Bias Detection Lab",
              "description": "You are a teacher at a school that's piloting a new AI career guidance tool. During testing, you notice potential gender bias in the recommendations.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "Your test shows the AI recommends different careers based on gender.",
                  "options": [
                    "Document specific examples of biased recommendations",
                    "Assume it's just a few glitches that will fix themselves"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You now have clear evidence of bias patterns.",
                  "options": [
                    "Organize a student activity to analyze the bias",
                    "Report directly to administration without student involvement"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "Students participate in identifying bias, learning about algorithmic fairness firsthand. The school uses these findings to improve the tool.",
              "badEnding": "The administration makes changes without student input, missing a valuable teaching opportunity about AI ethics."
            }
          },
          {
            "id": 22,
            "title": "Biometric Data in Islamabad's Smart Classrooms",
            "description": "A \\"smart school\\" in Islamabad requires fingerprint scans for attendance via an AI system. Parents worry scans are stored indefinitely and shared with third parties. The admin claims it's \\"secure,\\" but Pakistan lacks robust data laws.",
            "question": "What should teachers do?",
            "options": [
              "Enforce usage; biometrics are \\"modernization.\\"",
              "Offer manual attendance for students opting out.",
              "Demand written guarantees from the vendor."
            ],
            "correctAnswer": 2,
            "feedback": "Under Pakistan's Personal Data Protection Bill, consent is key. Forced biometrics risk breaches.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Privacy Policy Lab",
              "description": "You're evaluating a new school technology that collects student data.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice the system lacks clear data protection measures.",
                  "options": [
                    "Document the privacy gaps and propose solutions",
                    "Assume the vendor has handled security adequately"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Administration asks for specific improvement recommendations.",
                  "options": [
                    "Develop a consent process with clear data usage explanations",
                    "Suggest limiting data collection to only essential information"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "The school implements transparent data practices.",
              "badEnding": "Data continues being collected without proper safeguards."
            }
          },
          {
            "id": 23,
            "title": "AI Plagiarism at PU Lahore",
            "description": "At Punjab University, an AI detector flags a student's Urdu essay as \\"plagiarized\\" due to matching phrases from classical poetry. The student argues this is common in Urdu literature.",
            "question": "How should the professor respond?",
            "options": [
              "Fail the student; AI tools are definitive.",
              "Ignore the flag; Urdu idioms differ from English.",
              "Clarify guidelines for cultural/linguistic nuances."
            ],
            "correctAnswer": 3,
            "feedback": "AI tools trained on Western data may misjudge local contexts. Policies must respect Pakistani literary norms.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Context Matters",
              "description": "Your institution is implementing an AI writing evaluation tool.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "The tool flags legitimate writing as problematic.",
                  "options": [
                    "Investigate why these errors are occurring",
                    "Lower the sensitivity to reduce flags"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You discover cultural/language biases in the algorithm.",
                  "options": [
                    "Create discipline-specific guidelines for human review",
                    "Remove the tool's most problematic features"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "Hybrid human-AI evaluation improves accuracy.",
              "badEnding": "Important checks are lost while biases remain."
            }
          },
          {
            "id": 24,
            "title": "AI Accessibility for Sindh's Rural Students",
            "description": "An AI tutoring app for Sindh's schools lacks Urdu/Sindhi support and requires high internet bandwidth. Rural students with disabilities struggle, but the vendor calls updates \\"too costly.\\"",
            "question": "What's the ethical solution?",
            "options": [
              "Use it only in urban schools.",
              "Partner with local NGOs to fund inclusive upgrades.",
              "Wait for government subsidies."
            ],
            "correctAnswer": 2,
            "feedback": "Pakistan's National Education Policy mandates inclusivity. Offline/low-bandwidth options are critical.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Inclusive Design Challenge",
              "description": "Your school is adopting a new learning technology.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice some students can't use the tool effectively.",
                  "options": [
                    "Identify specific accessibility barriers",
                    "Provide alternative assignments for affected students"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You compile a list of needed adaptations.",
                  "options": [
                    "Work with developers to implement accessibility features",
                    "Find supplemental tools to fill the gaps"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "The technology becomes usable for all students.",
              "badEnding": "A patchwork solution creates inconsistent experiences."
            }
          },
          {
            "id": 25,
            "title": "AI Surveillance in Peshawar's Colleges",
            "description": "A Peshawar college uses AI cameras to flag \\"suspicious behavior\\" (e.g., long bathroom breaks). Female students report false flags due to cultural norms (e.g., praying during breaks).",
            "question": "How should staff address this?",
            "options": [
              "Trust the AI; security outweighs privacy.",
              "Adjust thresholds for gender-specific norms.",
              "Disable surveillance to avoid controversy."
            ],
            "correctAnswer": 2,
            "feedback": "AI must respect Pakistani cultural norms. Over-surveillance risks violating privacy and safety.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Bias Detection",
              "description": "Your organization is using AI for behavior monitoring.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "The system shows inconsistent results across groups.",
                  "options": [
                    "Analyze the data for potential biases",
                    "Adjust parameters to equalize outcomes"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You identify specific algorithmic biases.",
                  "options": [
                    "Recommend retraining the model with balanced data",
                    "Implement manual review for flagged cases"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "The system becomes fairer and more accurate.",
              "badEnding": "The process becomes inefficient while biases persist."
            }
          }
        ]
      },
      {
        "level": "Level 3 (Create)",
        "scenarios": [
          {
            "id": 26,
            "title": "AI Tool vs Climate Goals",
            "description": "Mr. Iqbal discovers that a new AI-based device used for science simulations consumes excessive energy and relies on imported components that are harmful to the environment. He wonders if promoting this tool contradicts his school's climate-conscious values.",
            "question": "What action should Mr. Iqbal take to ensure alignment with sustainable education values?",
            "options": [
              "Recommend the school continue using the tool but limit its usage",
              "Collect data, consult climate experts, and co-design an energy-efficient alternative with students",
              "Avoid discussing the issue and wait for the district to make a decision"
            ],
            "correctAnswer": 2,
            "feedback": "Creating an environmentally conscious AI tool engages students in sustainability and ethical innovation.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Sustainability Audit",
              "description": "Your school recently adopted an AI-based smart scheduling tool to optimize student and teacher timetables. You begin to notice that the system heavily relies on cloud computing services that contribute significantly to carbon emissions.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You read a report linking the AI tool's backend infrastructure to high energy use and carbon emissions.",
                  "options": [
                    "Present the data and propose an environmental audit of the tool",
                    "Ignore the report and focus on how efficient the scheduling has become"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "You present your findings to the school's tech committee. They agree to explore alternatives.",
                  "options": [
                    "Recommend switching to a low-energy open-source alternative",
                    "Suggest planting trees to offset the carbon emissions"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "The school transitions to a greener tool with local hosting. It sparks broader awareness of digital sustainability among staff and students.",
              "badEnding": "Tree planting is approved, but the AI tool's emissions continue unchecked. No systemic change occurs."
            }
          },
          {
            "id": 27,
            "title": "Multistakeholder Simulation",
            "description": "Ms. Nilofer leads a debate simulation where students represent stakeholders in AI regulation — from tech firms to indigenous community leaders — discussing how a new AI attendance system may affect marginalized youth.",
            "question": "What is the best way for Ms. Nilofer to extend the activity's impact?",
            "options": [
              "Write a class memo summarizing the debate",
              "Help students compile a formal draft policy to present to the school board",
              "Conclude the activity and move to the next topic"
            ],
            "correctAnswer": 2,
            "feedback": "Policy drafting from simulated debate encourages advocacy and real-world application of ethical principles.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Drafting Ethical Impact",
              "description": "Your students just completed a multistakeholder simulation about how an AI attendance system might marginalize youth from remote or underserved communities. They represented diverse voices — tech developers, school leaders, community elders, and students.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "The simulation ended, and students are energized but unsure what to do next.",
                  "options": [
                    "Guide them in drafting a shared ethical policy based on the debate",
                    "Let students individually reflect in their journals"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Students collaborate on a document outlining ethical standards and inclusion measures, with inputs from each stakeholder role.",
                  "options": [
                    "Submit the policy draft to the school board for real-world consideration",
                    "Keep it as a class record without sharing externally"
                  ]
                }
              ],
              "idealPath": "A-A",
              "idealEnding": "The school board acknowledges the proposal and agrees to discuss inclusive design in future AI tool adoptions. Students feel empowered and see their voice making a difference.",
              "badEnding": "The effort stays within the classroom. Students feel proud but miss the opportunity to influence actual change."
            }
          },
          {
            "id": 28,
            "title": "Disability-Inclusive AI",
            "description": "An AI assessment tool doesn't adapt to students with hearing disabilities. Ms. Mehreen and her learners explore this issue and begin co-designing alternative voice-text models.",
            "question": "What should Ms. Mehreen prioritize?",
            "options": [
              "Abandon the AI tool for traditional methods",
              "Partner with local developers and special educators to co-create an inclusive model",
              "Wait for the district to launch a new tool"
            ],
            "correctAnswer": 2,
            "feedback": "Co-creation empowers teachers and learners to innovate inclusively, addressing disability equity gaps.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Inclusive AI Redesign",
              "description": "You are Ms. Mehreen. Your classroom uses an AI assessment tool that doesn't recognize the needs of students with hearing disabilities. You decide to act with your students.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You notice Ali and Sara, who use sign language, struggle to interact with the voice-based AI assessment.",
                  "options": [
                    "Temporarily exempt them from AI-based tasks",
                    "Start a classroom discussion on the accessibility gap"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Your students passionately suggest ideas to improve access. You gather thoughts about integrating text-based or sign-supported options.",
                  "options": [
                    "Reach out to local developers and special educators for technical collaboration",
                    "Document ideas but postpone action until next term"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "The new model becomes a case study for inclusive AI, and students feel proud to have co-created it.",
              "badEnding": "Students feel their input is ignored. The excitement fades, and the accessibility issue persists."
            }
          },
          {
            "id": 29,
            "title": "Ethics Hackathon",
            "description": "Mr. Saeed hosts an \\"Ethics in EdTech Hackathon,\\" inviting students to design AI tools that address bullying, low literacy, or cultural erasure.",
            "question": "How should Mr. Saeed ensure that the event leads to meaningful outcomes?",
            "options": [
              "Let students work freely and enjoy the experience",
              "Guide teams to align projects with AI ethical principles and present to a local education council",
              "Use the winning project in class regardless of ethical review"
            ],
            "correctAnswer": 2,
            "feedback": "Structured, ethics-aligned creativity supports responsible innovation in AI development.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Ethical Design Sprint",
              "description": "You are Mr. Saeed. You're organizing an \\"Ethics in EdTech Hackathon\\" where students create AI tools to address real problems like bullying or cultural erasure.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You introduce the event but notice teams immediately start coding without discussing ethical guidelines.",
                  "options": [
                    "Let them continue — creativity should be unrestricted",
                    "Provide them with an ethics checklist for AI development"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "Students begin rethinking their designs, identifying risks and safeguards before implementation.",
                  "options": [
                    "Invite a panel of local educators and community members to evaluate the final projects",
                    "Choose the winners based only on technical features"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Students learn how ethics strengthen innovation. They feel proud of making socially valuable tools.",
              "badEnding": "Projects work technically but ignore ethical risks. A bullying-report app raises privacy concerns and gets rejected by the school."
            }
          },
          {
            "id": 30,
            "title": "Regulating Algorithmic Decisions",
            "description": "A scholarship platform uses an AI to shortlist candidates. Mr. Rahim finds that minority language students are consistently overlooked.",
            "question": "What should Mr. Rahim do?",
            "options": [
              "Write a blog about the problem",
              "Work with peers and legal experts to simulate a regulatory framework that ensures fairness in AI selection",
              "Ask students to apply to other platforms"
            ],
            "correctAnswer": 2,
            "feedback": "Simulating regulatory models allows teachers to lead in ethical reforms for AI tools in education.",
            "activity": {
              "type": "Interactive Simulation",
              "name": "Fairness Framework Simulation",
              "description": "You are Mr. Rahim. You discover that an AI-based scholarship platform overlooks students from minority language backgrounds.",
              "scenes": [
                {
                  "sceneNumber": 1,
                  "description": "You gather data showing repeated exclusion of Wakhi- and Shina-speaking students.",
                  "options": [
                    "Publish an open letter on social media",
                    "Bring the issue to your school's digital ethics committee"
                  ]
                },
                {
                  "sceneNumber": 2,
                  "description": "The committee asks you to propose how such platforms can be made more equitable.",
                  "options": [
                    "Collaborate with colleagues and legal experts to simulate a fair algorithm policy",
                    "Recommend stopping AI use in scholarship platforms"
                  ]
                }
              ],
              "idealPath": "B-A",
              "idealEnding": "Your efforts influence policy talks, and other schools start replicating your model.",
              "badEnding": "The platform is abandoned, but no alternatives exist. Marginalized students remain excluded from scholarship visibility."
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