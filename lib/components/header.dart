import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

class Header extends StatelessComponent {
  const Header({super.key});

  @override
  Component build(BuildContext context) {
    var activePath = context.url;

    return header([
      nav(classes: 'flex items-center justify-between w-full', [
        // Logo
        Link(
          to: '/',
          child: img(
            src: 'images/evefrontier-club.png',
            alt: 'EVE Frontier Club',
            classes: 'h-12 hover:opacity-80 transition-opacity',
            width: 48,
            height: 48,
          ),
        ),

        // Navigation links
        div(classes: 'flex gap-0', [
          for (var route in [
            (label: 'Home', path: '/'),
            (label: 'Leaderboard', path: '/leaderboard'),
            (label: 'About', path: '/about'),
          ])
            div(classes: activePath == route.path ? 'nav-link active' : 'nav-link', [
              Link(to: route.path, child: .text(route.label)),
            ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('header', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(horizontal: 2.rem, vertical: 1.rem),
        justifyContent: .center,
        backgroundColor: const Color('#0b0e14'),
      ),
    ]),
    css('nav', [
      css('&').styles(
        display: .flex,
        width: 100.percent,
        maxWidth: 1280.px,
        padding: .symmetric(horizontal: 0.px, vertical: 0.px),
        justifyContent: .spaceBetween,
        alignItems: .center,
      ),
    ]),
    css('img', [
      css('&').styles(
        display: .block,
      ),
    ]),
    css('.nav-link', [
      css('&').styles(
        display: .flex,
        position: .relative(),
        padding: .symmetric(horizontal: 1.5.rem, vertical: 0.5.rem),
        alignItems: .center,
        color: const Color('#9aa0b1'),
        fontSize: 0.95.rem,
        fontWeight: .w600,
        textDecoration: TextDecoration(line: .none),
      ),
      css('&:hover').styles(
        color: const Color('#4cc9f0'),
      ),
      css('a').styles(
        textDecoration: TextDecoration(line: .none),
      ),
    ]),
    css('.nav-link.active', [
      css('&').styles(
        color: const Color('#4cc9f0'),
      ),
      css('&::after').styles(
        content: '',
        display: .block,
        position: .absolute(bottom: 0.px),
        height: 3.px,
        backgroundColor: const Color('#4cc9f0'),
      ),
    ]),
  ];
}
