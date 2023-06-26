const String baseUrl = 'http://localhost:8000/api/';
const String jwtKey = 'rBDsbikDxRIlKEyvmW9wDpndJoM1Ieov8jH0zive';

//Hive all boxes name
const String authBox = "auth";

//authBox keys
const String isLoginKey = "isLogin";
const String jwtTokenKey = "jwtToken";

//api end points
const String loginUrl = "${baseUrl}login";
const String registerUrl = "${baseUrl}register";
const String rideRequestUrl = "${baseUrl}ride-request";