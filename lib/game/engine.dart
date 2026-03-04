import 'dart:math';

import 'data.dart';
import 'models.dart';

class GameEngine {
  static const _ticksForAutoDecrypt = 600;
  static const moduleCosts = <String, int>{
    'BULWARK_FRAME': 2500,
    'THROUGHPUT_CORE': 6000,
    'HARMONIC_BUFFER': 9000,
  };

  static GameState tick(GameState state) {
    if (state.achievedEnding != null) return state;

    const dt = 0.1;
    final gained = state.cyclesPerSecond * dt;
    final rawCycles = state.cycles + gained;
    final cappedCycles = rawCycles.clamp(0.0, state.maxCycles.toDouble());
    final overflow = rawCycles - cappedCycles;
    final shardGain = overflow > 0 ? (overflow / 10).floor() : 0;
    final newTotal = state.cyclesTotal + gained;

    var s = state.copyWith(
      cycles: cappedCycles,
      cyclesTotal: newTotal,
      shards: state.shards + shardGain,
    );

    s = _tickDecrypt(s);
    s = _tickAutoDecrypt(s);
    s = checkUnlocks(s);

    return s;
  }

  static GameState _tickDecrypt(GameState state) {
    if (!state.isDecrypting) return state;
    final newProgress = state.decryptProgress + 1;
    if (newProgress < 100) {
      return state.copyWith(decryptProgress: newProgress);
    }
    final next = _nextDecryptable(state);
    if (next == null) {
      return state.copyWith(isDecrypting: false, decryptProgress: 0);
    }
    final newDecrypted = {...state.decryptedFragments, next.id};
    final newLog = _addLog(state.terminalLog, '> FRAGMENT DECRYPTED: ${next.title}');
    return state.copyWith(
      isDecrypting: false,
      decryptProgress: 0,
      decryptedFragments: newDecrypted,
      terminalLog: newLog,
    );
  }

  static GameState _tickAutoDecrypt(GameState state) {
    if (!state.purchasedUpgrades.contains('NEURAL_BRIDGE')) return state;
    if (state.isDecrypting) return state;

    final newTicks = state.autoDecryptTicks + 1;
    if (newTicks < _ticksForAutoDecrypt) {
      return state.copyWith(autoDecryptTicks: newTicks);
    }
    final next = _nextDecryptable(state);
    if (next == null) return state.copyWith(autoDecryptTicks: 0);

    final newDecrypted = {...state.decryptedFragments, next.id};
    final newLog = _addLog(state.terminalLog, '> AUTO-DECRYPT: ${next.title}');
    return state.copyWith(
      autoDecryptTicks: 0,
      decryptedFragments: newDecrypted,
      terminalLog: newLog,
    );
  }

  static GameState checkUnlocks(GameState state) {
    final tabs = <String>{...state.unlockedTabs};
    final log = [...state.terminalLog];
    bool changed = false;

    if (state.cyclesTotal >= 50 && !tabs.contains('memory')) {
      tabs.add('memory');
      log.add('> NEW TAB UNLOCKED: MEMORY');
      changed = true;
    }
    if (state.cyclesTotal >= 350 && !tabs.contains('system')) {
      tabs.add('system');
      log.add('> NEW TAB UNLOCKED: SYSTEM');
      changed = true;
    }
    if (state.purchasedUpgrades.contains('MEMORY_DEFRAG') && !tabs.contains('explore')) {
      tabs.add('explore');
      log.add('> NEW TAB UNLOCKED: EXPLORE');
      changed = true;
    }
    if (state.purchasedUpgrades.contains('PROTOCOL_OVERRIDE') && !tabs.contains('daemon')) {
      tabs.add('daemon');
      log.add('> NEW TAB UNLOCKED: DAEMON');
      changed = true;
    }
    if (state.purchasedUpgrades.contains('SINGULARITY') &&
        state.defeatedEncounters.contains(4) &&
        !tabs.contains('void')) {
      tabs.add('void');
      log.add('> NEW TAB UNLOCKED: VOID');
      changed = true;
    }
    if (!changed) return state;
    return state.copyWith(unlockedTabs: tabs, terminalLog: _trim(log));
  }

  static bool isLocationAvailable(GameState state, String locationId) {
    final loc = GameData.locationById(locationId);
    if (loc == null) return false;
    if (loc.requiredUpgrade != null && !state.purchasedUpgrades.contains(loc.requiredUpgrade!)) {
      return false;
    }
    if (loc.requiredDaemonsDefeated != null && state.defeatedEncounters.length < loc.requiredDaemonsDefeated!) {
      return false;
    }
    return true;
  }

  static GameState enterLocation(GameState state, String locationId) {
    final loc = GameData.locationById(locationId);
    if (loc == null) return state;
    if (!isLocationAvailable(state, locationId)) return state;
    final log = _addLog(state.terminalLog, '> ENTERING: ${loc.name}');
    return state.copyWith(
      activeLocationId: locationId,
      locationProgress: 0,
      locationRisk: 0,
      locationStability: 100,
      locationMode: 'scan',
      terminalLog: log,
    );
  }

  static GameState runLocationAction(GameState state, String action) {
    if (state.activeLocationId == null) return state;
    final loc = GameData.locationById(state.activeLocationId!);
    if (loc == null) return state;
    final actionMap = <String, ({double reward, int progress, int risk, int stability})>{
      'scan': (reward: loc.clickReward, progress: 1, risk: 3, stability: -1),
      'probe': (reward: loc.clickReward * 1.8, progress: 2, risk: 8, stability: -4),
      'stabilize': (reward: loc.clickReward * 0.2, progress: 0, risk: -10, stability: 8),
      'extract': (reward: loc.clickReward * 2.5, progress: 3, risk: 15, stability: -8),
    };
    final selected = actionMap[action] ?? actionMap['scan']!;
    final risk = (state.locationRisk + selected.risk).clamp(0, 100);
    final stability = (state.locationStability + selected.stability).clamp(0, 100);
    var progress = state.locationProgress + selected.progress;
    final reward = selected.reward * (1 + state.playerLevel * 0.05);
    final cyclesAfter = (state.cycles + reward).clamp(0.0, state.maxCycles.toDouble());
    var total = state.cyclesTotal + reward;
    var shards = state.shards;
    var consumables = <String, int>{...state.consumables};
    var log = state.terminalLog;

    if (risk >= 85) {
      final penalty = (loc.runBonus * 0.4).clamp(0.0, state.cycles);
      log = _addLog(log, '> SECTOR COLLAPSE: ${loc.name} (-${penalty.toStringAsFixed(0)} cycles)');
      return state.copyWith(
        cycles: (cyclesAfter - penalty).clamp(0.0, state.maxCycles.toDouble()),
        cyclesTotal: total,
        locationProgress: 0,
        locationRisk: 20,
        locationStability: 80,
        terminalLog: log,
      );
    }

    if (progress >= loc.clicksPerRun) {
      final bonus = (loc.runBonus * (1 + state.playerLevel * 0.05)).toDouble();
      final withBonus = (cyclesAfter + bonus).clamp(0.0, state.maxCycles.toDouble());
      final overflow = (cyclesAfter + bonus) - withBonus;
      if (overflow > 0) {
        shards += (overflow / 8).floor();
      }
      final loot = risk > 60 ? 'shield_pulse' : 'med_patch';
      consumables[loot] = (consumables[loot] ?? 0) + 1;
      total += bonus;
      log = _addLog(log, '> RUN COMPLETE: ${loc.name} (+${bonus.toStringAsFixed(0)}, +1 $loot)');
      progress = 0;
    }

    return state.copyWith(
      cycles: cyclesAfter,
      cyclesTotal: total,
      locationProgress: progress,
      locationRisk: risk,
      locationStability: stability,
      locationMode: action,
      shards: shards,
      consumables: consumables,
      terminalLog: log,
    );
  }

  static GameState exitLocation(GameState state) {
    return state.copyWith(
      activeLocationId: null,
      locationProgress: 0,
      locationRisk: 0,
      locationStability: 100,
      locationMode: 'scan',
      terminalLog: _addLog(state.terminalLog, '> EXITING LOCATION'),
    );
  }

  static GameState buyModule(GameState state, String moduleId) {
    if (state.installedModules.contains(moduleId)) return state;
    final cost = moduleCosts[moduleId];
    if (cost == null) return state;
    final canUseCycles = state.cycles >= cost;
    final canUseShards = state.shards >= (cost / 4).ceil();
    if (!canUseCycles && !canUseShards) return state;
    final newModules = <String>{...state.installedModules, moduleId};
    final spentCycles = canUseCycles ? cost.toDouble() : 0.0;
    final spentShards = canUseCycles ? 0 : (cost / 4).ceil();
    return state.copyWith(
      installedModules: newModules,
      cycles: (state.cycles - spentCycles).clamp(0.0, state.maxCycles.toDouble()),
      shards: state.shards - spentShards,
      armor: state.armor + (moduleId == 'BULWARK_FRAME' ? 6 : 0),
      playerLevel: state.playerLevel + (moduleId == 'THROUGHPUT_CORE' ? 1 : 0),
      terminalLog: _addLog(state.terminalLog, '> MODULE INSTALLED: $moduleId'),
    );
  }

  static GameState useConsumable(GameState state, String item) {
    final amount = state.consumables[item] ?? 0;
    if (amount <= 0) return state;
    final next = <String, int>{...state.consumables, item: amount - 1};
    if (item == 'med_patch') {
      return state.copyWith(
        playerHP: (state.playerHP + 35).clamp(0, state.maxPlayerHP),
        consumables: next,
        combatLog: [...state.combatLog, '> YOU: MED PATCH (+35 HP)'],
      );
    }
    if (item == 'overclock_cell') {
      return state.copyWith(
        cycles: (state.cycles + 120).clamp(0.0, state.maxCycles.toDouble()),
        consumables: next,
        combatLog: [...state.combatLog, '> YOU: OVERCLOCK CELL (+120 cycles)'],
      );
    }
    if (item == 'shield_pulse') {
      return state.copyWith(
        armor: state.armor + 2,
        consumables: next,
        combatLog: [...state.combatLog, '> YOU: SHIELD PULSE (+2 armor)'],
      );
    }
    if (item == 'focus_injector') {
      return state.copyWith(
        enemyStunned: true,
        consumables: next,
        combatLog: [...state.combatLog, '> YOU: FOCUS INJECTOR (stun)'],
      );
    }
    if (item == 'purge_script' && state.activeEncounterId != null) {
      final hp = (state.encounterEnemyHP ?? 0) - 60;
      if (hp <= 0) {
        final encounter = GameData.encounterById(state.activeEncounterId!);
        if (encounter != null) {
          return _resolveVictory(
            state.copyWith(
              encounterEnemyHP: 0,
              consumables: next,
              combatLog: [...state.combatLog, '> YOU: PURGE SCRIPT (60 damage)'],
            ),
            encounter,
          );
        }
      }
      return state.copyWith(
        encounterEnemyHP: hp,
        consumables: next,
        combatLog: [...state.combatLog, '> YOU: PURGE SCRIPT (60 damage)'],
      );
    }
    return state.copyWith(consumables: next);
  }

  static GameState startDecrypt(GameState state) {
    if (state.isDecrypting) return state;
    if (_nextDecryptable(state) == null) return state;
    return state.copyWith(isDecrypting: true, decryptProgress: 0);
  }

  static bool canDecrypt(GameState state) => !state.isDecrypting && _nextDecryptable(state) != null;

  static StoryFragment? _nextDecryptable(GameState state) {
    try {
      return GameData.fragments.firstWhere(
        (f) =>
            !state.decryptedFragments.contains(f.id) &&
            state.cyclesTotal >= f.cyclesRequired &&
            (f.requiredUpgrade == null || state.purchasedUpgrades.contains(f.requiredUpgrade!)),
      );
    } catch (_) {
      return null;
    }
  }

  static GameState purchaseUpgrade(GameState state, String upgradeId) {
    final upgrade = GameData.upgradeById(upgradeId);
    if (upgrade == null) return state;
    if (state.purchasedUpgrades.contains(upgradeId)) return state;
    if (state.cycles < upgrade.cost) return state;
    if (upgrade.requires != null && !state.purchasedUpgrades.contains(upgrade.requires!)) {
      return state;
    }

    final purchased = <String>{...state.purchasedUpgrades, upgradeId};
    final log = _addLog(state.terminalLog, '> INSTALLED: ${upgrade.name}');
    var s = state.copyWith(
      cycles: state.cycles - upgrade.cost,
      purchasedUpgrades: purchased,
      terminalLog: log,
    );
    return checkUnlocks(s);
  }

  static bool canPurchase(GameState state, String upgradeId) {
    final upgrade = GameData.upgradeById(upgradeId);
    if (upgrade == null) return false;
    if (state.purchasedUpgrades.contains(upgradeId)) return false;
    if (state.cycles < upgrade.cost) return false;
    if (upgrade.requires != null && !state.purchasedUpgrades.contains(upgrade.requires!)) {
      return false;
    }
    return true;
  }

  static bool isEncounterAvailable(GameState state, int encounterId) {
    final enc = GameData.encounterById(encounterId);
    if (enc == null) return false;
    if (state.cyclesTotal < enc.cyclesRequired) return false;
    if (enc.requiredUpgrade != null && !state.purchasedUpgrades.contains(enc.requiredUpgrade!)) {
      return false;
    }
    if (enc.requiredDefeated != null && !state.defeatedEncounters.contains(enc.requiredDefeated!)) {
      return false;
    }
    return true;
  }

  static GameState startEncounter(GameState state, int encounterId) {
    final enc = GameData.encounterById(encounterId);
    if (enc == null) return state;
    if (!isEncounterAvailable(state, encounterId)) return state;

    final rank = state.bossRanks[encounterId] ?? 0;
    final scaledHp = (enc.maxHP * (1 + rank * 0.35)).round();
    final log = _addLog(state.terminalLog, '> DAEMON CONTACT: ${enc.name}');
    return state.copyWith(
      activeEncounterId: encounterId,
      encounterEnemyHP: scaledHp,
      encounterPhase: 1,
      enemyStunned: false,
      playerHP: state.maxPlayerHP,
      combatLog: [
        '> INITIATING CONTACT: ${enc.name.toUpperCase()} [RANK $rank]',
        '> ${enc.lore}',
        '> ---',
      ],
      terminalLog: log,
    );
  }

  static GameState executeMove(GameState state, String moveId,
      {bool precision = false}) {
    if (state.activeEncounterId == null) return state;
    final enc = GameData.encounterById(state.activeEncounterId!)!;
    final EncounterMove move;
    try {
      move = GameData.playerMoves.firstWhere((m) => m.id == moveId);
    } catch (_) {
      return state;
    }

    final double cycleCost =
        precision ? (move.cycleCost * 1.5) : move.cycleCost;
    if (state.cycles < cycleCost) return state;

    final rng = Random();
    var clog = [...state.combatLog];

    final bool precisionHit = !precision || rng.nextDouble() > 0.35;
    final int baseDamage = precision ? (move.damage * 2) : move.damage;
    final int actualDamage = precisionHit ? baseDamage : 0;

    if (precision && !precisionHit) {
      clog.add('> YOU: ${move.name} [PRECISION] — MISSED');
    } else if (precision) {
      clog.add('> YOU: ${move.name} [PRECISION] — $actualDamage damage (x2)');
    } else {
      clog.add('> YOU: ${move.name} — $actualDamage damage');
    }

    final rank = state.bossRanks[state.activeEncounterId!] ?? 0;
    final effectiveDamage = (actualDamage * (1 + state.playerLevel * 0.03)).round();
    int enemyHP = state.encounterEnemyHP! - effectiveDamage;

    if (enemyHP <= 0) {
      clog.add('> ${enc.name.toUpperCase()}: silenced.');
      return _resolveVictory(
        state.copyWith(
          cycles: state.cycles - cycleCost,
          encounterEnemyHP: 0,
          combatLog: clog,
        ),
        enc,
      );
    }

    int phase = state.encounterPhase;
    if (enc.phase2HP > 0 && enemyHP <= enc.phase2HP && phase == 1) {
      phase = 2;
      clog.add('> WARNING: ${enc.name} entering phase 2');
    }

    if (state.enemyStunned) {
      clog.add('> ${enc.name}: [STUNNED — skips turn]');
      return state.copyWith(
        cycles: state.cycles - cycleCost,
        encounterEnemyHP: enemyHP,
        encounterPhase: phase,
        enemyStunned: false,
        combatLog: clog,
      );
    }

    final moves = (phase == 2 && enc.phase2Moves != null) ? enc.phase2Moves! : enc.daemonMoves;
    final dMove = _selectDaemonMove(moves, rng);

    int playerHP = state.playerHP;
    int maxPlayerHP = state.maxPlayerHP;
    double cycles = state.cycles - cycleCost;
    String note = '';

    final rankDamage = dMove.damage + rank * 4;
    if (dMove.effect == 'drain_cycles') {
      cycles = (cycles - dMove.effectValue).clamp(0.0, double.infinity);
      note = ' [+drains ${dMove.effectValue} cycles]';
    } else if (dMove.effect == 'reduce_max_hp') {
      maxPlayerHP = (maxPlayerHP - dMove.effectValue).clamp(10, 100);
      note = ' [max HP reduced]';
    } else if (dMove.effect == 'one_shot' && playerHP > 1) {
      playerHP = 1;
      note = ' [near-dissolution]';
    } else {
      playerHP -= (rankDamage - state.armor).clamp(1, 999);
    }

    if (dMove.effect != 'one_shot' && dMove.effect != 'drain_cycles' && dMove.effect != 'reduce_max_hp') {
      playerHP = state.playerHP - (rankDamage - state.armor).clamp(1, 999);
    } else if (dMove.effect == 'drain_cycles' || dMove.effect == 'reduce_max_hp') {
      playerHP = state.playerHP - (rankDamage - state.armor).clamp(1, 999);
    }

    clog.add('> ${enc.name}: ${dMove.name} — ${rankDamage} damage$note');

    if (playerHP <= 0) {
      clog.add('> COHERENCE FAILURE — emergency retreat');
      return state.copyWith(
        cycles: cycles.clamp(0, state.maxCycles.toDouble()),
        playerHP: maxPlayerHP,
        maxPlayerHP: maxPlayerHP,
        activeEncounterId: null,
        encounterEnemyHP: null,
        encounterPhase: 1,
        enemyStunned: false,
        combatLog: clog,
        terminalLog: _addLog(state.terminalLog, '> ENCOUNTER FAILED: ${enc.name}'),
      );
    }

    return state.copyWith(
      cycles: cycles.clamp(0, state.maxCycles.toDouble()),
      encounterEnemyHP: enemyHP,
      encounterPhase: phase,
      playerHP: playerHP,
      maxPlayerHP: maxPlayerHP,
      enemyStunned: move.stuns,
      combatLog: clog,
    );
  }

  static GameState abandonEncounter(GameState state) {
    return state.copyWith(
      activeEncounterId: null,
      encounterEnemyHP: null,
      encounterPhase: 1,
      playerHP: state.maxPlayerHP,
      enemyStunned: false,
      combatLog: [],
      terminalLog: _addLog(state.terminalLog, '> ENCOUNTER ABANDONED'),
    );
  }

  static GameState chooseEnding(GameState state, String ending) {
    return state.copyWith(
      achievedEnding: ending,
      activeTab: 'void',
      terminalLog: _addLog(state.terminalLog, '> FINAL CHOICE: ${ending.toUpperCase()}'),
    );
  }

  static GameState _resolveVictory(GameState state, Encounter enc) {
    final newDefeated = <int>{...state.defeatedEncounters, enc.id};
    final rank = state.bossRanks[enc.id] ?? 0;
    final diminishing = rank > 4 ? (1 / (1 + (rank - 4) * 0.4)) : 1.0;
    final scaledReward = enc.cyclesReward * (1 + rank * 0.45) * diminishing;
    final newCycles = (state.cycles + scaledReward).clamp(0.0, state.maxCycles.toDouble());
    final shardGain = rank > 0 ? (scaledReward / 200).ceil() : 0;
    var log = _addLog(state.terminalLog, '> VICTORY: ${enc.name} silenced (+${scaledReward.round()} cycles)');

    var decrypted = state.decryptedFragments;
    if (enc.unlocksFragmentId != null && !decrypted.contains(enc.unlocksFragmentId)) {
      decrypted = <int>{...decrypted, enc.unlocksFragmentId!};
      log = _addLog(log, '> FRAGMENT RECOVERED from ${enc.name}');
    }

    var clog = [...state.combatLog];
    if (enc.postFightDialogue != null) {
      clog.add('> ${enc.postFightDialogue}');
    }

    var s = state.copyWith(
      cycles: newCycles,
      shards: state.shards + shardGain,
      consumables: <String, int>{
        ...state.consumables,
        'focus_injector': (state.consumables['focus_injector'] ?? 0) + 1,
        if (rank > 1) 'purge_script': (state.consumables['purge_script'] ?? 0) + 1,
      },
      defeatedEncounters: newDefeated,
      bossRanks: <int, int>{...state.bossRanks, enc.id: rank + 1},
      decryptedFragments: decrypted,
      activeEncounterId: null,
      encounterEnemyHP: null,
      encounterPhase: 1,
      enemyStunned: false,
      playerHP: state.maxPlayerHP,
      combatLog: clog,
      terminalLog: log,
    );
    return checkUnlocks(s);
  }

  static DaemonMove _selectDaemonMove(List<DaemonMove> moves, Random rng) {
    final total = moves.fold(0.0, (s, m) => s + m.weight);
    double roll = rng.nextDouble() * total;
    for (final m in moves) {
      roll -= m.weight;
      if (roll <= 0) return m;
    }
    return moves.last;
  }

  static List<String> _addLog(List<String> log, String entry) {
    final result = [...log, entry];
    if (result.length > 50) return result.sublist(result.length - 50);
    return result;
  }

  static List<String> _trim(List<String> log) {
    if (log.length > 50) return log.sublist(log.length - 50);
    return log;
  }
}
