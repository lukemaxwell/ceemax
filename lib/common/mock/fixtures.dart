import 'package:ceemax/common/models/fixture.dart';
int _id = 1;
int _competitionId = 101;
DateTime _date = new DateTime.now();
int _matchday = 1;
String _homeTeamName = 'Manchester United';
int _homeTeamId = 1001;
String _awayTeamName = 'Chelsea';
int _awayTeamId = 1002;
Map _result = {
    'goalsHomeTeam': 1,
    'goalsAwayTeam': 2
};

final List<Fixture> mockFixtures = [
    new Fixture(_id, _competitionId, _date, _matchday,
            _homeTeamName, _homeTeamId, _awayTeamName,
            _awayTeamId, _result)
];

