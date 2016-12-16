class Fixture {
    final int id;
    int competitionId;
    DateTime date;
    int matchday;
    String homeTeamName;
    int homeTeamId;
    String awayTeamName;
    int awayTeamId;
    Map result;


    Fixture(this.id, this.competitionId, this.date,
            this.matchday, this.homeTeamName, this.homeTeamId,
            this.awayTeamName, this.awayTeamId, this.result);
}
