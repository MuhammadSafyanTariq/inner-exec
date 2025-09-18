import 'package:flutter/material.dart';
import 'package:innerexec/presentation/screens/resume/ai_resume_screen.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Ask Ai',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _AskBar(),
            const SizedBox(height: 32),
            _AssistantHero(),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Suggestions',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF333333),
                  ),
                ),
                Icon(Icons.refresh, size: 18, color: Color(0xFF777777)),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _SuggestionCard(
                      title: 'AI CV & Cover Letters',
                      subtitle: 'Instant, professional documents.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AiResumeScreen(),
                          ),
                        );
                      },
                    ),
                    const _SuggestionCard(
                      title: 'AI-Generated Classes',
                      subtitle: 'On-demand career lessons.',
                    ),
                    const _SuggestionCard(
                      title: 'Affirmations',
                      subtitle: 'Daily inspiration.',
                    ),
                    const _SuggestionCard(
                      title: 'Business Tips',
                      subtitle: 'Quick, actionable advice.',
                    ),
                    const _SuggestionCard(
                      title: 'AI Mails / Follow-Ups',
                      subtitle: 'Smart, ready-to-send emails.',
                    ),
                    const _SuggestionCard(
                      title: 'Interview Q&A',
                      subtitle: 'Practice with realistic prompts.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

class _AskBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E1E1)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Row(
      children: [
        const Expanded(
          child: Text(
            'Ask Anything....',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF777777),
            ),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF8A2BE2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
        ),
      ],
    ),
  );
}

class _AssistantHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    children: const [
      SizedBox(height: 10),
      Icon(Icons.smart_toy_rounded, size: 72, color: Color(0xFF8A2BE2)),
      SizedBox(height: 18),
      Text(
        'How can i Assist you Today?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Color(0xFF000000),
        ),
      ),
      SizedBox(height: 6),
      Text(
        'Tap below suggestions or write your own query.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: Color(0xFF777777),
        ),
      ),
    ],
  );
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: (MediaQuery.of(context).size.width - 20 - 20 - 12) / 2,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E1E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: Color(0xFF777777),
              height: 1.3,
            ),
          ),
        ],
      ),
    ),
  );
}
