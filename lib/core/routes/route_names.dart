abstract final class RouteNames {
  static const authLoading = '/auth/loading';
  static const login = '/login';
  static const home = '/';
  static const rabbits = '/rabbits';
  static const addRabbit = '/rabbits/add';
  static const breedings = '/breedings';
  static const addBreeding = '/breedings/add';
  static const reports = '/reports';
  static const more = '/more';

  static String rabbitDetails(String rabbitId) => '/rabbits/$rabbitId';
  static String editRabbit(String rabbitId) => '/rabbits/$rabbitId/edit';
  static String moveRabbit(String rabbitId) => '/rabbits/$rabbitId/move-cage';
  static String breedingDetails(String breedingId) => '/breedings/$breedingId';
}
