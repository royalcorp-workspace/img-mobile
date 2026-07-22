import '../flavor.dart';

const String _devApi = "https://api-dev.example.com";
// const String _stagingApi = "https://api-staging.example.com";
const String _prodApi = "https://api.example.com";

final String apiUrl = () {
  switch (AppFlavor.current) {
    case Flavor.production:
      return _prodApi;
    // case Flavor.staging:
    //   return _stagingApi;
    case Flavor.development:
    default:
      return _devApi;
  }
}();

String getProductPath() {
  return "/product";
}

String getProductDetailPath(int id) {
  return "/product/$id";
}
