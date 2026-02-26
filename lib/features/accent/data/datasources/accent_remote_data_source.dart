abstract class AccentRemoteDataSource {}

class AccentRemoteDataSourceImpl implements AccentRemoteDataSource {
  final dynamic firestore;
  AccentRemoteDataSourceImpl({this.firestore});
}
