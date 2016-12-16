library ceemax;

import 'dart:async';
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:logging/logging.dart';
import 'package:rpc/rpc.dart';

import 'package:ceemax/server/ceemaxapi.dart';

final bool debug = false;
final ApiServer _apiServer = new ApiServer(prettyPrint: true);
final String _buildPath = Platform.script.resolve('../build/web/').toFilePath();
final String _devPath = Platform.script.resolve('../web/').toFilePath();

final VirtualDirectory _clientDevDir = new VirtualDirectory(_devPath);
final VirtualDirectory _clientDir = new VirtualDirectory(_buildPath);


Future requestHandler(HttpRequest request) async {
    if (request.uri.path.startsWith('/ceemaxApi')) {
        // Handle the API request.
        var apiResponse;
        try {
            var apiRequest = new HttpApiRequest.fromHttpRequest(request);
            apiResponse =
                await _apiServer.handleHttpApiRequest(apiRequest);
        } catch(error, stack) {
            var exception =
                error is Error ? new Exception(error.toString()) : error;
            apiResponse = new HttpApiResponse.error(
                    HttpStatus.INTERNAL_SERVER_ERROR, exception.toString(),
                    exception, stack);
        }
        return sendApiResponse(apiResponse, request.response);
    } else if (request.uri.path == '/') {
        // Redirect to the ceemax.html file. This will initiate
        // loading the client application.
        //request.response.redirect(Uri.parse('/ceemax.html'));
        request.response.redirect(Uri.parse('/index.html'));
    } else {
        // Server the requested file (path) from the virtual directory,
        // minus the preceding '/'. This will fail with a 404 Not Found
        // if the request is not for a valid file.
        if (debug == true) {
            var fileUri = new Uri.file(_devPath)
                .resolve(request.uri.path.substring(1));
            _clientDevDir.serveFile(new File(fileUri.toFilePath()), request);

        } else {
            var fileUri = new Uri.file(_buildPath)
                .resolve(request.uri.path.substring(1));
            _clientDir.serveFile(new File(fileUri.toFilePath()), request);
        }
    }
}

Future main() async {
  // Add a bit of logging...
  Logger.root
    ..level = Level.INFO
    ..onRecord.listen(print);

  // Set up a server serving the ceemax API.
  _apiServer.addApi(new CeemaxApi());
  HttpServer server = await HttpServer.bind(InternetAddress.ANY_IP_V4, 8088);
  server.listen(requestHandler);
  print('Server listening on http://${server.address.host}:'
      '${server.port}');
}
