import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../feature/data/model/login_request.dart';
import '../../../feature/data/model/auth_user.dart';
import '../../../feature/data/model/products_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://dummyjson.com/")
abstract class ApiClient{
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("auth/login")
  Future<AuthUser> login(@Body() LoginRequest request);

  @GET("products")
  Future<ProductResponse> getProducts({
    @Query("limit") int limit = 10,
    @Query("skip") int skip = 0
  });
}