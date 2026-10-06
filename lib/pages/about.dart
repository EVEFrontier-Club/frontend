import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

@client
class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) {
    return section(classes: 'flex flex-col items-center justify-center min-h-screen px-4 py-20', [
      div(classes: 'max-w-2xl text-center', [
        div(
          classes:
              'inline-block px-4 py-2 rounded-lg bg-[#9d4bff] bg-opacity-10 border border-[#9d4bff] border-opacity-30 mb-6',
          [
            span(classes: 'text-[#c28aff] font-mono text-sm uppercase tracking-wide', [.text('Coming Soon')]),
          ],
        ),

        h1(classes: 'text-4xl md:text-5xl font-bold text-[#e6e9ef] mb-4', [.text('More Details Incoming')]),

        p(classes: 'text-[#9aa0b1] text-lg mb-8 leading-relaxed', [
          .text(
            'We\'re actively building the EVE Frontier Club platform. Check back soon for detailed information about our features, roadmap, and community initiatives.',
          ),
        ]),

        div(classes: 'flex flex-col sm:flex-row gap-4 justify-center', [
          Link(
            to: '/',
            child: button(
              classes:
                  'btn-primary px-8 py-3 rounded-lg font-semibold text-white hover:opacity-90 transition-opacity cursor-pointer border-none',
              [.text('Back to Home')],
            ),
          ),
          a(
            href: 'https://github.com/EVEFrontier-Club',
            classes:
                'border border-[#4cc9f0] border-opacity-50 text-[#72e3ff] px-8 py-3 rounded-lg font-semibold inline-block no-underline hover:bg-[#4cc9f0] hover:bg-opacity-10 transition-all text-center',
            [.text('View on GitHub')],
          ),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('a').styles(
      textDecoration: .none,
    ),
  ];
}
