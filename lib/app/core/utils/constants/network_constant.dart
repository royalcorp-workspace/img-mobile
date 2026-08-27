import '../flavor.dart';

// const String _devApi = "http://192.215.215.77:8823/api/v1";
const String _devApi = "https://dev-backend-img.royalcorp.co.id/api/v1";
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
