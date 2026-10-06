import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../services/trust_service.dart';

@client
class Leaderboard extends StatefulComponent {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  late TrustService trustService;
  List<PlayerTrustEntry> players = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    trustService = TrustService();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      setState(() => isLoading = true);
      final data = await trustService.getLeaderboard(limit: 100);
      setState(() {
        players = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'min-h-screen flex flex-col bg-[#0b0e14]', [
      // Header Banner
      section(classes: 'px-4 py-12 text-center border-b border-[#1f2430]', [
        h1(classes: 'text-5xl md:text-6xl font-bold text-[#e6e9ef] mb-2', [.text('Trust Index Leaderboard')]),
        p(classes: 'text-[#9aa0b1] text-lg', [.text('Top players ranked by reputation score across New Eden')]),
      ]),

      // Content Section
      section(classes: 'flex-1 px-4 py-12', [
        div(classes: 'max-w-6xl mx-auto', [
          if (isLoading) ...[
            div(classes: 'flex items-center justify-center py-20', [
              div(classes: 'text-center', [
                div(classes: 'text-[#4cc9f0] text-4xl mb-4', [.text('⏳')]),
                p(classes: 'text-[#9aa0b1]', [.text('Loading leaderboard data...')]),
              ]),
            ]),
          ] else if (errorMessage != null) ...[
            div(classes: 'bg-[#9d4bff] bg-opacity-10 border border-[#9d4bff] rounded-lg p-6', [
              p(classes: 'text-[#c28aff]', [.text('Error: $errorMessage')]),
              button(
                onClick: _loadLeaderboard,
                classes: 'mt-4 btn-primary px-6 py-2 rounded-lg font-semibold text-white cursor-pointer',
                [.text('Retry')],
              ),
            ]),
          ] else if (players.isEmpty) ...[
            div(classes: 'text-center py-20', [
              p(classes: 'text-[#9aa0b1] text-lg', [.text('No players found in leaderboard')]),
            ]),
          ] else ...[
            // Leaderboard Table (Desktop)
            div(classes: 'hidden md:block', [
              div(classes: 'card overflow-hidden', [
                table(classes: 'w-full', [
                  thead([
                    tr(classes: 'border-b border-[#1f2430]', [
                      th(classes: 'text-left py-4 px-6 text-[#9aa0b1] font-semibold text-sm', [.text('Rank')]),
                      th(classes: 'text-left py-4 px-6 text-[#9aa0b1] font-semibold text-sm', [.text('Player')]),
                      th(classes: 'text-right py-4 px-6 text-[#9aa0b1] font-semibold text-sm', [.text('Score')]),
                      th(classes: 'text-center py-4 px-6 text-[#9aa0b1] font-semibold text-sm', [.text('Status')]),
                    ]),
                  ]),
                  tbody([
                    for (var player in players) ...[
                      tr(
                        classes: 'border-b border-[#1f2430] hover:bg-[#11141c] transition-colors',
                        [
                          td(classes: 'py-4 px-6 text-[#e6e9ef] font-bold', [_buildRankBadge(player.rank)]),
                          td(classes: 'py-4 px-6 text-[#e6e9ef]', [.text(player.playerName)]),
                          td(classes: 'py-4 px-6 text-right font-mono text-[#72e3ff]', [
                            .text(_formatScore(player.trustScore)),
                          ]),
                          td(classes: 'py-4 px-6 text-center', [_buildStatusBadge(player.status)]),
                        ],
                      ),
                    ],
                  ]),
                ]),
              ]),
            ]),

            // Leaderboard Cards (Mobile)
            div(classes: 'md:hidden space-y-4', [
              for (var player in players) ...[
                div(classes: 'card', [
                  div(classes: 'flex items-start justify-between mb-4', [
                    div([
                      _buildRankBadge(player.rank),
                    ]),
                    _buildStatusBadge(player.status),
                  ]),
                  h3(classes: 'text-[#e6e9ef] font-bold text-lg mb-2', [.text(player.playerName)]),
                  div(classes: 'flex justify-between items-end', [
                    span(classes: 'text-[#9aa0b1] text-sm', [.text('Trust Score')]),
                    span(classes: 'text-[#72e3ff] font-mono text-xl font-bold', [
                      .text(_formatScore(player.trustScore)),
                    ]),
                  ]),
                ]),
              ],
            ]),
          ],
        ]),
      ]),
    ]);
  }

  static Component _buildRankBadge(int rank) {
    late String rankEmoji;
    late String bgColor;
    late String textColor;

    if (rank == 1) {
      rankEmoji = '🥇';
      bgColor = 'bg-yellow-600';
      textColor = 'text-yellow-200';
    } else if (rank == 2) {
      rankEmoji = '🥈';
      bgColor = 'bg-gray-400';
      textColor = 'text-gray-100';
    } else if (rank == 3) {
      rankEmoji = '🥉';
      bgColor = 'bg-orange-600';
      textColor = 'text-orange-200';
    } else {
      rankEmoji = '#$rank';
      bgColor = 'bg-[#4cc9f0] bg-opacity-20';
      textColor = 'text-[#72e3ff]';
    }

    return span(classes: '$bgColor $textColor px-3 py-1 rounded-full text-sm font-semibold inline-block', [
      .text(rankEmoji),
    ]);
  }

  static Component _buildStatusBadge(String status) {
    late String bgColor;
    late String textColor;
    late String statusLabel;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = 'bg-[#4cc9f0] bg-opacity-20';
        textColor = 'text-[#72e3ff]';
        statusLabel = '✓ Active';
        break;
      case 'pending':
        bgColor = 'bg-[#9aa0b1] bg-opacity-20';
        textColor = 'text-[#b0b8c8]';
        statusLabel = '⏳ Pending';
        break;
      case 'flagged':
        bgColor = 'bg-[#ff6b6b] bg-opacity-20';
        textColor = 'text-[#ff8787]';
        statusLabel = '⚠ Flagged';
        break;
      default:
        bgColor = 'bg-[#1f2430]';
        textColor = 'text-[#9aa0b1]';
        statusLabel = '? Unknown';
    }

    return span(classes: '$bgColor $textColor px-3 py-1 rounded-full text-xs font-semibold inline-block', [
      .text(statusLabel),
    ]);
  }

  static String _formatScore(double score) {
    if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    }
    return score.toStringAsFixed(0);
  }

  @css
  static List<StyleRule> get styles => [
    css('a').styles(
      textDecoration: .none,
    ),
  ];
}
