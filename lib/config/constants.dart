/// API endpoints and application-wide constants.
class ApiEndpoints {
  static const String departments = '/Department';
  static const String presidents = '/President';
  static const String attractions = '/TouristicAttraction';
  static const String dishes = '/TypicalDish';

  static String departmentDetail(int id) => '/Department/$id';
  static String presidentDetail(int id) => '/President/$id';
  static String attractionDetail(int id) => '/TouristicAttraction/$id';
  static String dishDetail(int id) => '/TypicalDish/$id';
}

class AppRoutes {
  static const String dashboard = '/';
  
  static const String departments = '/departments';
  static const String departmentDetail = '/departments/:id';
  
  static const String presidents = '/presidents';
  static const String presidentDetail = '/presidents/:id';
  
  static const String attractions = '/attractions';
  static const String attractionDetail = '/attractions/:id';
  
  static const String dishes = '/dishes';
  static const String dishDetail = '/dishes/:id';
}
