import '../../../../core/result/result.dart';

/// Preparation only — no implementation exists, nothing implements this,
/// nothing is wired into a Riverpod provider. When Weaver gains a real
/// LLM integration, its Infrastructure adapter (OpenAI/Claude/Gemini/
/// whatever is chosen then) implements this contract without WeaverEngine
/// or any of its consumers needing to change.
class AIRequest {
  const AIRequest({required this.prompt, this.context});

  final String prompt;

  /// Arbitrary structured context (e.g. recent Transactions, Account
  /// summaries) a real implementation would fold into its prompt.
  final Map<String, Object?>? context;
}

class AIResponse {
  const AIResponse({required this.text});

  final String text;
}

abstract class AIRepository {
  Future<Result<AIResponse>> ask(AIRequest request);
}
