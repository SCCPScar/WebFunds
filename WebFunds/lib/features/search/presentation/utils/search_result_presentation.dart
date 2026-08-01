import 'package:flutter/widgets.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../domain/entities/search_result_type.dart';

extension SearchResultTypePresentation on SearchResultType {
  String get groupLabel => switch (this) {
        SearchResultType.transaction => 'Transações',
        SearchResultType.dream => 'Objetivos',
        SearchResultType.mystery => 'Mistérios',
        SearchResultType.subscription => 'Subscrições',
      };

  IconData get icon => switch (this) {
        SearchResultType.transaction => AppIcons.finances,
        SearchResultType.dream => AppIcons.dreams,
        SearchResultType.mystery => AppIcons.mysteries,
        SearchResultType.subscription => AppIcons.subscriptions,
      };
}
