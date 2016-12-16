import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:ceemax/common/models/fixture.dart';
import 'package:ceemax/common/services/fixture_service.dart';

@Component(selector: 'ceemax-fixtures', templateUrl: 'templates/fixtures.html')
class FixturesComponent implements OnInit {
    final FixtureService _fixtureService;
    final RouteParams _routeParams;
    var name = 'Fixtures';
    List<Fixture> fixtures;
    FixturesComponent(this._fixtureService, this._routeParams);

    Future<Null> ngOnInit() async {
       var _competitionId = _routeParams.get('competionId');
       var _matchday = _routeParams.get('matchday');
       var compId = int.parse(_competitionId ?? '', onError: (_) => null);
       var day = int.parse(_matchday ?? '', onError: (_) => null);

       if (compId != null && day != null) {
           fixtures = await (_fixtureService.getFixtures(compId, day));
       } else {
           fixtures = await (_fixtureService.getFixtures(compId, day));
       }
     }
}
