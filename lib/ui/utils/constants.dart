const String serverUrl = 'http://192.168.1.198:8000/';
//const String serverUrl = 'http://localhost:8000/';
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

// espace entre les widgets
const double space = 20;

const double sbInputRadius = 20;

const String priceSymbol = "F CFA";