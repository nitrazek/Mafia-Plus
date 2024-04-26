import 'package:mobile/models/VotingResult.dart';

class VotingSummary {
  final List<VotingResult> votingResults;

  VotingSummary({
    required this.votingResults
  });

  factory VotingSummary.fromJson(Map<String, dynamic> json) {
    List<dynamic> resultsJson = json['votingResults'];
    return VotingSummary(
      votingResults: resultsJson.map((resultJson) => VotingResult.fromJson(resultJson)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'votingResults': votingResults
    };
  }
}
