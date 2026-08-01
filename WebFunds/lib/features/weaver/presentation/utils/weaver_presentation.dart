import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../domain/entities/weaver_action.dart';
import '../../domain/entities/weaver_alert.dart';
import '../../domain/entities/weaver_insight.dart';
import '../../domain/entities/weaver_recommendation.dart';

extension WeaverInsightTypePresentation on WeaverInsightType {
  IconData get icon => switch (this) {
        WeaverInsightType.totalNetWorth => AppIcons.weaverNetWorth,
        WeaverInsightType.largestAccount => AppIcons.accountSavings,
        WeaverInsightType.lowestBalance => AppIcons.weaverWarning,
        WeaverInsightType.accountCount => AppIcons.finances,
        WeaverInsightType.dormantAccounts => AppIcons.weaverDormant,
        WeaverInsightType.typeDistribution => AppIcons.weaverDistribution,
      };
}

extension WeaverRecommendationTypePresentation on WeaverRecommendationType {
  IconData get icon => switch (this) {
        WeaverRecommendationType.dormantAccounts => AppIcons.weaverDormant,
        WeaverRecommendationType.noTransactionsYet => AppIcons.weaverInsight,
        WeaverRecommendationType.singleAccountConcentration => AppIcons.weaverWarning,
      };
}

extension WeaverAlertSeverityPresentation on WeaverAlertSeverity {
  IconData get icon => switch (this) {
        WeaverAlertSeverity.info => AppIcons.weaverInfo,
        WeaverAlertSeverity.warning => AppIcons.weaverWarning,
        WeaverAlertSeverity.critical => AppIcons.weaverWarning,
      };
}

extension WeaverActionTypePresentation on WeaverActionType {
  IconData get icon => switch (this) {
        WeaverActionType.analyzeFinances => AppIcons.weaverInsight,
        WeaverActionType.createBudget => AppIcons.weaverBudget,
        WeaverActionType.setGoal => AppIcons.dreams,
        WeaverActionType.reviewExpenses => AppIcons.finances,
        WeaverActionType.monthlyPlanning => AppIcons.weaverPlanning,
        WeaverActionType.netWorth => AppIcons.weaverNetWorth,
        WeaverActionType.forecasts => AppIcons.weaverForecast,
        WeaverActionType.upcomingBills => AppIcons.weaverBills,
      };
}
