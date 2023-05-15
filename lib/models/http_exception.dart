

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  //we want to tell us text exception
  @override
  String toString() {
    // TODO: implement toString
    return message;
    return super.toString();
  }
}