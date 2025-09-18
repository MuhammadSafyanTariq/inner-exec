import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:innerexec/core/services/openai_service.dart';

class AiResumePreviewScreen extends StatefulWidget {
  final String resumeText;
  final String jobDescription;
  final String? style;

  const AiResumePreviewScreen({
    super.key,
    required this.resumeText,
    required this.jobDescription,
    this.style,
  });

  @override
  State<AiResumePreviewScreen> createState() => _AiResumePreviewScreenState();
}

class _AiResumePreviewScreenState extends State<AiResumePreviewScreen> {
  late String _currentResume;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _currentResume = widget.resumeText;
  }

  Future<void> _regenerate() async {
    setState(() => _loading = true);
    try {
      final regenerated = await OpenAiService.generateResume(
        _currentResume,
        widget.jobDescription,
        widget.style ?? 'Professional',
      );
      setState(() => _currentResume = regenerated);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Text(
            _currentResume,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'AI_Resume.pdf');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('AI Resume & Cover Letter'),
      centerTitle: true,
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _currentResume,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _regenerate,
                    child: const Text('Regenerate'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _downloadPdf,
                    child: const Text('Download PDF'),
                  ),
                ),
              ],
            ),
          ),
  );
}
