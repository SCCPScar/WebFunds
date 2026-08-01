import '../../domain/entities/mystery_reason.dart';

extension MysteryReasonPresentation on MysteryReason {
  String get label => switch (this) {
    MysteryReason.unknownMerchant => 'Merchant desconhecido',
    MysteryReason.unknownCategory => 'Sem categoria',
    MysteryReason.manual => 'Assinalado manualmente',
  };
}
