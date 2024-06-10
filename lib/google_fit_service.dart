import 'package:googleapis/fitness/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleFitService {
  final _clientId =
      ClientId('438392644288-ok0lq2omefkohhgeojsoi064ees2398m.apps.googleusercontent.com');
  final _scopes = [FitnessApi.fitnessActivityReadScope];

  AuthClient? _client;

  Future<void> authenticate() async {
    if (_client == null) {
      await clientViaUserConsent(_clientId, _scopes, (url) {
        print('Please go to the following URL and grant access:');
        print('  => $url');
      }).then((AuthClient client) {
        _client = client;
        print('Access token obtained: ${client.credentials.accessToken}');
      }).catchError((error) {
        print('Error during authentication: $error');
      });
    }
  }

  Future<List<DataSource>> getDataSources() async {
    if (_client == null) {
      await authenticate();
    }
    var fitnessApi = FitnessApi(_client!);
    var dataSources = await fitnessApi.users.dataSources.list('me');
    return dataSources.dataSource ?? [];
  }

  Future<int> getSteps() async {
  if (_client == null) {
    await authenticate();
  }
  var fitnessApi = FitnessApi(_client!);
  var dataSet = await fitnessApi.users.dataSources.datasets.get(
    'me', 
    'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps',
    'today', 
  );
  if (dataSet.point != null && dataSet.point!.isNotEmpty) {
    var steps = dataSet.point!.last.value!.first.intVal ?? 0;
    return steps;
  } else {
    return 0;
  }
}
}




