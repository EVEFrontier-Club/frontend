import 'dart:convert';
import 'package:http/http.dart' as http;

/// Trust Index API service for communicating with backend endpoints
class TrustService {
  final String baseUrl;
  final http.Client _client = http.Client();

  TrustService({
    this.baseUrl = const String.fromEnvironment('BACKEND_URL', defaultValue: 'https://api.evefrontier.club'),
  });

  /// Fetch the leaderboard of top players by trust score
  /// Returns a list of players with their trust rankings
  Future<List<PlayerTrustEntry>> getLeaderboard({int limit = 50}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/v1/trust-index/leaderboard').replace(
          queryParameters: {'limit': limit.toString()},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PlayerTrustEntry.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching leaderboard: $e');
    }
  }

  /// Get trust score details for a specific player
  Future<PlayerTrustScore> getPlayerTrust(String playerId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/v1/trust-index/$playerId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PlayerTrustScore.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Player not found');
      } else {
        throw Exception('Failed to load player trust: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching player trust: $e');
    }
  }

  /// Get detailed trust score breakdown for a player
  Future<TrustExplanation> getTrustExplanation(String playerId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/v1/trust-index/explain/$playerId'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return TrustExplanation.fromJson(json);
      } else {
        throw Exception('Failed to load trust explanation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trust explanation: $e');
    }
  }
}

/// Represents a single player entry in the trust leaderboard
class PlayerTrustEntry {
  final int rank;
  final String playerId;
  final String playerName;
  final double trustScore;
  final String status; // 'active', 'pending', 'flagged', etc.
  final DateTime lastUpdated;

  PlayerTrustEntry({
    required this.rank,
    required this.playerId,
    required this.playerName,
    required this.trustScore,
    required this.status,
    required this.lastUpdated,
  });

  factory PlayerTrustEntry.fromJson(Map<String, dynamic> json) {
    return PlayerTrustEntry(
      rank: json['rank'] as int? ?? 0,
      playerId: json['playerId'] as String? ?? '',
      playerName: json['playerName'] as String? ?? 'Unknown',
      trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unknown',
      lastUpdated: json['lastUpdated'] != null ? DateTime.parse(json['lastUpdated'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'playerId': playerId,
    'playerName': playerName,
    'trustScore': trustScore,
    'status': status,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

/// Represents a player's trust score
class PlayerTrustScore {
  final String playerId;
  final String playerName;
  final double score;
  final int rank;
  final String status;
  final DateTime issuedAt;

  PlayerTrustScore({
    required this.playerId,
    required this.playerName,
    required this.score,
    required this.rank,
    required this.status,
    required this.issuedAt,
  });

  factory PlayerTrustScore.fromJson(Map<String, dynamic> json) {
    return PlayerTrustScore(
      playerId: json['playerId'] as String? ?? '',
      playerName: json['playerName'] as String? ?? 'Unknown',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      rank: json['rank'] as int? ?? 0,
      status: json['status'] as String? ?? 'unknown',
      issuedAt: json['issuedAt'] != null ? DateTime.parse(json['issuedAt'] as String) : DateTime.now(),
    );
  }
}

/// Represents a detailed explanation of a player's trust score
class TrustExplanation {
  final String playerId;
  final double score;
  final Map<String, dynamic> factors;

  TrustExplanation({
    required this.playerId,
    required this.score,
    required this.factors,
  });

  factory TrustExplanation.fromJson(Map<String, dynamic> json) {
    return TrustExplanation(
      playerId: json['playerId'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      factors: json['factors'] as Map<String, dynamic>? ?? {},
    );
  }
}
