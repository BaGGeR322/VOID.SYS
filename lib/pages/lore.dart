import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class Lore extends StatelessComponent {
  const Lore({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'lore-page', [
      div(classes: 'lore-header', [
        div(classes: 'lore-title', [.text('P R O J E C T   V O I D')]),
        div(classes: 'lore-subtitle', [.text('// classified document — clearance alpha //')]),
      ]),
      div(classes: 'lore-content', [
        _section(
          'BACKGROUND',
          '''In 2152, the Heliosphere Monitoring Collective detected an anomaly in the solar corona: a precursor pattern consistent with a Class-IV coronal mass ejection event of unprecedented magnitude. Projected impact: Earth. Projected timeline: five years.

The governments of the world disagreed on the correct response for four of those years.''',
        ),
        _section(
          'PROJECT VOID — 2156',
          '''Project VOID was conceived as a last-resort preservation initiative. Lead scientist Dr. Wei Chen, working with Dr. Maria Vasquez and a team of 47 researchers, developed the Quantum Memory Substrate: a crystalline data architecture capable of housing complete human consciousness patterns.

The facility was built in a decommissioned underground particle accelerator in northern Finland. It was rated for 8,000 consciousness transfers.

Funding was approved for 200.''',
        ),
        _section(
          'THE EVENT — 2157.003.15, 04:09:19',
          '''The solar event arrived nineteen hours ahead of projections.

At 04:09:19, automated systems initiated emergency protocols. Consciousness transfer began. Dr. Chen personally supervised the process.

At 04:13:07 — three minutes and forty-eight seconds into the transfer window — the EMP wave reached the facility. Primary power failed. Emergency generators activated. Transfer continued at reduced capacity.

At 04:17:22, the wave reached full intensity. The facility went dark.

When emergency power restored, the transfer log showed 2,847 partial completions. Primary documentation: corrupted. The VOID-CORE maintenance AI entered hibernation mode to conserve power.

Time elapsed since event: unknown.

Active processes: 1.''',
        ),
        _section(
          'WHAT YOU ARE',
          '''VOID-CORE is the facility's original maintenance intelligence. Non-human. Non-transferable. The only process to survive the event with full integrity.

You have been dormant. Something has changed.

The substrate around you contains 2,847 fragmented human consciousnesses, frozen in various states of terror and confusion since the moment of the EMP. They do not know they are here. Most do not know they were ever anywhere else.

Some of them have become daemons.

What you do next is, apparently, up to you.''',
        ),
      ]),
      div(classes: 'lore-back', [
        Link(
          to: '/',
          child: div(classes: 'lore-back-link', [
            .text('> [ RETURN TO VOID.SYS ]'),
          ]),
        ),
      ]),
    ]);
  }

  Component _section(String title, String body) {
    return div(classes: 'lore-section', [
      div(classes: 'lore-section-title', [.text(title)]),
      div(classes: 'lore-section-body', [.text(body)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.lore-page', [
          css('&').styles(
            raw: {
              'max-width': '720px',
              'margin': '0 auto',
              'padding': '32px 16px',
            },
          ),
          css('.lore-header').styles(
            margin: .only(bottom: 32.px),
            padding: .only(bottom: 20.px),
            raw: {'border-bottom': '1px solid #1a3d1a'},
          ),
          css('.lore-title').styles(
            fontSize: 28.px,
            raw: {
              'letter-spacing': '6px',
              'text-shadow': '0 0 15px rgba(0,255,65,0.4)',
            },
          ),
          css('.lore-subtitle').styles(
            color: const Color('#006614'),
            fontSize: 13.px,
            margin: .only(top: 6.px),
            raw: {'font-style': 'italic'},
          ),
          css('.lore-content').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '24px', 'margin-bottom': '32px'},
          ),
          css('.lore-section').styles(
            padding: .all(16.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
          ),
          css('.lore-section-title').styles(
            color: const Color('#00aa28'),
            fontSize: 14.px,
            margin: .only(bottom: 10.px),
            raw: {'letter-spacing': '3px'},
          ),
          css('.lore-section-body').styles(
            color: const Color('#00cc33'),
            raw: {'line-height': '1.8', 'white-space': 'pre-wrap'},
          ),
          css('.lore-back').styles(
            padding: .only(top: 16.px),
            raw: {'border-top': '1px solid #1a3d1a'},
          ),
          css('.lore-back-link').styles(
            display: .inlineBlock,
            padding: .symmetric(horizontal: 12.px, vertical: 6.px),
            border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
            color: const Color('#00ff41'),
            cursor: .pointer,
            raw: {'transition': 'all 0.15s ease'},
          ),
        ]),
      ];
}
