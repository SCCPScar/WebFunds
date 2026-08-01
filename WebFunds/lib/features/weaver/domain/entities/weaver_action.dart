/// The 8 quick-action cards Weaver's main page offers. Not generated
/// from data — a fixed catalogue, same idea as `appShellDestinations`.
/// What each one *does* when tapped (navigate to a real screen, or show
/// an honest "em breve" for the ones with no feature behind them yet:
/// Budget and Monthly Planning don't exist anywhere in this app,
/// Forecasts needs Weaver's future prediction model) lives in the
/// Presentation layer, not here.
enum WeaverActionType {
  analyzeFinances,
  createBudget,
  setGoal,
  reviewExpenses,
  monthlyPlanning,
  netWorth,
  forecasts,
  upcomingBills,
}

class WeaverAction {
  const WeaverAction({required this.type, required this.title, required this.description});

  final WeaverActionType type;
  final String title;
  final String description;

  static const List<WeaverAction> all = [
    WeaverAction(
      type: WeaverActionType.analyzeFinances,
      title: 'Analisar finanças',
      description: 'Vê os insights que o Weaver já preparou para ti.',
    ),
    WeaverAction(
      type: WeaverActionType.createBudget,
      title: 'Criar orçamento',
      description: 'Ainda não disponível.',
    ),
    WeaverAction(
      type: WeaverActionType.setGoal,
      title: 'Definir meta',
      description: 'Cria um novo objetivo de poupança.',
    ),
    WeaverAction(
      type: WeaverActionType.reviewExpenses,
      title: 'Rever gastos',
      description: 'Abre as tuas transações.',
    ),
    WeaverAction(
      type: WeaverActionType.monthlyPlanning,
      title: 'Planeamento mensal',
      description: 'Ainda não disponível.',
    ),
    WeaverAction(
      type: WeaverActionType.netWorth,
      title: 'Património',
      description: 'Vê as tuas contas e saldos.',
    ),
    WeaverAction(
      type: WeaverActionType.forecasts,
      title: 'Previsões',
      description: 'Ainda não disponível.',
    ),
    WeaverAction(
      type: WeaverActionType.upcomingBills,
      title: 'Próximas contas',
      description: 'Vê as tuas subscrições.',
    ),
  ];
}
