import 'package:flutter/widgets.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../domain/entities/notification_category.dart';

extension NotificationCategoryPresentation on NotificationCategory {
  String get label => switch (this) {
        NotificationCategory.financialCycle => 'Ciclo Financeiro',
        NotificationCategory.mystery => 'Mistério',
        NotificationCategory.dream => 'Objetivo',
        NotificationCategory.subscription => 'Subscrição',
        NotificationCategory.system => 'Sistema',
      };

  IconData get icon => switch (this) {
        NotificationCategory.financialCycle => AppIcons.activity,
        NotificationCategory.mystery => AppIcons.mysteries,
        NotificationCategory.dream => AppIcons.dreams,
        NotificationCategory.subscription => AppIcons.subscriptions,
        NotificationCategory.system => AppIcons.notifications,
      };
}
