import 'package:dart_openai/dart_openai.dart';

class OpenAiService {
  OpenAiService._();

  static void init() {
    // TODO: Replace with secure key management.
    // For now, you can set your API key here or use environment variables
    const String apiKey = String.fromEnvironment(
      'OPENAI_API_KEY',
      defaultValue: 'YOUR_API_KEY',
    );
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
    final response = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.system,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "You are an AI resume builder that tailors resumes to job descriptions.",
            ),
          ],
        ),
        OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Style: $style\n\nResume draft:\n$resume\n\nJob description:\n$jobDescription",
            ),
          ],
        ),
      ],
    );
    return response.choices.first.message.content?.first.text ?? "";
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
