class AuthRepository{
  Future<void> login() async{
    await Future.delayed(const Duration(seconds: 3));
  }
}