import 'package:dart_openai/dart_openai.dart';
import 'dart:convert';

class OpenAiService {
  OpenAiService._();

  static void init() {
    // Read OpenAI API key from compile-time env without any in-repo default.
    const String apiKey = String.fromEnvironment('OPENAI_API_KEY');
    if (apiKey.isEmpty) {
      throw StateError(
        'Missing OPENAI_API_KEY. Pass it via --dart-define=OPENAI_API_KEY=xxxx',
      );
    }
    OpenAI.apiKey = apiKey;
  }

  static void setApiKey(String key) {
    OpenAI.apiKey = key;
  }

  static Future<String> generateResume(
    String resume,
    String jobDescription,
    String style,
  ) async {
    // Build a prompt that works with or without a job description
    final bool hasJD = jobDescription.trim().isNotEmpty;
    final String userPrompt = hasJD
        ? "Style: $style\n\nUsing the candidate details below, write a complete, polished one-page resume tailored to this job description.\n\nCandidate details:\n$resume\n\nJob description:\n$jobDescription\n\nReturn only the resume text."
        : "Style: $style\n\nUsing the candidate details below, write a complete, polished one-page resume suitable for general applications. Optimize for clarity and ATS.\n\nCandidate details:\n$resume\n\nReturn only the resume text.";

    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are an AI resume builder. Produce concise, well-structured resume content with sections like Summary, Skills, Experience, and Education.",
            ),
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(userPrompt),
          ],
        ),
      ],
    );
    return response.choices.first.message.content?.first.text ?? "";
  }

  // New: Always return structured JSON for resume
  static Future<Map<String, dynamic>> generateStructuredResume(
    String resume,
    String jobDescription,
    String style,
  ) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are a resume builder. Always return a JSON object, never plain text. Use ONLY ASCII characters (no emojis, no smart quotes, no unusual symbols).",
            ),
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text("""
Build a professional resume in this strict JSON format:
{
  "summary": "...",
  "skills": ["skill1", "skill2"],
  "certifications": ["cert1", "cert2"],
  "education": [
    {"degree": "...", "institute": "...", "year": "..."}
  ],
  "experience": [
    {"title": "...", "company": "...", "date": "...", "responsibilities": ["...", "..."]}
  ]
}

Constraints:
- Use ONLY standard ASCII characters 32-126. Replace any bullets with a hyphen (-).
- Do NOT include markdown or emojis in any field.

User resume draft:
$resume

Job description:
$jobDescription

Style: $style
"""),
          ],
        ),
      ],
    );

    final content = response.choices.first.message.content?.first.text ?? "{}";
    try {
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      // If model ignored format, return empty map to trigger fallback
      return <String, dynamic>{};
    }
  }

  static Future<String> generateCoverLetter(
    String resume,
    String jobDescription,
    String style,
  ) async {
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are an AI career assistant that writes tailored cover letters.",
            ),
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Style: $style\n\nResume:\n$resume\n\nJob description:\n$jobDescription",
            ),
          ],
        ),
      ],
    );
    return response.choices.first.message.content?.first.text ?? "";
  }
}
