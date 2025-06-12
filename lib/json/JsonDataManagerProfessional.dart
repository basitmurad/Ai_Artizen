
import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManagerProfessional {
  static const String moduleJsonData = '''
{
  "module": "Module 1",
  "levels": [
    {
      "level": "Level 1 (Acquire)",
      "scenarios": [
        {
          "id": 1,
          "title": "Balancing Efficiency and Equity: Addressing Bias in AI Grading",
          "description": "Ms. Ayesha notices that an AI grading tool consistently gives lower scores to students from marginalized language backgrounds. One of her students, Karim, receives a low grade despite writing a thoughtful essay. When she brings it up, the principal, Mr. Imran, insists that the tool is helpful because it saves time and reduces workload.",
          "options": [
            "Accept the tool but manually adjust grades for marginalized students.",
            "Reject the tool and grade essays yourself, despite the extra time.",
            "Advocate for a hybrid system (AI drafts + teacher reviews)."
          ],
          "correctAnswer": 3,
          "feedback": "Correct! A hybrid approach balances efficiency with fairness. Teachers play a critical role in ensuring that AI tools do not reinforce bias.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "A teacher raises Karim's grade because the AI tool graded him unfairly.",
                "correct": "Fair",
                "feedback": "Raising a student's grade to correct an AI error shows human judgment and fairness. This reflects a core value of a human-centred mindset --- AI should support, not replace, teacher responsibility."
              },
              {
                "statement": "The school updates the AI tool to reduce language bias.",
                "correct": "Fair",
                "feedback": "Updating the AI tool to reduce language bias is a proactive way to ensure inclusivity. A human-centred approach means using technology to serve all students equally and ethically."
              },
              {
                "statement": "A teacher changes grades quietly without informing students or admins.",
                "correct": "Unfair",
                "feedback": "Making changes quietly, even if well-intentioned, removes transparency. A human-centred mindset respects student agency and promotes trust through open communication and accountability."
              }
            ],
            "completionMessage": "Well done! A human-centred approach means using AI responsibly --- combining technology with transparency, inclusivity, and teacher judgment to ensure fairness for every student."
          }
        },
        {
          "id": 2,
          "title": "Data Bias in AI Design",
          "description": "Kamal is building a student behavior prediction system. He collects disciplinary records from 10 elite private schools. His colleague wonders why the AI flags rural students more often as 'at-risk.'",
          "question": "What issue in the *data collection* stage is likely affecting the system's fairness?",
          "options": [
            "The AI is working correctly",
            "The data lacks rural representation",
            "The system should ignore location",
            "Behavior data cannot be analyzed by AI"
          ],
          "correctAnswer": 2,
          "feedback": "Correct! Biased training data leads to biased outcomes. AI systems must be trained on diverse, representative datasets to ensure fairness and avoid reinforcing inequalities.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Data or Bias?",
            "cards": [
              {
                "statement": "AI flags rural students as 'at-risk' more than urban students, based on elite school data.",
                "correct": "Biased Outcome",
                "feedback": "This reflects biased data --- rural students are unfairly flagged due to lack of representation."
              },
              {
                "statement": "AI tool penalizes students who use local dialects in essays.",
                "correct": "Biased Outcome",
                "feedback": "Penalizing local dialects is unfair. AI should respect linguistic and cultural diversity."
              },
              {
                "statement": "AI recommends extra support for students with inconsistent attendance.",
                "correct": "Valid Pattern",
                "feedback": "Inconsistent attendance is a fair indicator. AI can help when used with human judgment."
              }
            ],
            "completionMessage": "Nice work! While AI can detect real patterns, we must stay alert to biases in the data. Fairness means asking *why* the pattern exists --- and always considering student context."
          }
        },
        {
          "id": 3,
          "title": "Career Choices and AI Influence",
          "description": "A school uses an AI chatbot to suggest career paths for students based on their interests and performance data. Students begin to accept the AI's suggestions without questioning them or exploring alternatives. Teachers notice that students are no longer researching career options or discussing their aspirations.",
          "question": "What human capacity is being diminished in this case?",
          "options": [
            "Decision-making and personal reflection",
            "Access to online tools",
            "Student discipline",
            "Focus on short-term goals"
          ],
          "correctAnswer": 1,
          "feedback": "Correct! Over-reliance on AI can suppress students' ability to think critically, reflect on their goals, and make independent choices.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "Hamza dreams of being a journalist. The AI suggests accounting, so he quietly changes his plan.",
                "correct": "Unfair",
                "feedback": "When students change their dreams because of AI suggestions without reflection, it's unfair to their personal goals. A human-centred mindset supports student agency and voice."
              },
              {
                "statement": "Hamza talks to a teacher and reflects on both journalism and accounting.",
                "correct": "Fair",
                "feedback": "This approach respects student agency and encourages guided reflection. It keeps human insight and personal choice central to decision-making."
              },
              {
                "statement": "Hamza lets his friends vote to decide what he should do.",
                "correct": "Unfair",
                "feedback": "Important life choices shouldn't be crowdsourced. A human-centred mindset encourages individual reflection and support from trusted mentors."
              },
              {
                "statement": "Hamza asks the AI to update its suggestions with more information about his interests.",
                "correct": "Fair",
                "feedback": "Using AI interactively can support better outcomes, especially when guided by personal input. This keeps the student in control of the process."
              }
            ],
            "completionMessage": "Well done! AI should support --- not replace --- student decision-making. Fair outcomes happen when students reflect, seek guidance, and stay connected to their own goals."
          }
        },
        {
          "id": 4,
          "title": "Too Smart to Choose?",
          "description": "Ms. Nida uses an AI-powered tutoring app that personalizes lessons for her students. The app skips topics it predicts students will struggle with, aiming to maximize efficiency. Over time, students begin to feel frustrated and limited---they aren't allowed to challenge themselves or explore areas of interest. 'It's like the app decides what I'm capable of,' one student complains.",
          "question": "What should Ms. Nida do to protect student agency and promote ownership of learning?",
          "options": [
            "Keep using the app because it improves test scores",
            "Let students opt out and design their own learning paths",
            "Modify the app to allow student input (e.g., personal goals, topic choices)"
          ],
          "correctAnswer": 3,
          "feedback": "Correct! Integrating student input ensures AI supports learning rather than limiting growth. Personal goals and choice empower learners.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "The AI app should decide what students learn --- it's based on data.",
                "correct": "Unfair",
                "feedback": "Relying only on AI removes student voice and teacher insight. A human-centred mindset values personal context over data alone."
              },
              {
                "statement": "The teacher should decide --- they know the curriculum best.",
                "correct": "Unfair",
                "feedback": "Teachers are essential, but students should also have a say. Learning works best when it's collaborative and student-centred."
              },
              {
                "statement": "The student should decide --- it's their learning journey.",
                "correct": "Fair (Partially)",
                "feedback": "Student voice is key, but decisions are strongest when supported by both data and guidance. Collaboration creates balance."
              },
              {
                "statement": "A mix of AI, teacher input, and student voice should shape learning.",
                "correct": "Fair",
                "feedback": "A balanced, human-centred approach includes AI support, teacher guidance, and student ownership. All voices matter in shaping learning."
              }
            ],
            "completionMessage": "Great job! Learning decisions should be shared --- combining smart tools, educator expertise, and student goals to build meaningful and fair education pathways."
          }
        },
        {
          "id": 5,
          "title": "Watching to Teach?",
          "description": "A new AI surveillance tool is installed in Ms. Sana's classroom. It monitors students' screens and automatically flags those it detects as 'distracted.' While the school reports improved focus, parents express concerns about constant monitoring and its effect on students' trust, autonomy, and mental well-being.",
          "question": "What should Ms. Sana do to balance classroom management with respect for student agency?",
          "options": [
            "Enable the tool fully because it improves classroom discipline",
            "Disable the tool and rely on teacher observations and student trust",
            "Limit the tool's use to specific contexts (e.g., during high-stakes exams)"
          ],
          "correctAnswer": 3,
          "feedback": "Correct! Context-sensitive use of surveillance tools protects student autonomy while maintaining necessary oversight.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "The AI surveillance tool is turned on all day, every day, to ensure students stay focused.",
                "correct": "Unfair",
                "feedback": "Constant monitoring may harm student trust and mental well-being. A human-centred approach respects student privacy and promotes self-regulation."
              },
              {
                "statement": "The school limits AI monitoring to high-stakes assessments only.",
                "correct": "Fair",
                "feedback": "Using surveillance selectively --- in appropriate contexts --- balances accountability with respect for student autonomy."
              },
              {
                "statement": "Students are informed how and when the AI tool will be used in class.",
                "correct": "Fair",
                "feedback": "Transparency builds trust. When students understand how tools are used, it promotes ethical, respectful learning environments."
              },
              {
                "statement": "Teachers use AI flags without checking context or talking to students.",
                "correct": "Unfair",
                "feedback": "AI should assist, not replace, teacher judgment. Mislabeling behavior without context can unfairly impact students."
              }
            ],
            "completionMessage": "Well done! Fair use of classroom AI means using it transparently, with context and care. Respect for student trust and autonomy is just as important as maintaining focus."
          }
        }
      ]
    },
    {
      "level": "Level 2 (Deepen)",
      "scenarios": [
        {
          "id": 6,
          "title": "Who Is Accountable for AI Errors?",
          "description": "Mr. Sajid, a school administrator, implements an AI system to allocate students to courses based on past performance. Later, a parent complains that their child, Sara, was unfairly placed in a low-level course despite her teacher's recommendations. Mr. Sajid claims the AI made the final decision, not him.",
          "question": "What should Mr. Sajid do?",
          "options": [
            "Clarify that human oversight is necessary and revise the decision with input from the teacher.",
            "Let the AI decision stand to avoid inconsistency in future placements.",
            "Shift the blame to the AI provider since the system made the error."
          ],
          "correctAnswer": 1,
          "feedback": "Correct! Human oversight is essential to ensure fair and ethical use of AI in education.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "Sara was placed in a low-level course by AI, and the decision is left unchanged.",
                "correct": "Unfair",
                "feedback": "Letting AI decide without review ignores human judgment. A human-centred approach requires educators to step in when needed."
              },
              {
                "statement": "The school asks the AI provider to review Sara's placement decision.",
                "correct": "Unfair",
                "feedback": "While provider input can help, responsibility for student outcomes lies with educators --- not the toolmakers."
              },
              {
                "statement": "Mr. Sajid (admin) works with Sara's teacher to revise the placement decision.",
                "correct": "Fair",
                "feedback": "Correct! Humans must remain responsible for student decisions. AI can support, but final choices need personal judgment and context."
              }
            ],
            "completionMessage": "Nice work! AI should guide, not decide. Fair education happens when teachers, not just algorithms, shape student opportunities with care and context."
          }
        },
        {
          "id": 7,
          "title": "Reviewing AI Appropriateness",
          "description": "Ms. Noreen uses an AI chatbot to facilitate student discussions. It often overlooks local values and promotes individualistic ideas. She begins to question if it's suitable for her culturally diverse classroom.",
          "question": "What should she do?",
          "options": [
            "Continue using it since it encourages critical thinking.",
            "Evaluate the tool's fit for her context and suggest adjustments or alternatives.",
            "Limit its use, but avoid addressing the issue with the administration."
          ],
          "correctAnswer": 2,
          "feedback": "Evaluating the tool's cultural relevance ensures it supports inclusive and context-sensitive learning.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "An AI tool suggests students remove regional examples to sound more 'neutral' in their writing.",
                "correct": "Unfair",
                "feedback": "Removing local context can erase student identity. A fair AI tool should support, not suppress, cultural expression."
              },
              {
                "statement": "A teacher checks if an AI chatbot aligns with local values before using it for class discussions.",
                "correct": "Fair",
                "feedback": "Evaluating tools for cultural fit helps ensure they support inclusive, relevant learning environments."
              },
              {
                "statement": "AI tools are used without review because they are 'global' and widely used.",
                "correct": "Unfair",
                "feedback": "Popular tools may still carry bias. Responsible use means checking if they fit your students' context and values."
              }
            ],
            "completionMessage": "Nice work! Fair AI use in the classroom means choosing tools that uplift local culture and student voice --- not just following what's trending."
          }
        },
        {
          "id": 8,
          "title": "Policy Advocacy for Accountability",
          "description": "Mr. Bilal learns that an AI tool used for student discipline disproportionately flags students from underprivileged areas. He wants to act but feels restricted by school policy.",
          "question": "What should Mr. Bilal do?",
          "options": [
            "Advocate for policy review and transparency in the AI's criteria.",
            "Ignore it since the AI decisions are backed by administration.",
            "Secretly tell students how to avoid triggering the AI."
          ],
          "correctAnswer": 1,
          "feedback": "Advocating transparency promotes fairness and ethical use of AI in school policies.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "A teacher notices bias in an AI tool and brings it to the school leadership for review.",
                "correct": "Fair",
                "feedback": "Speaking up supports fairness. Advocacy helps schools improve AI systems and protect all students."
              },
              {
                "statement": "An AI tool flags more students from certain neighborhoods, but staff ignore the pattern because the tool is official.",
                "correct": "Unfair",
                "feedback": "Ignoring bias just because a tool is approved is unfair. Accountability means questioning outcomes --- even from trusted sources."
              },
              {
                "statement": "A teacher advises students privately on how to avoid being flagged by the AI, without addressing the real issue.",
                "correct": "Unfair",
                "feedback": "Working around the system in secret avoids real change. True fairness comes from open conversations and policy improvements."
              }
            ],
            "completionMessage": "Well done! Responsible AI use means standing up for fairness --- not just accepting what a system says. Teachers play a key role in pushing for accountability and ethical change."
          }
        },
        {
          "id": 9,
          "title": "Decision Support, Not Replacement",
          "description": "Ms. Tehmina uses an AI app to recommend learning strategies. It often suggests standard techniques that don't suit her students with special needs. She worries it's limiting her instructional choices.",
          "question": "What should she do?",
          "options": [
            "Use the AI suggestions as one of several inputs, not final decisions.",
            "Avoid using AI altogether to prevent bias.",
            "Stick with the AI plans to stay efficient and consistent."
          ],
          "correctAnswer": 1,
          "feedback": "AI should support, not replace, professional judgment---especially for diverse learner needs.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "A teacher combines AI suggestions with her own knowledge to meet individual student needs.",
                "correct": "Fair",
                "feedback": "That's the right balance! AI should be a helpful tool, not the final authority --- especially for diverse classrooms."
              },
              {
                "statement": "The teacher follows all AI recommendations without adjusting them for students with special needs.",
                "correct": "Unfair",
                "feedback": "AI doesn't understand every student's context. Educators must adapt and personalize for fairness and inclusion."
              },
              {
                "statement": "The teacher stops using AI completely to avoid making any mistakes.",
                "correct": "Unfair",
                "feedback": "Avoiding AI entirely can limit helpful insights. The key is using it wisely --- alongside professional judgment."
              }
            ],
            "completionMessage": "Great work! AI works best when teachers stay in control --- using it as one input among many, not a replacement for their expertise."
          }
        },
        {
          "id": 10,
          "title": "Transparency in Teacher Roles",
          "description": "A new AI analytics platform is used to monitor teachers' performance. Ms. Mahira notices it penalizes collaborative teaching styles. She wants to address this bias.",
          "question": "What should she do?",
          "options": [
            "Propose teacher input in evaluating AI-generated insights.",
            "Adjust her teaching style to match what the AI rewards.",
            "Focus only on student outcomes and ignore how she's evaluated."
          ],
          "correctAnswer": 1,
          "feedback": "Including teacher input helps ensure AI evaluations are fair, balanced, and context-aware.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "A teacher gives feedback on how AI evaluates teaching methods and asks for adjustments.",
                "correct": "Fair",
                "feedback": "Teacher input is essential. It ensures AI tools reflect the realities of the classroom and respect diverse teaching styles."
              },
              {
                "statement": "Teachers change their approach just to align with what the AI rewards.",
                "correct": "Unfair",
                "feedback": "Adapting only to please AI can harm teaching quality. Good evaluation tools must support --- not control --- professional creativity."
              },
              {
                "statement": "Teachers ignore how they're being evaluated and just focus on student results.",
                "correct": "Unfair",
                "feedback": "Fair evaluation matters. Ignoring flawed systems doesn't fix them --- teacher advocacy leads to better tools and accountability."
              }
            ],
            "completionMessage": "Well done! AI can support evaluation, but only when teachers help shape how it's used. Fair systems include human insight and context."
          }
        }
      ]
    },
    {
      "level": "Level 3 (Create)",
      "scenarios": [
        {
          "id": 11,
          "title": "AI in Admissions",
          "description": "A private school in Lahore uses an AI tool to screen admission applications. The system rejects students from low-income areas due to 'language proficiency gaps' detected in essays. Parents protest, citing bias against regional dialects.",
          "question": "What should the school do?",
          "options": [
            "Defend the AI's decision, citing 'standardized criteria.'",
            "Audit the AI for bias, involve teachers in manual reviews, and adjust the system.",
            "Blame the parents for not preparing their children to meet the AI's standards."
          ],
          "correctAnswer": 2,
          "feedback": "Human oversight is critical to ensure fairness. AI must be audited and adapted to local linguistic diversity.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "We'll review how the AI evaluates language and check for cultural bias.",
                "correct": "Fair",
                "feedback": "Proactively checking for bias helps ensure fair treatment for all students."
              },
              {
                "statement": "The AI uses standard rules --- we don't need to change anything.",
                "correct": "Unfair",
                "feedback": "Assuming AI is always fair without review can reinforce hidden biases."
              },
              {
                "statement": "Let's include teachers to help review applications manually.",
                "correct": "Fair",
                "feedback": "Human oversight combined with AI creates more balanced decisions."
              },
              {
                "statement": "Parents need to train their kids better for AI evaluation.",
                "correct": "Unfair",
                "feedback": "Blaming families ignores systemic biases in AI design."
              }
            ],
            "completionMessage": "Great job! Schools should review AI tools regularly to prevent bias and ensure all students get a fair chance --- regardless of background."
          }
        },
        {
          "id": 12,
          "title": "AI for Teacher Evaluations",
          "description": "An AI system in Karachi grades teachers based on student test scores. A dedicated teacher, Ms. Fatima, receives a low rating because her underprivileged students scored poorly, despite her efforts.",
          "question": "How should the administration respond?",
          "options": [
            "Trust the AI's judgment and demote Ms. Fatima.",
            "Add qualitative metrics (e.g., student engagement, peer reviews) to evaluations.",
            "Ask Ms. Fatima to 'train' the AI by inputting her own feedback."
          ],
          "correctAnswer": 2,
          "feedback": "AI must account for socio-economic context. Holistic evaluation ensures fairness.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "Include peer reviews and student engagement in teacher evaluations.",
                "correct": "Fair",
                "feedback": "Holistic evaluations give a fuller picture of teacher performance."
              },
              {
                "statement": "Base teacher ratings only on student test scores.",
                "correct": "Unfair",
                "feedback": "This overlooks the broader efforts teachers make, especially in underserved areas."
              },
              {
                "statement": "Adjust evaluation methods to account for students' socio-economic background.",
                "correct": "Fair",
                "feedback": "Context matters---teachers should not be penalized for challenges beyond their control."
              },
              {
                "statement": "Trust the AI ratings fully because it's data-driven.",
                "correct": "Unfair",
                "feedback": "AI can reflect biased data---human judgment must guide final decisions."
              }
            ],
            "completionMessage": "Well done! Fair evaluations respect context and go beyond numbers. AI should support, not replace, thoughtful teacher assessment."
          }
        },
        {
          "id": 13,
          "title": "AI and Urdu Language Bias",
          "description": "An AI writing assistant corrects students' Urdu essays to reflect elite Islamabad dialects, erasing regional idioms. Rural students feel alienated.",
          "question": "How to resolve this?",
          "options": [
            "Tell students to 'adapt' to the AI's 'standardized' Urdu.",
            "Customize the AI to accept diverse dialects and celebrate linguistic diversity.",
            "Disable Urdu support to avoid further issues."
          ],
          "correctAnswer": 2,
          "feedback": "AI should preserve cultural identity, not erase it.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "AI tools should be adapted to recognize and respect regional language variations.",
                "correct": "Fair",
                "feedback": "Adapting AI to linguistic diversity ensures all users feel included."
              },
              {
                "statement": "Students should change how they write to match elite or urban language norms.",
                "correct": "Unfair",
                "feedback": "Expecting conformity to elite norms ignores cultural and regional richness."
              },
              {
                "statement": "Linguistic diversity should be seen as a strength in educational contexts.",
                "correct": "Fair",
                "feedback": "Valuing diverse expressions fosters equity and belonging."
              },
              {
                "statement": "Disabling features that struggle with dialects is better than fixing them.",
                "correct": "Unfair",
                "feedback": "Avoiding the issue stops progress---AI should evolve to be more inclusive."
              }
            ],
            "completionMessage": "Well done! Culturally aware AI supports fairness and identity. Language is not just grammar---it's connection and expression."
          }
        },
        {
          "id": 14,
          "title": "AI and Disability Inclusion",
          "description": "An AI-powered platform in Quetta fails to accommodate visually impaired students, as it relies on visual quizzes. Teachers complain, but the vendor says updates are 'too costly.'",
          "question": "What should the school prioritize?",
          "options": [
            "Wait for the vendor's future updates.",
            "Switch to an accessible tool or demand compliance with disability laws.",
            "Ask disabled students to opt out of AI-based activities."
          ],
          "correctAnswer": 2,
          "feedback": "Human rights override cost concerns. Accessible design is non-negotiable.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "All students, including those with disabilities, should be able to use AI tools equally.",
                "correct": "Fair",
                "feedback": "Inclusive design ensures no learner is left behind."
              },
              {
                "statement": "If accessibility is expensive, it's okay to exclude a few students temporarily.",
                "correct": "Unfair",
                "feedback": "Equity is a right, not an option---cost doesn't justify exclusion."
              },
              {
                "statement": "Schools should choose or demand AI tools that follow accessibility standards.",
                "correct": "Fair",
                "feedback": "Responsibility lies with institutions to ensure all tools meet learners' needs."
              },
              {
                "statement": "Students with disabilities can be given alternative non-digital tasks.",
                "correct": "Unfair",
                "feedback": "Segregating students denies them equal opportunities and experiences."
              }
            ],
            "completionMessage": "Great job! Inclusive AI design respects everyone's right to learn. Accessibility is not optional---it's essential."
          }
        },
        {
          "id": 15,
          "title": "AI and Climate Education",
          "description": "An AI lesson generator in Punjab skips climate change topics, calling them 'too political.' Science teachers want to address Pakistan's floods and heat waves.",
          "question": "What should the curriculum team do?",
          "options": [
            "Avoid 'controversial' topics to comply with AI limitations.",
            "Override the AI and prioritize locally relevant climate education.",
            "Let teachers handle climate topics outside the AI system."
          ],
          "correctAnswer": 2,
          "feedback": "AI must align with planetary well-being, not corporate or political avoidance.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "AI tools in education should support locally relevant topics like climate change.",
                "correct": "Fair",
                "feedback": "Ignoring real-world issues limits learning---AI must serve local and global needs."
              },
              {
                "statement": "If AI avoids sensitive topics, teachers should avoid them too.",
                "correct": "Unfair",
                "feedback": "Educators shouldn't be silenced by AI design flaws---students deserve truth."
              },
              {
                "statement": "Teachers and curriculum teams should adapt AI outputs to address urgent environmental concerns.",
                "correct": "Fair",
                "feedback": "AI is a tool---not the authority. Human judgment must guide learning priorities."
              },
              {
                "statement": "Controversial or political topics should be avoided entirely in AI-assisted lessons.",
                "correct": "Unfair",
                "feedback": "What's labeled 'controversial' can be essential---climate literacy is a must for the future."
              }
            ],
            "completionMessage": "Well done! AI should empower---not limit---education on urgent issues like climate change. Teaching for the planet means teaching with purpose."
          }
        }
      ]
    }
  ]
}
''';

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
