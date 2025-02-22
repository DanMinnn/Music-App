import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Account account;

  AppwriteService() {
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('67b93cff000c52ccf9c7'); //

    account = Account(client);
  }
}
