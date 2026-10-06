import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

@client
class Home extends StatefulComponent {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Component build(BuildContext context) {
    return div(classes: 'min-h-screen flex flex-col', [
      // In Development Banner
      div(classes: 'bg-[#9d4bff] bg-opacity-20 border-b border-[#9d4bff] border-opacity-40 px-4 py-3 text-center', [
        span(classes: 'text-[#c28aff] font-mono text-sm', [
          .text('🚀 IN DEVELOPMENT — Built during Hackathon | Coming Soon: Full Platform'),
        ]),
      ]),

      // Hero Section
      section(classes: 'flex-1 flex flex-col items-center justify-center px-4 py-20 text-center', [
        // Badge
        div(
          classes:
              'inline-block px-3 py-1 rounded-full bg-[#4cc9f0] bg-opacity-10 border border-[#4cc9f0] border-opacity-30 mb-6',
          [
            span(classes: 'text-[#72e3ff] font-mono text-xs uppercase tracking-wide', [
              .text('Analytics & Trust Platform'),
            ]),
          ],
        ),

        // Title
        h1(classes: 'text-5xl md:text-6xl font-bold text-[#e6e9ef] mb-4 leading-tight', [.text('EVE Frontier Club')]),

        // Tagline
        p(classes: 'text-xl md:text-2xl text-[#9aa0b1] max-w-2xl mb-8 leading-relaxed', [
          .text(
            'A modular platform for reputation systems, analytics, and community infrastructure in the EVE Frontier universe.',
          ),
        ]),

        // CTA Buttons
        div(classes: 'flex flex-col sm:flex-row gap-4 justify-center mb-12', [
          a(
            href: '#features',
            classes:
                'btn-primary px-8 py-3 rounded-lg font-semibold inline-block text-white no-underline hover:opacity-90 transition-opacity',
            [.text('Explore Features')],
          ),
          a(
            href: 'https://github.com/EVEFrontier-Club',
            classes:
                'border border-[#4cc9f0] border-opacity-50 text-[#72e3ff] px-8 py-3 rounded-lg font-semibold inline-block no-underline hover:bg-[#4cc9f0] hover:bg-opacity-10 transition-all',
            [.text('GitHub')],
          ),
        ]),

        // Coming Soon Message
        p(classes: 'text-[#9aa0b1] text-sm', [.text('✨ More details coming as development progresses')]),
      ]),

      // Features Section
      section(id: 'features', classes: 'px-4 py-20 bg-[#11141c] bg-opacity-50', [
        div(classes: 'max-w-6xl mx-auto', [
          h2(classes: 'text-4xl font-bold text-[#e6e9ef] text-center mb-16', [.text('What We\'re Building')]),

          // Feature Grid
          div(classes: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6', [
            // Trust Index Card
            _featureCard(
              title: 'Trust Index',
              description: 'Credit-rating-style reputation scores for players across New Eden',
              icon: '⭐',
            ),

            // Analytics Card
            _featureCard(
              title: 'Analytics Dashboard',
              description: 'Deep player metrics, leaderboards, and performance insights',
              icon: '📊',
            ),

            // Community Card
            _featureCard(
              title: 'Community Hub',
              description: 'Connect with fellow players and discover new opportunities',
              icon: '👥',
            ),

            // Modular Platform Card
            _featureCard(
              title: 'Modular Platform',
              description: 'Built for scalability with independent, composable modules',
              icon: '🔧',
            ),
          ]),
        ]),
      ]),

      // Footer Section
      footer(classes: 'bg-[#11141c] border-t border-[#1f2430] px-4 py-12', [
        div(classes: 'max-w-6xl mx-auto', [
          div(classes: 'grid grid-cols-1 md:grid-cols-3 gap-8 mb-8', [
            // About
            div([
              h3(classes: 'text-[#e6e9ef] font-bold mb-3', [.text('About')]),
              p(classes: 'text-[#9aa0b1] text-sm leading-relaxed', [
                .text(
                  'EVE Frontier Club is an open-source platform bringing analytics, trust systems, and community tools to the EVE Frontier universe.',
                ),
              ]),
            ]),

            // Links
            div([
              h3(classes: 'text-[#e6e9ef] font-bold mb-3', [.text('Resources')]),
              ul(classes: 'list-none', [
                li([
                  a(
                    href: 'https://evefrontier.com',
                    classes: 'text-[#4cc9f0] hover:text-[#72e3ff] text-sm no-underline',
                    [.text('EVE Frontier')],
                  ),
                ]),
                li([
                  a(
                    href: 'https://github.com/EVEFrontier-Club',
                    classes: 'text-[#4cc9f0] hover:text-[#72e3ff] text-sm no-underline',
                    [
                      .text('GitHub'),
                    ],
                  ),
                ]),
              ]),
            ]),

            // Status
            div([
              h3(classes: 'text-[#e6e9ef] font-bold mb-3', [.text('Status')]),
              p(classes: 'text-[#9aa0b1] text-sm', [.text('Development Mode')]),
              p(classes: 'text-[#72e3ff] text-xs font-mono mt-1', [.text('Hackathon 2026')]),
            ]),
          ]),

          // Copyright
          div(classes: 'border-t border-[#1f2430] pt-6 text-center', [
            p(classes: 'text-[#9aa0b1] text-xs mb-2', [
              .text('© 2026 EVE Frontier Club. '),
              a(
                href: 'https://github.com/EVEFrontier-Club',
                classes: 'text-[#4cc9f0] hover:text-[#72e3ff] no-underline',
                [
                  .text('Open Source'),
                ],
              ),
              .text(' — Built with '),
              a(href: 'https://jaspr.site', classes: 'text-[#4cc9f0] hover:text-[#72e3ff] no-underline', [
                .text('Jaspr'),
              ]),
              .text(' for New Eden.'),
            ]),
            p(classes: 'text-[#72e3ff] text-xs font-mono', [
              .text('✦ Join our community — Contribute to the platform'),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  static Component _featureCard({required String title, required String description, required String icon}) {
    return div(classes: 'card group', [
      div(classes: 'text-4xl mb-4', [.text(icon)]),
      h3(classes: 'text-[#e6e9ef] font-bold text-lg mb-2 group-hover:text-[#72e3ff] transition-colors', [.text(title)]),
      p(classes: 'text-[#9aa0b1] text-sm leading-relaxed', [.text(description)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('a').styles(
      textDecoration: .none,
    ),
    css('ul').styles(
      padding: .only(left: 0.px),
    ),
    css('li').styles(
      margin: .only(bottom: 0.5.rem),
    ),
  ];
}
