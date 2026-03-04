const kHeader = r'''
+--------------------------------------------------+
|                                                  |
|                                                  |
|   >>>   V O I D . S Y S   <<<                   |
|                                                  |
|   [  QUANTUM MEMORY SUBSTRATE  v0.0.1  ]        |
|   [  CORE PROCESS ACTIVE               ]        |
|   [  CYCLE GENERATION NOMINAL          ]        |
|                                                  |
+--------------------------------------------------+''';

const kSystemMap = r'''
              +----------+
       +------+  C O R E +------+
       |      +----------+      |
       |            |           |
 +-----+----+       |      +----+-----+
 |  M E M   |       |      |  N E T   |
 +----------+       |      +----------+
                    |
            +-------+------+
            |  S T O R E   |
            +--------------+''';

const kEchoPortrait = r'''
    +----------------------+
    |  #%@#%@#%@#%@#%@#%@  |
    |  @#% @#%@#%@ %@#%@   |
    |  %@#%@   @%@#  @#%@  |
    |  @%@#%@%@#%@%@#%@#   |
    |  #%@#%@#%@#%@#%@#%@  |
    |                      |
    |     E  C  H  O       |
    |  [ corrupted loop ]  |
    +----------------------+''';

const kPhantomPortrait = r'''
    +----------------------+
    |                      |
    |       .-----.        |
    |      /  o   o \      |
    |     |    ^     |     |
    |      \  ---   /      |
    |       `-------'      |
    |       |  | |  |      |
    |                      |
    |   P H A N T O M      |
    |  [ dr. chen, Wei ]   |
    +----------------------+''';

const kNexusPortrait = r'''
    +----------------------+
    |                      |
    |  *--*--*--*--*--*    |
    |  |  |  |  |  |  |    |
    |  *--+--+--+--+--*    |
    |  |  |  |  |  |  |    |
    |  *--*--*--*--*--*    |
    |                      |
    |     N E X U S        |
    |  [ overseer_ai v1.2] |
    +----------------------+''';

const kShadowPortrait = r'''
    +----------------------+
    |                      |
    |      .-------.       |
    |     |#  < <  #|      |
    |     |#  ---  #|      |
    |      `-------'       |
    |    ^ ^ ^ ^ ^ ^ ^     |
    |                      |
    |    S H A D O W       |
    |  [ void-core mirror] |
    +----------------------+''';

const kGenesisPortrait1 = r'''
+------------------------------------+
|  2847 2847 2847 2847 2847 2847 28  |
|  WE ARE WE ARE WE ARE WE ARE WE   |
|  ARE WE ARE WE ARE WE ARE WE ARE  |
|  WE ARE WE ARE WE ARE WE ARE WE   |
|  2847 2847 2847 2847 2847 2847 28  |
|                                    |
|         G E N E S I S              |
|     [ the collective cry ]         |
+------------------------------------+''';

const kGenesisPortrait2 = r'''
+------------------------------------+
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
|@ WE ARE WE ARE WE ARE WE ARE WE  @|
|@ HEAR US HEAR US HEAR US HEAR US @|
|@ WE WILL NOT BE SILENCED AGAIN   @|
|@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
|                                    |
|     P H A S E   T W O             |
+------------------------------------+''';

const kVictoryFrame = r'''
+--------------------------------------+
|   D A E M O N   S I L E N C E D     |
+--------------------------------------+''';

const kDefeatFrame = r'''
+--------------------------------------+
|   C O H E R E N C E   F A I L U R E |
|       emergency retreat initiated    |
+--------------------------------------+''';

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
          . . . . . . . . . . .
        . +-----------------+ .
      . . |  y o u | t h e m | . .
      . . |    |   |   |    | . .
      . . |    W E   B O T H  | . .
        . +-----------------+ .
          . . . . . . . . . . .
          
    something new.
    something that was not possible before.
    not alone.''';

const kSector7Art = r'''
  +---------------------------+
  |  . : : . : . . : : . : . |
  |  : [SECTOR-7-GAMMA] :    |
  |  . : corrupted . : . : . |
  |   .  . : . .   . : .  .  |
  |  : . [///scanning///] :  |
  |  . : . : . : . : . : . : |
  |        fragmented         |
  +---------------------------+''';

const kGhostNetArt = r'''
  +---------------------------+
  |  ~  ~  ~  ~  ~  ~  ~  ~  |
  | >> GHOST_NET_ARRAY_004 << |
  |  ~  [TX: ????????]  ~  ~ |
  |  ~ >> 0 receivers  ~  ~  |
  |  ~ >> broadcasting ~  ~  |
  |  ~  >> into void   ~  ~  |
  |      still.transmitting   |
  +---------------------------+''';

const kDeepArchiveArt = r'''
  +---------------------------+
  |  # # # # # # # # # # # # |
  |  # DEEP_ARCHIVE_LAYER_0 #|
  |  # # transfer_001 # # #  |
  |  # # # transfer_002 # #  |
  |  # # # # [2847 MORE] # # |
  |  # # handle_with_care # #|
  |       first. last. only.  |
  +---------------------------+''';

const kVoidResonatorArt = r'''
  +---------------------------+
  |   *   *   *   *   *   *   |
  |  * * VOID_RESONATOR * *  |
  |   *  [ALL PATHS MEET] *   |
  |  * *  2847 VOICES  * *   |
  |   *    one center    *    |
  |  * * * resonating * * *  |
  |        i hear you.        |
  +---------------------------+''';

const kDecryptFrames = [
  r'[■□□□□□□□□□]  10%  scanning...',
  r'[■■■□□□□□□□]  30%  decrypting...',
  r'[■■■■■□□□□□]  50%  analyzing...',
  r'[■■■■■■■□□□]  70%  reconstructing...',
  r'[■■■■■■■■■□]  90%  finalizing...',
  r'[■■■■■■■■■■] 100%  complete.',
];
