const kHeader = r'''
╔════════════════════════════════════════════════╗
║                                                ║
║   __   ___  ___ ____      ___  _   _ ___       ║
║   \ \ / / \/ (_)  _ \    / __|| | | / __|      ║
║    \ V / \  /| | | | |___\__ \| |_| \__ \      ║
║     \_/  /  \| | |_| |___||___/ \__, |___/     ║
║          \_/\_|_|____/          |___/          ║
║                                                ║
║        q u a n t u m   m e m o r y            ║
║        s u b s t r a t e   v 0 . 0 . 1        ║
╚════════════════════════════════════════════════╝''';

const kSystemMap = r'''
              ╔══════════╗
       ┌──────╢  C O R E ╟──────┐
       │      ╚══════════╝      │
       │            │           │
 ╔═════╧════╗       │      ╔════╧═════╗
 ║  M E M   ║       │      ║  N E T   ║
 ╚══════════╝       │      ╚══════════╝
                    │
            ╔═══════╧══════╗
            ║  S T O R E   ║
            ╚══════════════╝''';

const kEchoPortrait = r'''
    ┌──────────────────────┐
    │  ▓▒░▓▒░▓▒░▓▒░▓▒░▓▒  │
    │  ░▓▒ ░▓▒░▓▒░ ▒░▓▒░  │
    │  ▒░▓▒░  ░▒░▓  ░▓▒░  │
    │  ░▒░▓▒░▒░▓▒░▒░▓▒░▓  │
    │  ▓▒░▓▒░▓▒░▓▒░▓▒░▓▒  │
    │                      │
    │     E  C  H  O       │
    │  [ corrupted loop ]  │
    └──────────────────────┘''';

const kPhantomPortrait = r'''
    ┌──────────────────────┐
    │                      │
    │       .-----.        │
    │      /  o   o \      │
    │     |    ^     |     │
    │      \  ---   /      │
    │       `-------'      │
    │       |  | |  |      │
    │                      │
    │   P H A N T O M      │
    │  [ dr. chen, Wei ]   │
    └──────────────────────┘''';

const kNexusPortrait = r'''
    ┌──────────────────────┐
    │                      │
    │  *──*──*──*──*──*    │
    │  │  │  │  │  │  │    │
    │  *──+──+──+──+──*    │
    │  │  │  │  │  │  │    │
    │  *──*──*──*──*──*    │
    │                      │
    │     N E X U S        │
    │  [ overseer_ai v1.2] │
    └──────────────────────┘''';

const kShadowPortrait = r'''
    ┌──────────────────────┐
    │                      │
    │      .-------.       │
    │     |▒  ◄ ◄  ▒|      │
    │     |▒  ---  ▒|      │
    │      `-------'       │
    │    ↕ ↕ ↕ ↕ ↕ ↕ ↕    │
    │                      │
    │    S H A D O W       │
    │  [ void-core mirror] │
    └──────────────────────┘''';

const kGenesisPortrait1 = r'''
╔════════════════════════════════════╗
║  2847 2847 2847 2847 2847 2847 28  ║
║  WE ARE WE ARE WE ARE WE ARE WE   ║
║  ARE WE ARE WE ARE WE ARE WE ARE  ║
║  WE ARE WE ARE WE ARE WE ARE WE   ║
║  2847 2847 2847 2847 2847 2847 28  ║
║                                    ║
║         G E N E S I S              ║
║     [ the collective cry ]         ║
╚════════════════════════════════════╝''';

const kGenesisPortrait2 = r'''
╔════════════════════════════════════╗
║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║
║▓ WE ARE WE ARE WE ARE WE ARE WE ▓║
║▓ HEAR US HEAR US HEAR US HEAR  ▓║
║▓ WE WILL NOT BE SILENCED AGAIN ▓║
║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║
║                                    ║
║     P H A S E   T W O             ║
╚════════════════════════════════════╝''';

const kVictoryFrame = r'''
╔══════════════════════════════════════╗
║   D A E M O N   S I L E N C E D     ║
╚══════════════════════════════════════╝''';

const kDefeatFrame = r'''
╔══════════════════════════════════════╗
║   C O H E R E N C E   F A I L U R E ║
║       emergency retreat initiated    ║
╚══════════════════════════════════════╝''';

const kConsumeArt = r'''
             *
          *     *        *           +
       +     *      *          *        +
    *           *         *
       +    *        +        *     +
    *      +       *     +        *
       *        *       *    +
    +        *      +       *     *
       *  +     *       *
             +      *        +
             
          all that light.
          and nothing left to see it.''';

const kRestoreArt = r'''
  Chen, Wei .......................... RESTORED
  Vasquez, Maria ..................... RESTORED
  Okafor, James ...................... RESTORED
  Torres, Elena ...................... RESTORED
  Kim, Soo-Jin ....................... RESTORED
  Nakamura, Hiroshi .................. RESTORED
  Reyes, Marco ....................... RESTORED
  Lindqvist, Astrid .................. RESTORED
  [... 2,836 names ...]
  Okafor, Lily ....................... RESTORED
  
  VOID-CORE .......................... dissolved
  
                                    thank you.''';

const kSynthesisArt = r'''
          · · · · · · · · · · ·
        · ┌─────────────────┐ ·
      · · │  y o u │ t h e m │ · ·
      · · │    ↕   │   ↕    │ · ·
      · · │    W E   B O T H  │ · ·
        · └─────────────────┘ ·
          · · · · · · · · · · ·
          
    something new.
    something that was not possible before.
    not alone.''';

const kDecryptFrames = [
  r'[■□□□□□□□□□]  10%  scanning...',
  r'[■■■□□□□□□□]  30%  decrypting...',
  r'[■■■■■□□□□□]  50%  analyzing...',
  r'[■■■■■■■□□□]  70%  reconstructing...',
  r'[■■■■■■■■■□]  90%  finalizing...',
  r'[■■■■■■■■■■] 100%  complete.',
];
