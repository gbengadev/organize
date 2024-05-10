//Login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongCredentialAuthException implements Exception {}

//Register
class UserAlreadyExistsException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
