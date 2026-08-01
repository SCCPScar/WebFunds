import '../../domain/entities/dream_movement_type.dart';

extension DreamMovementTypePresentation on DreamMovementType {
  String get label => switch (this) {
    DreamMovementType.contribution => 'Contribuição',
    DreamMovementType.withdrawal => 'Retirada',
  };
}
