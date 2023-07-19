//const String serverUrl = 'http://192.168.1.198:8000/';
const String serverUrl = 'http://localhost:8000/';
//const String serverUrl = 'https://smartbox.fasobizness.com/';
const String baseUrl = '${serverUrl}api/';
const String mediaUrl = '${serverUrl}storage/';
const String jwtKey = 'rBDsbikDxRIlKEyvmW9wDpndJoM1Ieov8jH0zive';

//Hive all boxes name
const String authBox = "auth";

//authBox keys
const String isLoginKey = "isLogin";
const String jwtTokenKey = "jwtToken";

//api end points
const String loginUrl = "${baseUrl}login";
const String registerUrl = "${baseUrl}register";
const String updatePasswordUrl = "${baseUrl}change-password";
const String updateUserUrl = "${baseUrl}me/update";
const String categoriesUrl = "${baseUrl}categories";
const String boxesInCategoryUrl = "${baseUrl}boxes-in-category";
const String saveOrderUrl = "${baseUrl}save-order";
const String savePaymentUrl = "${baseUrl}save-payment";
const String settingsUrl = "${baseUrl}settings";
const String sectionUrl = "${baseUrl}sections";
const String checkNumberUrl = "${baseUrl}check-number";
const String confirmedOrderUrl = "${baseUrl}confirmed-order";
const String reserveOrderUrl = "${baseUrl}reserve-order";
const String savedOrderUrl = "${baseUrl}saved-box-order";
const String addFavoriteUrl = "${baseUrl}add-favorite";
const String favoritesdUrl = "${baseUrl}favorites";
const String searchBoxUrl = "${baseUrl}search-box";
const String resetEmailUrl = "${baseUrl}password/email";
const String checkCodeUrl = "${baseUrl}password/code/check";
const String passwordResetUrl = "${baseUrl}password/reset";

// espace entre les widgets
const double space = 20;

const double sbInputRadius = 14;

const String priceSymbol = "F CFA";

const String showOnBoarding = "showHome";