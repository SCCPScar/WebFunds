import '../../domain/entities/memory_mood.dart';

extension MemoryMoodPresentation on MemoryMood {
  String get label => switch (this) {
    MemoryMood.happy => 'Feliz',
    MemoryMood.excited => 'Entusiasmado',
    MemoryMood.proud => 'Orgulhoso',
    MemoryMood.relaxed => 'Relaxado',
    MemoryMood.neutral => 'Neutro',
    MemoryMood.unexpected => 'Inesperado',
    MemoryMood.stressful => 'Stressante',
  };
}
