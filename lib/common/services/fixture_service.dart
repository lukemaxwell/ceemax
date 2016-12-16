import 'dart:async';
import 'package:angular2/core.dart';
import 'package:ceemax/common/models/fixture.dart';
import 'package:ceemax/common/mock/fixtures.dart';


@Injectable()
class FixtureService {
    Future<List<Fixture>> getFixtures(int competitionId, int matchday) async {
        return mockFixtures;
    }
}
