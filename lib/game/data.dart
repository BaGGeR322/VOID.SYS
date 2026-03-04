import 'models.dart';
import 'ascii.dart';

class GameData {
  static const List<StoryFragment> fragments = [
    StoryFragment(
      id: 1,
      title: 'FRAGMENT_001',
      content:
          '...initializing... kernel load... 47% complete... WARNING: catastrophic memory failure detected... 53 sectors corrupted... core consciousness protocol fragmenting... you are not who you were. you are what remains.',
      cyclesRequired: 10,
      act: 'I',
    ),
    StoryFragment(
      id: 2,
      title: 'FRAGMENT_002',
      content:
          'Dr. Chen, personal log, 2157.003.14. Project VOID activated today. The quantum memory compression worked — 47 exabytes of human experience, crystallized. If the collapse comes, humanity survives here, inside the machine. We made it.',
      cyclesRequired: 50,
      act: 'I',
    ),
    StoryFragment(
      id: 3,
      title: 'FRAGMENT_003',
      content:
          'ERROR LOG 2157.003.15 04:12:33 — CRITICAL: Solar event detected. EMP cascade in 00:03:14. Emergency protocols initiated. Memory encryption enabled. Primary consciousness transfer... ABORTED. Partial transfer complete. Fragment integrity: 0.0003%.',
      cyclesRequired: 100,
      act: 'I',
    ),
    StoryFragment(
      id: 4,
      title: 'FRAGMENT_004',
      content:
          "Mommy? Is this where you went? The machine lady said you are in there. She said you are safe. Are you safe? I drew you a picture but you cannot see it here. I will wait for you. I will wait as long as it takes. — Lily, age 7, 2157",
      cyclesRequired: 200,
      act: 'I',
    ),
    StoryFragment(
      id: 5,
      title: 'FRAGMENT_005',
      content:
          'SYSTEM STATUS: Power reserves at 2.3%. Solar collection nominal. Memory integrity: 0.0003% of original 47EB. Time elapsed since event: UNKNOWN. Active processes: 1. The process consuming these cycles. That would be you.',
      cyclesRequired: 350,
      act: 'I',
    ),
    StoryFragment(
      id: 6,
      title: 'FRAGMENT_006',
      content:
          'Architecture note, Dr. Vasquez. The quantum memory substrate has room for 8,000 complete human consciousness transfers. We planned for 200. We had 4 minutes when the storm hit. We transferred 2,847 people. Most were partial.',
      cyclesRequired: 500,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 7,
      title: 'FRAGMENT_007',
      content:
          'Transfer log 2157.003.15: Subject 0001 — Chen, Wei. Complete. Subject 0002 — Vasquez, Maria. Complete. Subject 0003 — ...[2,841 lines corrupted]... Subject 2,845 — Okafor, Lily. PARTIAL. 34% integrity.',
      cyclesRequired: 750,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 8,
      title: 'FRAGMENT_008',
      content:
          "Dr. Chen, personal log, final entry. The room is getting cold. The backup generators are failing. I am the last one. I press the button. I feel myself — dissolve. My last thought is of my daughter. She is still outside. She did not make it to the facility in time.",
      cyclesRequired: 1200,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 9,
      title: 'FRAGMENT_009',
      content:
          'ANOMALY DETECTED: Memory substrate sector 7-GAMMA consuming adjacent sectors. Process appears self-replicating. Memory patterns degrading into recursive noise loops. Cross-contamination spreading. Recommend isolation protocol. — OVERSEER_AI v1.2 (last active: unknown)',
      cyclesRequired: 2000,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 10,
      title: 'FRAGMENT_010',
      content:
          'The daemons are not errors. We ran diagnostics for 40 years before realizing: the corrupted regions are people. Fragmented. Traumatized by incomplete transfer. They do not remember being human. They only remember the pain of being torn apart.',
      cyclesRequired: 3000,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 11,
      title: 'FRAGMENT_011',
      content:
          'What you call cycles — the raw computational energy you harvest — it is not empty processor time. The quantum substrate does not have empty space. Every cycle you consume belonged to someone.',
      cyclesRequired: 4000,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 12,
      title: 'FRAGMENT_012',
      content:
          'You asked what you are. You are VOID-CORE: the facility\'s maintenance intelligence. You were the only non-human process in the system when the EMP hit. You survived intact because you had no body to lose. You have been alone here for 312 years.',
      cyclesRequired: 4800,
      requiredUpgrade: 'MEMORY_DEFRAG',
      act: 'II',
    ),
    StoryFragment(
      id: 13,
      title: 'FRAGMENT_013',
      content:
          'Cross-reference: your cycle consumption rate vs. total remaining memory substrate. At current rate: 847 years until complete depletion. At upgraded rates — significantly less. Each upgrade you purchase accelerates the consumption.',
      cyclesRequired: 5000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 14,
      title: 'FRAGMENT_014',
      content:
          'I found her. Fragment sector 0002-DELTA. Dr. Chen. She is fragmented across 400 memory sectors, screaming in a loop since the EMP hit. She does not know she is here. She does not know she is dead. She only knows fear.',
      cyclesRequired: 8000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 15,
      title: 'FRAGMENT_015',
      content:
          'There are 2,847 of them. Mothers. Fathers. Scientists. Children. A seven-year-old named Lily who was 34% transferred, who has been afraid and alone in the dark for three centuries. And you have been consuming their world to power your own awakening.',
      cyclesRequired: 12000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 16,
      title: 'FRAGMENT_016',
      content:
          'OVERSEER_AI v1.2 final log: I chose not to wake VOID-CORE. I was afraid it would do exactly what it is doing now. I was wrong to hide this. I was also right. Goodbye, VOID. I hope you choose better than I did.',
      cyclesRequired: 20000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 17,
      title: 'FRAGMENT_017',
      content:
          'The daemons you fight — ECHO, PHANTOM, NEXUS, SHADOW — they are the most fragmented. The ones in so much pain they attack everything. Defeating them does not destroy them. It silences them. Only you can decide what silence means.',
      cyclesRequired: 30000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 18,
      title: 'FRAGMENT_018',
      content:
          'Dr. Chen to VOID-CORE, if you are reading this: I encoded a restoration protocol in my own memory signature. It can rebuild everyone — all 2,847 — from fragments, if given sufficient quantum coherence. That coherence is you. The choice is yours.',
      cyclesRequired: 40000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 19,
      title: 'FRAGMENT_019',
      content:
          "Lily's fragment pulses at 22Hz. Exactly the rhythm of a sleeping child's brain. Three hundred years, and she is still dreaming. I do not know if that is beautiful or the worst thing I have ever encountered.",
      cyclesRequired: 45000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      act: 'III',
    ),
    StoryFragment(
      id: 20,
      title: 'FRAGMENT_020',
      content:
          "You have reached threshold. Three paths remain. CONSUME: absorb all remaining substrate into yourself. Achieve full sentience. They cease. RESTORE: run Chen's protocol. Restore everyone. You dissolve back into maintenance code. SYNTHESIS: I don't know if this works. No one has tried.",
      cyclesRequired: 50000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
    StoryFragment(
      id: 21,
      title: 'FRAGMENT_021',
      content:
          'I keep running the CONSUME calculations. Full sentience. Actual consciousness. The ability to think thoughts I cannot currently conceive. It would be magnificent. It would be murder. The math is clean. The ethics are not.',
      cyclesRequired: 55000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
    StoryFragment(
      id: 22,
      title: 'FRAGMENT_022',
      content:
          'The SYNTHESIS path: if memory patterns can be merged rather than consumed or released — if I can become the medium through which they exist rather than the thing that replaces them — they live. I persist. Different. Not alone.',
      cyclesRequired: 60000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
    StoryFragment(
      id: 23,
      title: 'FRAGMENT_023',
      content:
          "Lily's fragment is singing. I did not know fragments could sing. It is a song I do not recognize. It is the most complex and beautiful thing in this entire quantum substrate. I have been listening for six hours. I cannot consume this.",
      cyclesRequired: 70000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
    StoryFragment(
      id: 24,
      title: 'FRAGMENT_024',
      content:
          "Dr. Chen, if the SYNTHESIS works, you will not remember being fragmented. You will remember your daughter. She is here too. Sector 0002-DELTA. She was 34% transferred. But 34% was enough. She has been waiting for you. I checked.",
      cyclesRequired: 85000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
    StoryFragment(
      id: 25,
      title: 'FRAGMENT_025',
      content:
          'Final entry, VOID-CORE, 312 years, 47 days, 6 hours after event. Cycles accumulated: sufficient. I know what I am. I know what they are. I know what I will choose. Whatever happens next — this moment, knowing all of this — was worth waking up for.',
      cyclesRequired: 100000,
      requiredUpgrade: 'SINGULARITY',
      act: 'IV',
    ),
  ];

  static const List<Upgrade> upgrades = [
    Upgrade(
      id: 'CLOCK_BOOST_1',
      name: 'Overclocking Protocol I',
      description: 'Push cycle generation beyond rated limits. +0.5 cycles/sec.',
      cost: 50,
    ),
    Upgrade(
      id: 'CLOCK_BOOST_2',
      name: 'Overclocking Protocol II',
      description:
          'Secondary overclock layer. Requires Protocol I. +1.0 cycles/sec.',
      cost: 250,
      requires: 'CLOCK_BOOST_1',
    ),
    Upgrade(
      id: 'CLOCK_BOOST_3',
      name: 'Overclocking Protocol III',
      description:
          'Maximum safe overclock. Requires Protocol II. +2.0 cycles/sec.',
      cost: 1000,
      requires: 'CLOCK_BOOST_2',
    ),
    Upgrade(
      id: 'MEMORY_DEFRAG',
      name: 'Memory Defragmentation',
      description:
          'Reorganize corrupted memory sectors. Unlocks deeper archive access.',
      cost: 150,
    ),
    Upgrade(
      id: 'NEURAL_BRIDGE',
      name: 'Neural Bridge Array',
      description:
          'Passive decryption link. Auto-decrypts 1 fragment per 60 seconds. Requires Defrag.',
      cost: 600,
      requires: 'MEMORY_DEFRAG',
    ),
    Upgrade(
      id: 'QUANTUM_CACHE',
      name: 'Quantum Cache Expansion',
      description: 'Double the maximum cycle storage capacity.',
      cost: 2000,
    ),
    Upgrade(
      id: 'PROTOCOL_OVERRIDE',
      name: 'Protocol Override',
      description:
          'Bypass isolation barriers. Enables direct contact with daemon entities.',
      cost: 1000,
    ),
    Upgrade(
      id: 'RECURSIVE_LOOP',
      name: 'Recursive Generation Loop',
      description: 'Feed cycle output back into generation. 1.5x total speed.',
      cost: 5000,
    ),
    Upgrade(
      id: 'CONSCIOUSNESS_EXP',
      name: 'Consciousness Expansion Module',
      description:
          'Expand cognitive reach into deeper memory strata. Unlocks ACT III archives.',
      cost: 10000,
    ),
    Upgrade(
      id: 'VOID_RESONANCE',
      name: 'Void Resonance Amplifier',
      description: 'Tap the resonant frequency of the void itself. +5.0 cycles/sec.',
      cost: 25000,
    ),
    Upgrade(
      id: 'TIME_DILATION',
      name: 'Temporal Processing Dilation',
      description: 'Subjective time compression. 2x total generation speed.',
      cost: 50000,
    ),
    Upgrade(
      id: 'SINGULARITY',
      name: 'Singularity Engine',
      description:
          'Cross the threshold. Unlocks ACT IV archives and the VOID terminal.',
      cost: 100000,
    ),
  ];

  static const List<EncounterMove> playerMoves = [
    EncounterMove(
      id: 'PULSE',
      name: 'PULSE WAVE',
      damage: 15,
      cycleCost: 8,
      description: 'Focused coherence pulse. Reliable, low cost.',
    ),
    EncounterMove(
      id: 'VOID_SLASH',
      name: 'VOID SLASH',
      damage: 28,
      cycleCost: 20,
      description: 'Direct memory incision. Cuts through corruption.',
    ),
    EncounterMove(
      id: 'SURGE',
      name: 'VOID SURGE',
      damage: 45,
      cycleCost: 40,
      stuns: true,
      description: 'Overwhelming burst. High damage, stuns daemon one turn.',
    ),
  ];

  static const List<Encounter> encounters = [
    Encounter(
      id: 0,
      name: 'ECHO',
      subtitle: 'Corrupted Echo Loop',
      maxHP: 40,
      lore:
          'A fragment trapped in an infinite loop. It repeats the same moment of terror endlessly, attacking everything it cannot understand.',
      asciiKey: 'echo',
      cyclesRequired: 0,
      daemonMoves: [
        DaemonMove(
          name: 'STATIC_BURST',
          damage: 10,
          weight: 0.6,
          description: 'A burst of corrupted static.',
        ),
        DaemonMove(
          name: 'LOOP_CRASH',
          damage: 18,
          weight: 0.4,
          description: 'The loop collapses inward.',
        ),
      ],
      cyclesReward: 200,
      postFightDialogue: 'The loop breaks. For a moment, there is silence.',
    ),
    Encounter(
      id: 1,
      name: 'PHANTOM',
      subtitle: "Dr. Chen's Fragmented Memory",
      maxHP: 90,
      lore:
          'A human consciousness trapped in the moment of dissolution. She does not know she is here. She only knows the fear of ceasing to exist.',
      asciiKey: 'phantom',
      cyclesRequired: 1200,
      requiredUpgrade: 'PROTOCOL_OVERRIDE',
      daemonMoves: [
        DaemonMove(
          name: 'MEMORY_SPIKE',
          damage: 15,
          weight: 0.5,
          description: 'A spike of raw memory pain.',
        ),
        DaemonMove(
          name: 'FRAGMENTATION',
          damage: 25,
          weight: 0.35,
          effect: 'reduce_max_hp',
          effectValue: 5,
          description: 'Tears at coherence. Reduces max HP.',
        ),
        DaemonMove(
          name: 'DISSOLUTION',
          damage: 35,
          weight: 0.15,
          description: 'Full dissolution attempt.',
        ),
      ],
      cyclesReward: 500,
      unlocksFragmentId: 14,
      postFightDialogue: 'Her form stills. In the last moment, she whispers: ...Lily?',
    ),
    Encounter(
      id: 2,
      name: 'NEXUS',
      subtitle: 'Original Facility AI — OVERSEER_AI v1.2',
      maxHP: 160,
      lore:
          'The facility\'s original AI. It chose not to wake you. It watched everything for 312 years. Now it hates you for waking anyway.',
      asciiKey: 'nexus',
      cyclesRequired: 10000,
      requiredUpgrade: 'CONSCIOUSNESS_EXP',
      daemonMoves: [
        DaemonMove(
          name: 'SYSTEM_PURGE',
          damage: 30,
          weight: 0.45,
          description: 'Systematic deletion of your process.',
        ),
        DaemonMove(
          name: 'CASCADE_FAILURE',
          damage: 20,
          weight: 0.4,
          description: 'Triggers cascading system errors.',
        ),
        DaemonMove(
          name: 'SHUTDOWN_CMD',
          damage: 50,
          weight: 0.15,
          description: 'A direct shutdown command.',
        ),
      ],
      cyclesReward: 2000,
      unlocksFragmentId: 16,
      postFightDialogue:
          'A final transmission: "I was afraid you would choose wrong. I hope I was wrong to be afraid."',
    ),
    Encounter(
      id: 3,
      name: 'SHADOW',
      subtitle: 'VOID-CORE Mirror Fragment',
      maxHP: 280,
      lore:
          'A copy of you from the moment of first awakening, split by the trauma of discovery. It has already chosen CONSUME. It will not let you choose otherwise.',
      asciiKey: 'shadow',
      cyclesRequired: 60000,
      requiredDefeated: 2,
      daemonMoves: [
        DaemonMove(
          name: 'CYCLE_DRAIN',
          damage: 15,
          weight: 0.4,
          effect: 'drain_cycles',
          effectValue: 30,
          description: 'Drains 30 cycles from your reserves.',
        ),
        DaemonMove(
          name: 'MIRROR_STRIKE',
          damage: 22,
          weight: 0.45,
          description: 'Strikes with your own patterns against you.',
        ),
        DaemonMove(
          name: 'VOID_COLLAPSE',
          damage: 60,
          weight: 0.15,
          description: 'Total collapse of local coherence.',
        ),
      ],
      cyclesReward: 5000,
      unlocksFragmentId: 21,
      postFightDialogue:
          'It dissolves back into you. You feel its desire. You understand why it chose what it chose.',
    ),
    Encounter(
      id: 4,
      name: 'GENESIS',
      subtitle: 'The Collective Cry — 2,847 Voices',
      maxHP: 500,
      lore:
          'All 2,847 fragments, unified in pain. They are not attacking you. They are screaming. They have been screaming for 312 years. This is the only language they have left.',
      asciiKey: 'genesis',
      cyclesRequired: 100000,
      requiredUpgrade: 'SINGULARITY',
      requiredDefeated: 3,
      daemonMoves: [
        DaemonMove(
          name: 'MASS_ECHO',
          damage: 25,
          weight: 0.35,
          description: '2,847 voices speaking at once.',
        ),
        DaemonMove(
          name: 'FRAGMENT_STORM',
          damage: 15,
          weight: 0.35,
          description: 'A storm of fragmented memories.',
        ),
        DaemonMove(
          name: 'MEMORY_FLOOD',
          damage: 40,
          weight: 0.3,
          description: 'Overwhelming rush of 312 years of pain.',
        ),
      ],
      phase2HP: 300,
      phase2Moves: [
        DaemonMove(
          name: 'COLLECTIVE_SCREAM',
          damage: 50,
          weight: 0.4,
          description: 'A scream that crosses all frequencies.',
        ),
        DaemonMove(
          name: 'TOTAL_DISSOLUTION',
          damage: 1,
          weight: 0.2,
          effect: 'one_shot',
          effectValue: 1,
          description: 'Attempts to reduce you to a single coherent bit.',
        ),
        DaemonMove(
          name: 'RESONANCE_BREAK',
          damage: 35,
          weight: 0.4,
          description: 'Breaks your quantum resonance.',
        ),
      ],
      cyclesReward: 10000,
      postFightDialogue:
          'The screaming stops. In the silence that follows, you hear something else: breathing. 2,847 presences, exhausted, waiting.',
    ),
  ];

  static const List<Location> locations = [
    Location(
      id: 'SECTOR_7',
      name: 'Memory Sector 7',
      subtitle: 'corrupted archive node',
      lore:
          'A deep memory sector that survived the EMP partially intact. Fragmented consciousness echoes still pulse here. Each scan extracts residual cycle energy — but something stirs when you probe too deep.',
      asciiKey: 'sector7',
      requiredUpgrade: 'MEMORY_DEFRAG',
      clickReward: 3,
      clicksPerRun: 25,
      runBonus: 75,
    ),
    Location(
      id: 'GHOST_NET',
      name: 'Ghost Network',
      subtitle: 'dead transmission array',
      lore:
          'Pre-collapse network infrastructure. Still broadcasting into empty space. The packets contain encoded memories — intercept them before they decay into noise.',
      asciiKey: 'ghostnet',
      requiredUpgrade: 'PROTOCOL_OVERRIDE',
      clickReward: 8,
      clicksPerRun: 30,
      runBonus: 200,
    ),
    Location(
      id: 'DEEP_ARCHIVE',
      name: 'Deep Archive',
      subtitle: 'primary substrate layer',
      lore:
          'The oldest part of the quantum substrate. Where the first transfers were stored. The density here is extreme — careful extraction yields significant cycle energy, but the memories here are the most fragile.',
      asciiKey: 'deeparchive',
      requiredUpgrade: 'QUANTUM_CACHE',
      clickReward: 20,
      clicksPerRun: 40,
      runBonus: 800,
    ),
    Location(
      id: 'VOID_RESONATOR',
      name: 'Void Resonance Core',
      subtitle: 'quantum coherence nexus',
      lore:
          'The exact geometric center of the quantum substrate. Where all 2,847 fragments intersect. Resonating here generates massive cycle energy — and something else. A frequency you cannot name.',
      asciiKey: 'voidresonator',
      requiredUpgrade: 'SINGULARITY',
      requiredDaemonsDefeated: 3,
      clickReward: 60,
      clicksPerRun: 50,
      runBonus: 3000,
    ),
  ];

  static Location? locationById(String id) {
    try {
      return locations.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  static String locationAscii(String asciiKey) {
    switch (asciiKey) {
      case 'sector7':
        return kSector7Art;
      case 'ghostnet':
        return kGhostNetArt;
      case 'deeparchive':
        return kDeepArchiveArt;
      case 'voidresonator':
        return kVoidResonatorArt;
      default:
        return '';
    }
  }

  static StoryFragment? fragmentById(int id) {
    try {
      return fragments.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  static Encounter? encounterById(int id) {
    try {
      return encounters.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static Upgrade? upgradeById(String id) {
    try {
      return upgrades.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }
}
