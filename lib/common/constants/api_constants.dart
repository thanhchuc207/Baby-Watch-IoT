/// [APIConstants] file contains the variables default a path in url
/// to request API.
class APIConstants {
  APIConstants._();

  // Auth API
  static const String pathLogin = "/auth-service/api/auth/login";
  static const String pathSignUp = "/auth-service/api/auth/signup";
  static const String pathExternalLogin =
      "/auth-service/api/auth/external-login";
  static const String pathForgotPassword =
      "/auth-service/api/auth/forgot-password";
  static const String pathResetPassword =
      "/auth-service/api/auth/reset-password";
  static const String pathValidateOTP = "/auth-service/api/auth/validate-otp";
  static const String pathRefreshToken = "/auth-service/api/auth/refresh-token";
  static const String pathChangePassword = "/auth-service/api/account/password";
  static const String deleteAccountVerification =
      "/auth-service/api/account/delete-account-verification";
  static const String deleteAccount = "/auth-service/api/account";

  // User API
  static const String pathGetProfile = "/user-service/api/users/me";
  static const String pathUpdateProfile = "/user-service/api/users/me/profile";

  // Course API
  static const String pathGetCategory = "/course-service/api/categories";
  static const String pathGetCategoryDetail = "/course-service/api/categories";
  static const String pathGetPopularCourse =
      "/course-service/api/public-courses/popular";
  static const String pathGetRecommendCourse =
      "/course-service/api/public-courses/recommendation";
  static const String studentCourses =
      "/course-service/api/student-course-management/courses";
}
