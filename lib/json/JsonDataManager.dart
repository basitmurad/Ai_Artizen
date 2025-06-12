import 'dart:convert';

class JsonDataManager {
  static const String moduleJsonData = '''
{
  "module": "Level 1",
  "title": "Module 1 - Human-Centered Mindset",
  "scenarios": [
    {
      "id": 1,
      "title": "AI Grading Bias",
      "description": "Ms. Ayesha notices that an AI grading tool consistently gives lower scores to students from marginalized language backgrounds. One of her students, Karim, receives a low grade despite writing a thoughtful essay. The principal insists that the tool is helpful.",
      "options": [
        "Accept the tool but manually adjust grades for marginalized students.",
        "Reject the tool and grade essays yourself, despite the extra time.",
        "Advocate for a hybrid system (AI drafts + teacher reviews)."
      ],
      "correctAnswer": 3,
      "activity": {
        "type": "Mini Card Activity",
        "name": "Fair or Unfair?",
        "cards": [
          {
            "statement": "A teacher raises Karim's grade because the AI tool graded him unfairly.",
            "correct": "Fair",
            "feedback": "Raising a student's grade to correct an AI error shows human judgment and fairness."
          },
          {
            "statement": "The school updates the AI tool to reduce language bias.",
            "correct": "Fair",
            "feedback": "Updating the AI tool to reduce language bias is a proactive way to ensure inclusivity."
          },
          {
            "statement": "A teacher changes grades quietly without informing students or admins.",
            "correct": "Unfair",
            "feedback": "Making changes quietly removes transparency and trust."
          }
        ]
      }
    },
    {
      "id": 2,
      "title": "Biased Behavior Prediction",
      "description": "Kamal is building a student behavior prediction system with data from 10 elite private schools. The AI flags rural students more often as 'at-risk.'",
      "options": [
        "The AI is working correctly",
        "The data lacks rural representation",
        "The system should ignore location",
        "Behavior data cannot be analyzed by AI"
      ],
      "correctAnswer": 2,
      "activity": {
        "type": "Mini Card Activity",
        "name": "Data or Bias?",
        "cards": [
          {
            "statement": "AI flags rural students as 'at-risk' more than urban students, based on elite school data.",
            "correct": "Biased Outcome",
            "feedback": "This reflects biased data — rural students are unfairly flagged."
          },
          {
            "statement": "AI tool penalizes students who use local dialects in essays.",
            "correct": "Biased Outcome",
            "feedback": "Penalizing local dialects is unfair. AI should respect linguistic and cultural diversity."
          },
          {
            "statement": "AI recommends extra support for students with inconsistent attendance.",
            "correct": "Valid Pattern",
            "feedback": "Inconsistent attendance is a fair indicator when used with human judgment."
          }
        ]
      }
    },
    {
      "id": 3,
      "title": "AI Career Suggestions",
      "description": "A school uses an AI chatbot to suggest career paths. Students begin to follow it without exploring other options. Teachers notice a lack of personal reflection.",
      "options": [
        "Decision-making and personal reflection",
        "Access to online tools",
        "Student discipline",
        "Focus on short-term goals"
      ],
      "correctAnswer": 1,
      "activity": {
        "type": "Mini Card Activity",
        "name": "Hamza's Choice",
        "cards": [
          {
            "statement": "Hamza dreams of being a journalist. The AI suggests accounting. He quietly gives up his dream and changes his plan.",
            "correct": "Follow AI because it knows trends",
            "feedback": "Important life decisions need personal reflection and guidance."
          },
          {
            "statement": "Talk to a teacher and reflect on both options",
            "correct": "Talk to a teacher and reflect on both options",
            "feedback": "This is the best approach - combining AI insights with human guidance and personal reflection."
          },
          {
            "statement": "Ask the AI to update its suggestions",
            "correct": "Let friends vote for him",
            "feedback": "Important decisions shouldn't be left to others without personal reflection."
          }
        ]
      }
    },
    {
      "id": 4,
      "title": "Too Smart to Choose?",
      "description": "Ms. Nida uses an AI app that skips topics students might struggle with. Students feel limited and frustrated.",
      "options": [
        "Keep using the app because it improves test scores",
        "Let students opt out and design their own learning paths",
        "Modify the app to allow student input (e.g., personal goals, topic choices)"
      ],
      "correctAnswer": 3,
      "activity": {
        "type": "Mini Card Activity",
        "name": "Who Should Decide?",
        "cards": [
          {
            "statement": "The AI app should decide what a student learns next because it's based on data.",
            "correct": "Unfair",
            "feedback": "Students need agency in their learning journey."
          },
          {
            "statement": "A mix of AI, teacher, and student input should guide learning decisions.",
            "correct": "Fair",
            "feedback": "All voices matter in shaping learning - this protects student dignity and choice."
          },
          {
            "statement": "Students should have no say in their learning path if AI can optimize it.",
            "correct": "Unfair",
            "feedback": "This removes student agency and personal growth opportunities."
          }
        ]
      }
    },
    {
      "id": 5,
      "title": "Watching to Teach?",
      "description": "An AI surveillance tool flags students as 'distracted.' While focus improves, parents are concerned about mental well-being and trust.",
      "options": [
        "Enable the tool fully because it improves classroom discipline",
        "Disable the tool and rely on teacher observations and student trust",
        "Limit the tool's use to specific contexts (e.g., during high-stakes exams)"
      ],
      "correctAnswer": 3,
      "activity": {
        "type": "Mini Card Activity",
        "name": "Where's the Line?",
        "cards": [
          {
            "statement": "Monitor students with AI tools always because safety comes first.",
            "correct": "Unfair",
            "feedback": "Constant monitoring violates trust and student dignity."
          },
          {
            "statement": "Use AI monitoring only with student and parent consent for specific contexts.",
            "correct": "Fair",
            "feedback": "Consent and context are key to responsible monitoring that respects human dignity."
          },
          {
            "statement": "Never use AI monitoring tools as they always violate trust.",
            "correct": "Unfair",
            "feedback": "Some contexts may warrant monitoring, but transparency and consent are essential."
          }
        ]
      }
    }
  ]
}
  ''';

  static Map<String, dynamic> getModuleData() {
    return json.decode(moduleJsonData);
  }

  static List<dynamic> getScenarios() {
    final moduleData = getModuleData();
    return moduleData['scenarios'] ?? [];
  }

  static String getModuleTitle() {
    final moduleData = getModuleData();
    return moduleData['title'] ?? 'Module 1 - Human-Centered Mindset';
  }

  static String getModuleName() {
    final moduleData = getModuleData();
    return moduleData['module'] ?? 'Level 1';
  }
}