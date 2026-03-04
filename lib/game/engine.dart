import 'dart:math';

import 'data.dart';
import 'models.dart';

class GameEngine {
  static const _ticksForAutoDecrypt = 600;

  static GameState tick(GameState state) {
    if (state.achievedEnding != null) return state;

    const dt = 0.1;
    final gained = state.cyclesPerSecond * dt;
    final newCycles = (state.cycles + gained).clamp(0.0, state.maxCycles.toDouble());
    final newTotal = state.cyclesTotal + gained;

    var s = state.copyWith(cycles: newCycles, cyclesTotal: newTotal);

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
      terminalLog: log,
    );
  }

  static GameState clickLocation(GameState state) {
    if (state.activeLocationId == null) return state;
    final loc = GameData.locationById(state.activeLocationId!);
    if (loc == null) return state;

    final newProgress = state.locationProgress + 1;
    final newCycles = (state.cycles + loc.clickReward).clamp(0.0, state.maxCycles.toDouble());

    if (newProgress >= loc.clicksPerRun) {
      final bonus = (newCycles + loc.runBonus).clamp(0.0, state.maxCycles.toDouble());
      final log = _addLog(
        state.terminalLog,
        '> SCAN COMPLETE: ${loc.name} (+${loc.runBonus.toStringAsFixed(0)} bonus)',
      );
      return state.copyWith(
        cycles: bonus,
        cyclesTotal: state.cyclesTotal + loc.clickReward + loc.runBonus,
        locationProgress: 0,
        terminalLog: log,
      );
    }

    return state.copyWith(
      cycles: newCycles,
      cyclesTotal: state.cyclesTotal + loc.clickReward,
      locationProgress: newProgress,
    );
  }

  static GameState exitLocation(GameState state) {
    return state.copyWith(
      activeLocationId: null,
      locationProgress: 0,
      terminalLog: _addLog(state.terminalLog, '> EXITING LOCATION'),
    );
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
    if (state.defeatedEncounters.contains(encounterId)) return false;
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

    final log = _addLog(state.terminalLog, '> DAEMON CONTACT: ${enc.name}');
    return state.copyWith(
      activeEncounterId: encounterId,
      encounterEnemyHP: enc.maxHP,
      encounterPhase: 1,
      enemyStunned: false,
      playerHP: state.maxPlayerHP,
      combatLog: [
        '> INITIATING CONTACT: ${enc.name.toUpperCase()}',
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

    int enemyHP = state.encounterEnemyHP! - actualDamage;

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
      playerHP -= dMove.damage;
    }

    if (dMove.effect != 'one_shot' && dMove.effect != 'drain_cycles' && dMove.effect != 'reduce_max_hp') {
      playerHP = state.playerHP - dMove.damage;
    } else if (dMove.effect == 'drain_cycles' || dMove.effect == 'reduce_max_hp') {
      playerHP = state.playerHP - dMove.damage;
    }

    clog.add('> ${enc.name}: ${dMove.name} — ${dMove.damage} damage$note');

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
    final newCycles = (state.cycles + enc.cyclesReward).clamp(0.0, state.maxCycles.toDouble());
    var log = _addLog(state.terminalLog, '> VICTORY: ${enc.name} silenced (+${enc.cyclesReward.round()} cycles)');

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
      defeatedEncounters: newDefeated,
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
