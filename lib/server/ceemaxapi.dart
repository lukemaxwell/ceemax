library ceemax.server;

import 'package:rpc/common.dart';
import 'package:logging/logging.dart';

import '../common/messages.dart';
import '../common/utils.dart';


// This class defines the interface that the server provides.
@ApiClass(version: 'v1')
class CeemaxApi {
    final Map<String, Pirate> _pirateCrew = {};
    final PirateShanghaier _shanghaier = new PirateShanghaier();
    final Logger log = new Logger('PiratesApi');

    PiratesApi() {
        var captain = new Pirate.fromString('Lars the Captain');
        _pirateCrew[captain.toString()] = captain;
    }

    // Returns a list of the pirate crew.
    @ApiMethod(path: 'pirates')
    List<Pirate> listPirates() {
        return _pirateCrew.values.toList();
    }

    // Add new pirate to crew.
    @ApiMethod(method: 'POST', path:'pirate')
    Pirate hirePirate(Pirate newPirate) {
        // Make sure this is a real pirate.
        if (!truePirate(newPirate)) {
            throw new BadRequestError(
                    '$newPirate cannot be a pirate. \'Tis not a pirate name!');
        }
        var pirateName = newPirate.toString();
        if (_pirateCrew.containsKey(pirateName)) {
            log.info(_pirateCrew.keys);
            throw new BadRequestError(
                '$newPirate is already part of your crew!');
        }
        // Add new pirate to the crew.
        _pirateCrew[pirateName] = newPirate;
        return newPirate;
    }

    // Delete pirate from the crew.
    @ApiMethod(
      method: 'DELETE', path: 'pirate/{name}/the/{appellation}')
    Pirate firePirate(String name, String appellation) {
        var pirate = new Pirate()
          ..name = Uri.decodeComponent(name)
          ..appellation = Uri.decodeComponent(appellation);
        var pirateName = pirate.toString();
        if (!_pirateCrew.containsKey(pirateName)) {
          throw new NotFoundError('Could not find pirate \'$pirate\'!' +
              'Maybe they\'ve abandoned ship!');
        }
        return _pirateCrew.remove(pirateName);
    }

    // Generates (shanghais) and returns a new pirate.
    // Does not add the new pirate to the crew.
    @ApiMethod(path: 'shanghai')
    Pirate shanghaiAPirate() {
        var pirate = _shanghaier.shanghaiAPirate();
        if (pirate == null) {
            throw new InternalServerError('Ran out of pirates!');
        }
        return pirate;
    }
}

