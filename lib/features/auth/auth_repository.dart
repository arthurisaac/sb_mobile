import 'auth_local_data_source.dart';
import 'auth_remote_data_source.dart';

class AuthRepository {
  static final AuthRepository _authRepository = AuthRepository._internal();
  late AuthLocalDataSource _authLocalDataSource;
  late AuthRemoteDataSource _authRemoteDataSource;

  factory AuthRepository() {
    _authRepository._authLocalDataSource = AuthLocalDataSource();
    _authRepository._authRemoteDataSource = AuthRemoteDataSource();
    return _authRepository;
  }

  AuthRepository._internal();

  AuthLocalDataSource get authLocalDataSource => _authLocalDataSource;

  getLocalAuthDetails() {
    return {
      "isLogin": _authLocalDataSource.checkIsAuth(),
      "id": _authLocalDataSource.getId(),
      "email": _authLocalDataSource.getEmail(),
      "username": _authLocalDataSource.getName(),
    };
  }

  setLocalAuthDetails(
      {bool? authStatus,
      int? id,
      String? ipAddress,
      String? name,
      String? email,
      String? mobile,
      String? image}) {
    _authLocalDataSource.changeAuthStatus(authStatus);
    _authLocalDataSource.setId(id);
    _authLocalDataSource.setIpAddress(ipAddress);
    _authLocalDataSource.setName(name);
    _authLocalDataSource.setImage(image);
  }

  //to login user's data to database. This will be in use when authenticating using phoneNumber
  Future<Map<String, dynamic>> login({String? email, String? password}) async {
    setLocalAuthDetails();
    final result = await _authRemoteDataSource.signInUser(
        email: email, password: password);
    await _authLocalDataSource.setId(result['id']);
    await _authLocalDataSource.changeAuthStatus(true);
    await _authLocalDataSource.setName(result['username']);
    await _authLocalDataSource.setEmail(result['email']);
    await _authLocalDataSource.setMobile(result['mobile']);
    await _authLocalDataSource.setImage(result['image']);

    return Map.from(result); //
  }

  Future<Map<String, dynamic>> addUserData({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? mobile,
    /*, String? latitude, String? longitude*/
  }) async {
    final result = await _authRemoteDataSource.addUser(
      name: name,
      email: email,
      password: password,
      passwordConfirmation:
          passwordConfirmation,
        mobile: mobile/*, latitude: latitude ?? "", longitude: longitude ?? ""*/
    );
    await _authLocalDataSource.setId(result['id']);
    await _authLocalDataSource.changeAuthStatus(true);
    await _authLocalDataSource.setName(result['name']);
    await _authLocalDataSource.setEmail(result['email']);
    await _authLocalDataSource.setMobile(result['mobile']);
    //await _authLocalDataSource.setImage(result['image']);
    return Map.from(result); //
  }

  Future<void> signOut() async {
    await _authLocalDataSource.changeAuthStatus(false);
    await _authLocalDataSource.setId(null);
    await _authLocalDataSource.setName("");
    await _authLocalDataSource.setEmail("");
    await _authLocalDataSource.setMobile("");
    await _authLocalDataSource.setImage("");
  }
}
