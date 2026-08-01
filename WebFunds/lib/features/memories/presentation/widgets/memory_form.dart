import 'package:flutter/material.dart';

import '../../../../design_system/spacing/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/memory.dart';
import '../../domain/entities/memory_mood.dart';
import '../utils/memory_mood_presentation.dart';

class MemoryForm extends StatefulWidget {
  const MemoryForm({
    super.key,
    required this.existing,
    required this.onSubmit,
    required this.isLoading,
  });

  final Memory? existing;
  final void Function(String? title, String? narrative, MemoryMood? mood, List<String> tags)
      onSubmit;
  final bool isLoading;

  @override
  State<MemoryForm> createState() => _MemoryFormState();
}

class _MemoryFormState extends State<MemoryForm> {
  late final _titleController = TextEditingController(text: widget.existing?.title);
  late final _narrativeController = TextEditingController(text: widget.existing?.narrative);
  late final _tagsController = TextEditingController(text: widget.existing?.tags.join(', '));
  MemoryMood? _mood;

  @override
  void initState() {
    super.initState();
    _mood = widget.existing?.mood;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _narrativeController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _submit() {
    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
    widget.onSubmit(_titleController.text, _narrativeController.text, _mood, tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Memória', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: 'Título (opcional)', controller: _titleController),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'O que aconteceu? (opcional)',
          controller: _narrativeController,
          maxLines: 4,
        ),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<MemoryMood?>(
          initialValue: _mood,
          decoration: const InputDecoration(labelText: 'Estado de espírito (opcional)'),
          items: [
            const DropdownMenuItem(child: Text('Nenhum')),
            for (final mood in MemoryMood.values)
              DropdownMenuItem(value: mood, child: Text(mood.label)),
          ],
          onChanged: (value) => setState(() => _mood = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(label: 'Tags (separadas por vírgula, opcional)', controller: _tagsController),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton(
          onPressed: widget.isLoading ? null : _submit,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Guardar memória'),
        ),
      ],
    );
  }
}
