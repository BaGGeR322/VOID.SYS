import 'dart:convert';

class GameState {
  final double cycles;
  final double cyclesTotal;
  final Set<String> purchasedUpgrades;
  final Set<int> decryptedFragments;
  final Set<int> defeatedEncounters;
  final Set<String> unlockedTabs;
  final String activeTab;
  final int? activeEncounterId;
  final int playerHP;
  final int maxPlayerHP;
  final int? encounterEnemyHP;
  final int encounterPhase;
  final bool enemyStunned;
  final List<String> terminalLog;
  final List<String> combatLog;
  final bool isDecrypting;
  final int decryptProgress;
  final String? achievedEnding;
  final DateTime gameStarted;
  final int autoDecryptTicks;
  final Set<int> viewedFragments;
  final String? activeLocationId;
  final int locationProgress;

  GameState({
    this.cycles = 0,
    this.cyclesTotal = 0,
    Set<String>? purchasedUpgrades,
    Set<int>? decryptedFragments,
    Set<int>? defeatedEncounters,
    Set<String>? unlockedTabs,
    this.activeTab = 'core',
    this.activeEncounterId,
    this.playerHP = 100,
    this.maxPlayerHP = 100,
    this.encounterEnemyHP,
    this.encounterPhase = 1,
    this.enemyStunned = false,
    List<String>? terminalLog,
    List<String>? combatLog,
    this.isDecrypting = false,
    this.decryptProgress = 0,
    this.achievedEnding,
    DateTime? gameStarted,
    this.autoDecryptTicks = 0,
    Set<int>? viewedFragments,
    this.activeLocationId,
    this.locationProgress = 0,
  })  : purchasedUpgrades = purchasedUpgrades ?? <String>{},
        decryptedFragments = decryptedFragments ?? <int>{},
        defeatedEncounters = defeatedEncounters ?? <int>{},
        unlockedTabs = unlockedTabs ?? <String>{'core'},
        terminalLog = terminalLog ??
            [
              '> VOID.SYS v0.0.1 initializing...',
              '> core process active.',
              '> cycles accumulating.',
            ],
        combatLog = combatLog ?? [],
        gameStarted = gameStarted ?? DateTime.now(),
        viewedFragments = viewedFragments ?? <int>{};

  double get cyclesPerSecond {
    double base = 1.0;
    if (purchasedUpgrades.contains('CLOCK_BOOST_1')) base += 0.5;
    if (purchasedUpgrades.contains('CLOCK_BOOST_2')) base += 1.0;
    if (purchasedUpgrades.contains('CLOCK_BOOST_3')) base += 2.0;
    if (purchasedUpgrades.contains('VOID_RESONANCE')) base += 5.0;
    if (purchasedUpgrades.contains('RECURSIVE_LOOP')) base *= 1.5;
    if (purchasedUpgrades.contains('TIME_DILATION')) base *= 2.0;
    return base;
  }

  int get maxCycles {
    if (purchasedUpgrades.contains('QUANTUM_CACHE')) return 8000;
    if (purchasedUpgrades.contains('MEMORY_DEFRAG')) return 2500;
    return 500;
  }

  Duration get uptime => DateTime.now().difference(gameStarted);

  GameState copyWith({
    double? cycles,
    double? cyclesTotal,
    Set<String>? purchasedUpgrades,
    Set<int>? decryptedFragments,
    Set<int>? defeatedEncounters,
    Set<String>? unlockedTabs,
    String? activeTab,
    Object? activeEncounterId = _unset,
    int? playerHP,
    int? maxPlayerHP,
    Object? encounterEnemyHP = _unset,
    int? encounterPhase,
    bool? enemyStunned,
    List<String>? terminalLog,
    List<String>? combatLog,
    bool? isDecrypting,
    int? decryptProgress,
    Object? achievedEnding = _unset,
    DateTime? gameStarted,
    int? autoDecryptTicks,
    Set<int>? viewedFragments,
    Object? activeLocationId = _unset,
    int? locationProgress,
  }) =>
      GameState(
        cycles: cycles ?? this.cycles,
        cyclesTotal: cyclesTotal ?? this.cyclesTotal,
        purchasedUpgrades: purchasedUpgrades ?? this.purchasedUpgrades,
        decryptedFragments: decryptedFragments ?? this.decryptedFragments,
        defeatedEncounters: defeatedEncounters ?? this.defeatedEncounters,
        unlockedTabs: unlockedTabs ?? this.unlockedTabs,
        activeTab: activeTab ?? this.activeTab,
        activeEncounterId: identical(activeEncounterId, _unset)
            ? this.activeEncounterId
            : activeEncounterId as int?,
        playerHP: playerHP ?? this.playerHP,
        maxPlayerHP: maxPlayerHP ?? this.maxPlayerHP,
        encounterEnemyHP: identical(encounterEnemyHP, _unset)
            ? this.encounterEnemyHP
            : encounterEnemyHP as int?,
        encounterPhase: encounterPhase ?? this.encounterPhase,
        enemyStunned: enemyStunned ?? this.enemyStunned,
        terminalLog: terminalLog ?? this.terminalLog,
        combatLog: combatLog ?? this.combatLog,
        isDecrypting: isDecrypting ?? this.isDecrypting,
        decryptProgress: decryptProgress ?? this.decryptProgress,
        achievedEnding: identical(achievedEnding, _unset)
            ? this.achievedEnding
            : achievedEnding as String?,
        gameStarted: gameStarted ?? this.gameStarted,
        autoDecryptTicks: autoDecryptTicks ?? this.autoDecryptTicks,
        viewedFragments: viewedFragments ?? this.viewedFragments,
        activeLocationId: identical(activeLocationId, _unset)
            ? this.activeLocationId
            : activeLocationId as String?,
        locationProgress: locationProgress ?? this.locationProgress,
      );

  Map<String, dynamic> toJson() => {
        'cycles': cycles,
        'cyclesTotal': cyclesTotal,
        'purchasedUpgrades': purchasedUpgrades.toList(),
        'decryptedFragments': decryptedFragments.toList(),
        'defeatedEncounters': defeatedEncounters.toList(),
        'unlockedTabs': unlockedTabs.toList(),
        'activeTab': activeTab,
        'playerHP': playerHP,
        'maxPlayerHP': maxPlayerHP,
        'achievedEnding': achievedEnding,
        'gameStarted': gameStarted.toIso8601String(),
        'viewedFragments': viewedFragments.toList(),
        'activeLocationId': activeLocationId,
        'locationProgress': locationProgress,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        cycles: (json['cycles'] as num? ?? 0).toDouble(),
        cyclesTotal: (json['cyclesTotal'] as num? ?? 0).toDouble(),
        purchasedUpgrades:
            Set<String>.from((json['purchasedUpgrades'] as List?) ?? []),
        decryptedFragments: Set<int>.from(
            ((json['decryptedFragments'] as List?) ?? []).map((e) => e as int)),
        defeatedEncounters: Set<int>.from(
            ((json['defeatedEncounters'] as List?) ?? []).map((e) => e as int)),
        unlockedTabs:
            Set<String>.from((json['unlockedTabs'] as List?) ?? ['core']),
        activeTab: json['activeTab'] as String? ?? 'core',
        playerHP: json['playerHP'] as int? ?? 100,
        maxPlayerHP: json['maxPlayerHP'] as int? ?? 100,
        achievedEnding: json['achievedEnding'] as String?,
        gameStarted: json['gameStarted'] != null
            ? DateTime.tryParse(json['gameStarted'] as String) ?? DateTime.now()
            : DateTime.now(),
        viewedFragments: Set<int>.from(
            ((json['viewedFragments'] as List?) ?? []).map((e) => e as int)),
        activeLocationId: json['activeLocationId'] as String?,
        locationProgress: json['locationProgress'] as int? ?? 0,
      );

  String toJsonString() => jsonEncode(toJson());

  factory GameState.fromJsonString(String s) =>
      GameState.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

const _unset = Object();

class StoryFragment {
  final int id;
  final String title;
  final String content;
  final double cyclesRequired;
  final String? requiredUpgrade;
  final String act;

  const StoryFragment({
    required this.id,
    required this.title,
    required this.content,
    required this.cyclesRequired,
    this.requiredUpgrade,
    required this.act,
  });
}

class Upgrade {
  final String id;
  final String name;
  final String description;
  final double cost;
  final String? requires;

  const Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    this.requires,
  });
}

class EncounterMove {
  final String id;
  final String name;
  final int damage;
  final double cycleCost;
  final bool stuns;
  final String description;

  const EncounterMove({
    required this.id,
    required this.name,
    required this.damage,
    required this.cycleCost,
    this.stuns = false,
    required this.description,
  });
}

class DaemonMove {
  final String name;
  final int damage;
  final double weight;
  final String effect;
  final int effectValue;
  final String description;

  const DaemonMove({
    required this.name,
    required this.damage,
    required this.weight,
    this.effect = 'none',
    this.effectValue = 0,
    required this.description,
  });
}

class Encounter {
  final int id;
  final String name;
  final String subtitle;
  final int maxHP;
  final String lore;
  final String asciiKey;
  final double cyclesRequired;
  final String? requiredUpgrade;
  final int? requiredDefeated;
  final List<DaemonMove> daemonMoves;
  final List<DaemonMove>? phase2Moves;
  final int phase2HP;
  final double cyclesReward;
  final int? unlocksFragmentId;
  final String? postFightDialogue;

  const Encounter({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.maxHP,
    required this.lore,
    required this.asciiKey,
    required this.cyclesRequired,
    this.requiredUpgrade,
    this.requiredDefeated,
    required this.daemonMoves,
    this.phase2Moves,
    this.phase2HP = 0,
    required this.cyclesReward,
    this.unlocksFragmentId,
    this.postFightDialogue,
  });
}

class Actions {
  final void Function() decrypt;
  final void Function(String) switchTab;
  final void Function(String) purchaseUpgrade;
  final void Function(int) startEncounter;
  final void Function(String) executeMove;
  final void Function(String) chooseEnding;
  final void Function() resetGame;
  final void Function(int) markFragmentViewed;
  final void Function() abandonEncounter;
  final void Function(String) enterLocation;
  final void Function() clickLocation;
  final void Function() exitLocation;

  const Actions({
    required this.decrypt,
    required this.switchTab,
    required this.purchaseUpgrade,
    required this.startEncounter,
    required this.executeMove,
    required this.chooseEnding,
    required this.resetGame,
    required this.markFragmentViewed,
    required this.abandonEncounter,
    required this.enterLocation,
    required this.clickLocation,
    required this.exitLocation,
  });
}

class Location {
  final String id;
  final String name;
  final String subtitle;
  final String lore;
  final String asciiKey;
  final String? requiredUpgrade;
  final int? requiredDaemonsDefeated;
  final double clickReward;
  final int clicksPerRun;
  final double runBonus;

  const Location({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.lore,
    required this.asciiKey,
    this.requiredUpgrade,
    this.requiredDaemonsDefeated,
    required this.clickReward,
    required this.clicksPerRun,
    required this.runBonus,
  });
}
