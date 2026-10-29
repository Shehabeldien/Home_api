class ApiConstants {
  // غيّر دي لقيمة {{baseUrl}} اللي في Postman
  // Android Emulator + سيرفر على جهازك: استخدم 10.0.2.2 بدل localhost
  static const String baseUrl =
      "https://ecommerce-5rfssu72u-ahmed-allams-projects-14fb3aa3.vercel.app";

  static const String categories = "/categories";
  static String categoryById(int id) => "/categories/$id";
}
