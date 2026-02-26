abstract class RoleplayRemoteDataSource {}

class RoleplayRemoteDataSourceImpl implements RoleplayRemoteDataSource {
  final dynamic firestore;
  RoleplayRemoteDataSourceImpl({this.firestore});
}
