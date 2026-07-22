enum Flavor { development, production }

class AppFlavor {
  static const _env =
      String.fromEnvironment('FLAVOR', defaultValue: 'development');

  static Flavor get current {
    switch (_env) {
      case 'production':
        return Flavor.production;
      // case 'staging':
      //   return Flavor.staging;
      case 'development':
      default:
        return Flavor.development;
    }
  }

  static String get name => current.toString().split('.').last;
}
