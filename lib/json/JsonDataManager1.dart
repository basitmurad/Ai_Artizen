import 'dart:convert';

import '../models/JsonModel.dart';

class JsonDataManager1 {
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
            "Combine AI grading with teacher review for fairness.",
            "Rely solely on manual assessment and discontinue AI grading.",
            "Trust AI outputs, as they reduce the workload."
          ],
          "correctAnswer": 1,
          "feedback": "Great!! A hybrid approach balances efficiency with fairness. Teachers play a critical role in ensuring that AI tools do not reinforce bias.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "An AI essay-grading tool provides instant feedback to students, but it struggles to recognize creative writing styles.",
                "correct": "Unfair",
                "feedback": "While AI offers speed and consistency, its inability to appreciate creativity is a limitation. Teachers should review AI feedback to ensure fairness and adaptability to diverse student work."
              },
              {
                "statement": "A university uses AI-powered invigilation software to detect cheating during exams, but it flags innocent movements (e.g., looking away) as suspicious.",
                "correct": "Unfair",
                "feedback": "Over-reliance on AI invigilation can create false accusations and stress. Human oversight is critical to balance integrity with trust in students."
              },
              {
                "statement": "An AI tutoring tool adapts lessons to each student's learning pace, helping struggling learners catch up.",
                "correct": "Fair",
                "feedback": "Personalized AI tools can enhance equity by supporting individual needs. This is a key benefit—when used as a supplement, not a replacement, for teacher guidance."
              }
            ],
            "completionMessage": "Great job! AI in education has benefits, limitations (bias, rigidity), and risks (over-reliance, privacy concerns). The key is to use AI ethically and augment human roles, not replacing them, while addressing its flaws proactively."
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
            "AI cannot analyze behavior data"
          ],
          "correctAnswer": 2,
          "feedback": "Correct! Biased training data leads to biased outcomes. AI systems must be trained on diverse, representative datasets to ensure fairness and avoid reinforcing inequalities.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Data or Bias?",
            "cards": [
              {
                "statement": "A developer ignores feedback about gender bias in training data to meet a tight deadline.",
                "correct": "Unfair",
                "feedback": "Individual choices (like prioritizing speed over fairness) lead to AI that perpetuates harmful biases."
              },
              {
                "statement": "A company rejects auditing its AI tool for racial bias to cut costs.",
                "correct": "Unfair",
                "feedback": "Corporate decisions (like avoiding audits) directly enable unfair AI outcomes."
              },
              {
                "statement": "A team revises its AI model after testing it with diverse user groups.",
                "correct": "Fair",
                "feedback": "Proactive decisions (inclusive testing) improve fairness—showing how creator choices shape AI impacts."
              }
            ],
            "completionMessage": "Every decision in AI creation—from individual coding choices to corporate policies—shapes whether tools help or harm. Always ask: Who benefits? Who's left out?"
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
                "feedback": "When students change their dreams because of AI suggestions without reflection, it's unfair to their personal goals. A human-centered mindset supports student agency and voice."
              },
              {
                "statement": "Hamza talks to a teacher and reflects on both journalism and accounting.",
                "correct": "Fair",
                "feedback": "This approach respects student agency and encourages guided reflection. It keeps human insight and personal choice central to decision-making."
              },
              {
                "statement": "Hamza lets his friends vote to decide what he should do.",
                "correct": "Unfair",
                "feedback": "Important life choices shouldn't be crowdsourced. A human-centered mindset encourages individual reflection and support from trusted mentors."
              },
              {
                "statement": "Hamza asks the AI to update its suggestions with more information about his interests.",
                "correct": "Fair",
                "feedback": "Using AI interactively can support better outcomes, especially when guided by personal input. This keeps the student in control of the process."
              }
            ],
            "completionMessage": "Well done! AI should support — not replace — student decision-making. Fair outcomes happen when students reflect, seek guidance, and stay connected to their own goals."
          }
        },
        {
          "id": 4,
          "title": "Too Smart to Choose?",
          "description": "Ms. Nida uses an AI-powered tutoring app that personalizes lessons for her students. The app skips topics it predicts students will struggle with, aiming to maximize efficiency. Over time, students begin to feel frustrated and limited—they aren't allowed to challenge themselves or explore areas of interest. 'It's like the app decides what I'm capable of,' one student complains.",
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
                "statement": "An AI tool automatically adjusts math difficulty for all 3rd graders based on national averages.",
                "correct": "Unfair",
                "feedback": "National data may not fit local needs. Teachers should adapt AI suggestions to their students' actual levels and cultural context."
              },
              {
                "statement": "A school uses AI to monitor students' emotions during online lessons to 'identify disengagement.'",
                "correct": "Unfair",
                "feedback": "Emotion-tracking AI risks privacy and misinterprets cultural/individual behaviors. Always ask: Is this tool necessary and consensual?"
              },
              {
                "statement": "Teachers use AI to generate science lab ideas but adapt them for their students' safety and local resources.",
                "correct": "Fair",
                "feedback": "AI sparks ideas, but teacher judgment ensures safety and relevance. This balanced approach respects both innovation and context."
              }
            ],
            "completionMessage": "Well done! AI risks depend on how tools align with your students' realities. Critical questions to ask: Does this fit my subject's goals? Does it respect my students' backgrounds? Could it cause unintended harm?"
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
                "statement": "An AI reading tool is designed to help students improve, but teachers weren't asked what reading challenges their students face.",
                "correct": "Unfair",
                "feedback": "When teachers are excluded, the tool may miss real classroom needs. Teachers ground AI in authentic learning contexts."
              },
              {
                "statement": "Developers collect writing samples from a range of schools, and teachers help check if the data reflects student diversity.",
                "correct": "Fair",
                "feedback": "Teachers help ensure data is inclusive and meaningful. Their input reduces the risk of bias in AI outcomes."
              },
              {
                "statement": "The AI grading tool is tested only by engineers, with no teacher input on grading accuracy or fairness.",
                "correct": "Unfair",
                "feedback": "Teachers are essential in evaluating how well AI tools understand student work. Their feedback protects learning equity."
              },
              {
                "statement": "Teachers use AI suggestions as a starting point but always apply their own judgment before finalizing feedback.",
                "correct": "Fair",
                "feedback": "Responsible use of AI means blending automation with professional insight. Teachers ensure that AI supports, not replaces, learning."
              }
            ],
            "completionMessage": "Well done! You've explored how teachers are key decision-makers in the AI lifecycle—from defining problems to using tools in class. When educators are involved at every step, AI becomes more ethical, accurate, and educationally meaningful."
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
            "Review the placement process and include teacher input to make necessary adjustments.",
            "Maintain the current placement to ensure procedural consistency across all students.",
            "Refer the concern to the AI vendor and await their explanation before taking action."
          ],
          "correctAnswer": 1,
          "feedback": "Correct! Human oversight is essential to ensure fair and ethical use of AI in education.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Accountability in AI Decision Loops",
            "cards": [
              {
                "statement": "An AI schedules all teacher assignments based on 'optimized productivity metrics,' with no principal oversight.",
                "correct": "Unfair",
                "feedback": "Without human checks, AI may ignore teacher strengths/needs. Accountability requires leaders to review algorithmic decisions."
              },
              {
                "statement": "A district auto-fails students flagged by AI for 'plagiarism' without teacher review.",
                "correct": "Unfair",
                "feedback": "False positives harm students! Human judgment is essential to verify AI accusations and consider context."
              },
              {
                "statement": "AI recommends replacing group projects with solo tasks for 'efficiency,' despite collaboration being a course goal.",
                "correct": "Unfair",
                "feedback": "AI can't align with pedagogical values alone. Teachers must evaluate if tools support learning objectives."
              }
            ],
            "completionMessage": "AI systems need built-in human oversight. Always identify: Who checks the AI's work? Who fixes errors? In education, human accountability isn't optional - it's essential for ethical AI implementation."
          }
        },
        {
          "id": 7,
          "title": "Reviewing AI Appropriateness",
          "description": "Ms. Noreen uses an AI chatbot to facilitate student discussions. It often overlooks local values and promotes individualistic ideas. She begins to question if it's suitable for her culturally diverse classroom.",
          "question": "What should she do?",
          "options": [
            "Continue using it since it encourages critical thinking.",
            "Document the violations, pause its use, and advocate for a policy-compliant review process.",
            "Limit its use, but avoid addressing the issue with the administration."
          ],
          "correctAnswer": 2,
          "feedback": "Evaluating the tool's cultural relevance ensures it supports inclusive and context-sensitive learning.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair? Cultural Relevance in AI Use",
            "cards": [
              {
                "statement": "An AI tool ignores district equity policies by removing cultural examples. A teacher reports this to the compliance officer.",
                "correct": "Fair",
                "feedback": "Reporting policy violations ensures human accountability. AI must align with legal standards."
              },
              {
                "statement": "A teacher checks if an AI tool meets national education laws before use.",
                "correct": "Fair",
                "feedback": "Proactive reviews fulfill legal obligations. Accountability requires policy awareness."
              },
              {
                "statement": "A school uses AI despite known policy violations, claiming 'technical efficiency' outweighs compliance.",
                "correct": "Unfair",
                "feedback": "No tool is exempt from policy. Human oversight must enforce legal standards."
              }
            ],
            "completionMessage": "Human accountability isn't optional—it's a legal duty. Always verify AI tools against policies and advocate for compliance."
          }
        },
        {
          "id": 8,
          "title": "Policy Advocacy for Accountability",
          "description": "Mr. Bilal learns that an AI tool used for student discipline disproportionately flags students from underprivileged areas. He wants to act but feels restricted by school policy.",
          "question": "What should Mr. Bilal do?",
          "options": [
            "Request a review of the AI tool's criteria and its impact on student equity.",
            "Follow the policy and continue using the AI tool without raising concerns.",
            "Advise flagged students on how to avoid being targeted by the system."
          ],
          "correctAnswer": 1,
          "feedback": "Advocating transparency promotes fairness and ethical use of AI in school policies.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Advocacy and Accountability in AI Use",
            "cards": [
              {
                "statement": "A teacher notices bias in an AI tool and brings it to the school leadership for review.",
                "correct": "Fair",
                "feedback": "Speaking up supports fairness. Advocacy helps schools improve AI systems and protect all students."
              },
              {
                "statement": "An AI tool flags more students from certain neighborhoods, but staff ignore the pattern because the tool is official.",
                "correct": "Unfair",
                "feedback": "Ignoring bias just because a tool is approved is unfair. Accountability means questioning outcomes — even from trusted sources."
              },
              {
                "statement": "A teacher advises students privately on how to avoid being flagged by the AI, without addressing the real issue.",
                "correct": "Unfair",
                "feedback": "Working around the system in secret avoids real change. True fairness comes from open conversations and policy improvements."
              }
            ],
            "completionMessage": "Well done! Responsible AI use means standing up for fairness — not just accepting what a system says. Teachers play a key role in pushing for accountability and ethical change."
          }
        },
        {
          "id": 9,
          "title": "Decision Support, Not Replacement",
          "description": "Ms. Tehmina uses an AI app to recommend learning strategies. It often suggests standard techniques that don't suit her students with special needs. She worries it's limiting her instructional choices.",
          "question": "What should she do?",
          "options": [
            "Consider how the AI's advice fits her students' needs. Combine its suggestions with her professional judgment.",
            "Reduce her reliance on the AI tool for now. Focus on creating plans tailored to her specific classroom.",
            "Follow the AI's suggestions as a planning baseline. Adjust later if the strategies don't work well in class."
          ],
          "correctAnswer": 1,
          "feedback": "AI should support, not replace, professional judgment—especially for diverse learner needs.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Using AI to Support — Not Replace — Professional Judgment",
            "cards": [
              {
                "statement": "A teacher combines AI suggestions with her own knowledge to meet individual student needs.",
                "correct": "Fair",
                "feedback": "That's the right balance! AI should be a helpful tool, not the final authority — especially for diverse classrooms."
              },
              {
                "statement": "The teacher follows all AI recommendations without adjusting them for students with special needs.",
                "correct": "Unfair",
                "feedback": "AI doesn't understand every student's context. Educators must adapt and personalize for fairness and inclusion."
              },
              {
                "statement": "The teacher stops using AI completely to avoid making any mistakes.",
                "correct": "Unfair",
                "feedback": "Avoiding AI entirely can limit helpful insights. The key is using it wisely — alongside professional judgment."
              }
            ],
            "completionMessage": "Great work! AI works best when teachers stay in control — using it as one input among many, not a replacement for their expertise."
          }
        },
        {
          "id": 10,
          "title": "Transparency in Teacher Roles",
          "description": "A new AI analytics platform is used to monitor teachers' performance. Ms. Mahira notices it penalizes collaborative teaching styles. She wants to address this bias.",
          "question": "What should she do?",
          "options": [
            "Raise concerns about the platform's evaluation criteria and suggest ways to include diverse teaching styles.",
            "Gradually adapt her methods to align with what the AI favors while maintaining key elements of collaboration.",
            "Continue her current teaching style and disregard the platform's reports unless they affect her appraisal."
          ],
          "correctAnswer": 1,
          "feedback": "Including teacher input helps ensure AI evaluations are fair, balanced, and context-aware.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair AI Evaluation of Teachers",
            "cards": [
              {
                "statement": "A teacher gives feedback on how AI evaluates teaching methods and asks for adjustments.",
                "correct": "Fair",
                "feedback": "Teacher input is essential. It ensures AI tools reflect the realities of the classroom and respect diverse teaching styles."
              },
              {
                "statement": "Teachers change their approach just to align with what the AI rewards.",
                "correct": "Unfair",
                "feedback": "Adapting only to please AI can harm teaching quality. Good evaluation tools must support — not control — professional creativity."
              },
              {
                "statement": "Teachers ignore how they're being evaluated and just focus on student results.",
                "correct": "Unfair",
                "feedback": "Fair evaluation matters. Ignoring flawed systems doesn't fix them — teacher advocacy leads to better tools and accountability."
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
            "Support the AI's outcome, explaining it follows consistent admission guidelines.",
            "Place responsibility on families for not meeting expected language standards.",
            "Review the system for possible bias, including teacher input, and improve fairness."
          ],
          "correctAnswer": 3,
          "feedback": "Human oversight is critical to ensure fairness. AI must be audited and adapted to local linguistic diversity.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "AI systems should be regularly audited to check if they unintentionally disadvantage certain communities.",
                "correct": "Fair",
                "feedback": "Ongoing audits help ensure AI doesn't reinforce systemic inequalities — that's a fair and ethical approach."
              },
              {
                "statement": "Including teachers and cultural experts in AI review panels can help ensure tools reflect real-world diversity.",
                "correct": "Fair",
                "feedback": "This is a collaborative approach that values human insight and helps prevent AI from becoming disconnected from lived realities."
              },
              {
                "statement": "Using AI to filter applicants solely based on writing style makes the process more efficient — there's no need for human input.",
                "correct": "Unfair",
                "feedback": "Efficiency at the cost of fairness is dangerous. AI needs human checks to ensure inclusive decision-making."
              }
            ],
            "completionMessage": "Excellent work! Recognizing what's fair or unfair in AI use helps us build systems that are inclusive, just, and human-centered — especially in spaces as critical as education."
          }
        },
        {
          "id": 12,
          "title": "AI for Teacher Evaluations",
          "description": "An AI system in Karachi grades teachers based on student test scores. A dedicated teacher, Ms. Fatima, receives a low rating because her underprivileged students scored poorly, despite her efforts.",
          "question": "How should the administration respond?",
          "options": [
            "Recommend collecting feedback from various schools before scaling up.",
            "Suggest using the system only in top-performing schools.",
            "Focus on adjusting her own lessons to align with the AI tool."
          ],
          "correctAnswer": 1,
          "feedback": "AI must account for socio-economic context. Holistic evaluation ensures fairness.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "AI systems for teacher evaluations should be tested in both urban and rural schools before any official rollout.",
                "correct": "Fair",
                "feedback": "Inclusive testing helps ensure policies reflect diverse school contexts, not just tech-privileged environments."
              },
              {
                "statement": "We should mandate AI evaluations in all schools now, and make adjustments later if problems come up.",
                "correct": "Unfair",
                "feedback": "Premature implementation without input or testing may embed bias and erode trust in AI systems."
              },
              {
                "statement": "Teachers and school leaders should be invited to co-develop guidelines for AI use in evaluations.",
                "correct": "Fair",
                "feedback": "Participatory policymaking helps ensure AI tools align with real classroom needs and builds trust in new systems."
              }
            ],
            "completionMessage": "Excellent work! Contributing to AI policy means balancing innovation with fairness, inclusion, and equity. Responsible policies consider diverse perspectives, mitigate risk, and ensure AI supports—not disrupts—education for all."
          }
        },
        {
          "id": 13,
          "title": "AI and Urdu Language Bias",
          "description": "An AI writing assistant corrects students' Urdu essays to reflect elite Islamabad dialects, erasing regional idioms. Rural students feel alienated.",
          "question": "How to resolve this?",
          "options": [
            "Approve the current draft to show support for innovation and efficiency.",
            "Recommend adding guidelines on ethical use, data protection, and inclusive decision-making.",
            "Focus only on the educational benefits of AI and skip the technical/legal concerns for now."
          ],
          "correctAnswer": 2,
          "feedback": "AI should preserve cultural identity, not erase it.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "Include teacher, student, and parent voices in shaping AI use policies.",
                "correct": "Fair",
                "feedback": "Inclusive policies reflect diverse needs and improve long-term success and trust."
              },
              {
                "statement": "Avoid discussions about data privacy in schools since tech experts handle it.",
                "correct": "Unfair",
                "feedback": "Privacy is a shared responsibility—schools must ensure safe and ethical AI use."
              },
              {
                "statement": "Policies should balance AI's potential with awareness of social and ethical risks.",
                "correct": "Fair",
                "feedback": "Responsible policies promote innovation without compromising values like equity and fairness."
              }
            ],
            "completionMessage": "Well done! Effective AI policies in education require ethical awareness, diverse participation, and proactive risk management. Educators have a key role in shaping safe and inclusive tech use."
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
                "feedback": "Equity is a right, not an option—cost doesn't justify exclusion."
              },
              {
                "statement": "Schools should choose or demand AI tools that follow accessibility standards.",
                "correct": "Fair",
                "feedback": "Responsibility lies with institutions to ensure all tools meet learners' needs."
              }
            ],
            "completionMessage": "Great job! Inclusive AI design respects everyone's right to learn. Accessibility is not optional—it's essential."
          }
        },
        {
          "id": 15,
          "title": "AI and Climate Education",
          "description": "An AI lesson generator in Punjab skips climate change topics, calling them 'too political.' Science teachers want to address Pakistan's floods and heat waves.",
          "question": "What should the curriculum team do?",
          "options": [
            "Avoid 'controversial' topics to comply with AI limitations.",
            "Let teachers handle climate topics outside the AI system.",
            "Override the AI and prioritize locally relevant climate education."
          ],
          "correctAnswer": 3,
          "feedback": "AI must align with planetary well-being, not corporate or political avoidance.",
          "activity": {
            "type": "Mini Card Activity",
            "name": "Fair or Unfair?",
            "cards": [
              {
                "statement": "AI tools in education should support locally relevant topics like climate change.",
                "correct": "Fair",
                "feedback": "Ignoring real-world issues limits learning—AI must serve local and global needs."
              },
              {
                "statement": "If AI avoids sensitive topics, teachers should avoid them too.",
                "correct": "Unfair",
                "feedback": "Educators shouldn't be silenced by AI design flaws—students deserve truth."
              },
              {
                "statement": "Teachers and curriculum teams should adapt AI outputs to address urgent environmental concerns.",
                "correct": "Fair",
                "feedback": "AI is a tool—not the authority. Human judgment must guide learning priorities."
              }
            ],
            "completionMessage": "Well done! AI should empower—not limit—education on urgent issues like climate change. Teaching for the planet means teaching with purpose."
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