abstract class ListeningRemoteDataSource {}

class ListeningRemoteDataSourceImpl implements ListeningRemoteDataSource {
  final dynamic firestore;
  ListeningRemoteDataSourceImpl({this.firestore});
}
