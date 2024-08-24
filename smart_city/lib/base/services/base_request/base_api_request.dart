import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_city/controller/helper/user_helper.dart';
import 'package:smart_city/model/user/user_info.dart';
// import 'package:smart_city/generated/l10n.dart';
import 'package:smart_city/base/sqlite_manager/sqlite_manager.dart';
import 'package:http/http.dart' as http;
import 'package:smart_city/base/utlis/file_utlis.dart';
import 'base_response_api.dart';
import 'dio_client.dart';
import 'internet_checker_handler.dart';
import 'models/response_error_objects.dart';
import 'domain.dart';

export 'package:smart_city/base/services/base_request/api_name.dart';

class BaseApiRequest {
  Map<String, dynamic>? paramsAdd = HashMap(); // Is a HashMap
  Map<String, dynamic>? requestHeader = HashMap(); // Is a HashMap
  Map<String, dynamic>? requestBody = HashMap(); // Is a HashMap
  Map<String, dynamic>? paramsBase = HashMap(); // Is a HashMap
  Map<String, dynamic>? paramsFinalMap = HashMap(); // Is a HashMap
  String apiName = "";
  String apiPathVariable ="";
  EVIROMENT_DOMAIN? environmentDomain = EVIROMENT_DOMAIN.LIVE_DOMAIN;
  DOMAIN_TYPE? domainType = DOMAIN_TYPE.MAIN;
  SERVICE_TYPE serviceType = SERVICE_TYPE.AUTHEN;
  bool? isShowErrorPopup;
  bool? isCheckToken;
  static const int timeout = 60;
  BaseApiRequest({
    this.environmentDomain,
    this.domainType,
    required this.serviceType,
    required this.apiName,
    this.paramsAdd,
    this.requestHeader,
    this.requestBody,
    this.isShowErrorPopup,
    this.isCheckToken
  }
      ) {
    environmentDomain??= EVIROMENT_DOMAIN.LIVE_DOMAIN;
    domainType ??=DOMAIN_TYPE.MAIN;
    paramsAdd ??=HashMap();
    requestBody ??=HashMap();
    requestHeader ??=HashMap();
    requestHeader!["Content-Type"] = "application/json";
    isShowErrorPopup??=true;
  }

  void setDomainType(DOMAIN_TYPE inputDomainType) {
    domainType = inputDomainType;
  }

  Future<DOMAIN_TYPE?> getDomainType() async {
    return domainType;
  }

  void setServiceType(SERVICE_TYPE inputServiceType) {
    serviceType = inputServiceType;
  }

  SERVICE_TYPE? getServiceType() {
    return serviceType;
  }

  void setEnvironmentDomain(EVIROMENT_DOMAIN inputEnvironmentDomain) {
    environmentDomain = inputEnvironmentDomain;
  }

  EVIROMENT_DOMAIN? getEnvironmentDomain() {
    return environmentDomain;
  }

  Future<String> getDomainStr() async {
    Map<DOMAIN_TYPE, String> domainMapByDomainType = DOMAIN_FINAL[getEnvironmentDomain()]!;
    DOMAIN_TYPE? domainType = await getDomainType();
    String domainFinal = domainMapByDomainType[domainType??DOMAIN_TYPE.MAIN]!;
    return domainFinal;
  }

  String getServiceStr() {
    String domainFinal = SERVICE[getServiceType()]!;
    return domainFinal;
  }

  String getAPINameStr() {
    return apiName;
  }

  Future<void> setAPIName(String? apiName) async {
    if (apiName!.isNotEmpty) this.apiName = apiName;
  }

  Future<void> setParamsAdd(Map<String, dynamic> paramsAdd) async {
    this.paramsAdd!.addAll(paramsAdd);
  }

  Future<void> setHeaderAdd(Map<String, dynamic> headersAdd) async {

    requestHeader!.addAll(headersAdd);
  }
  Future<void> setPathVariAble(Map<String, dynamic> apiPathVariable) async {

    if(apiPathVariable.isEmpty) {
      return;
    }
    for(var value in apiPathVariable.values)
    {
      this.apiPathVariable+=("/${value.toString()}");
    }
  }

  Future<Map<String, dynamic>> getHeaderAdd() async {
    UserInfo? userInfo = await SqliteManager.getInstance.getCurrentSelectUserInfo();
    bool containAuthenticationParams = requestHeader!.keys.contains("Authorization");
    if(!containAuthenticationParams && userInfo!=null)
    {
      requestHeader!.addAll({"Authorization":userInfo.token});
    }
    if(!(isCheckToken??true))
    {
      requestHeader!.remove("Authorization");
    }
    return requestHeader!;
  }

  Future<Map<String, dynamic>> getParamsAdd() async {
    return paramsAdd!;
  }

  Future<Map<String, dynamic>> getBodyAdd() async {
    return requestBody!;
  }

  Future<void> setParamsBase() async {}
  Future<Map<String, dynamic>> getParamsBase() async {
    return paramsBase!;
  }

  Future<Map<String, dynamic>> getParamsFinal() async {
    paramsFinalMap!.addEntries((await getParamsBase()).entries);
    Map<String, dynamic> paramsAdd = await getParamsAdd();
    paramsFinalMap!.addEntries(paramsAdd.entries);
    return paramsFinalMap!;
  }

  Future<String> getParamsFinalStr() async {
    String paramsFinalStr = "";
    //add base params
    Map<String, dynamic> paramsBase = await getParamsBase();

    for (int index = 0; index < paramsBase.length; index++) {
      if (index == 0) {
        paramsFinalStr += "?${paramsBase.entries.elementAt(index).key}";
      } else {
        paramsFinalStr += "&${paramsBase.entries.elementAt(index).key}";
      }
      paramsFinalStr += "=${paramsBase.entries.elementAt(index).value}";
    }
    // add paramsAdd
    Map<String, dynamic> paramsFinal = await getParamsFinal();

    for (int index = 0; index < paramsFinal.length; index++) {
      if (paramsFinalStr.isEmpty) {
        paramsFinalStr += "?${paramsFinal.entries.elementAt(index).key}";
      } else {
        paramsFinalStr += "&${paramsFinal.entries.elementAt(index).key}";
      }
      paramsFinalStr += "=${paramsFinal.entries.elementAt(index).value}";
    }
    return paramsFinalStr;
  }

  Future<String> getFullUrl() async {
    String url = "";
    url += await getDomainStr();
    url += getServiceStr();
    url += getAPINameStr();
    url += apiPathVariable;
    return url;
  }

  Future<void> setApiBody(Map<String, dynamic> bodyAdd) async {
    requestBody!.addAll(bodyAdd);
  }
  Future<dynamic> postRequestAPI() async {
    bool isConnectInternet = await InternetCheckerHandler.getInstance.checkConnectionInternet();
    if(!isConnectInternet){
      return null;
    }
    return await requestPostWithDio();
  }

  Future<dynamic> getRequestAPI() async {
    bool isConnectInternet = await InternetCheckerHandler.getInstance.checkConnectionInternet();
    if(!isConnectInternet){
      return null;
    }
    return await requestGetWithDio();
  }
  Future<dynamic> putRequestAPI() async {
    bool isConnectInternet = await InternetCheckerHandler.getInstance.checkConnectionInternet();
    if(!isConnectInternet){
      return null;
    }
    return await requestPutWithDio();
  }
  Future<dynamic> deleteRequestAPI() async {
    bool isConnectInternet = await InternetCheckerHandler.getInstance.checkConnectionInternet();
    if(!isConnectInternet){
      return null;
    }
    return await requestDeleteWithDio();
  }


  Future<dynamic> requestPostWithHttps() async {
    var requestBodyObj = json.encode(requestBody!);
    String url = await getFullUrl();
    try{
      var response = await http.post(
        Uri.parse(url),
        body: requestBodyObj,
        headers: requestHeader!.map((key, value) => MapEntry(key, value.toString())),
      );
      return await handleResponse(response: response, url: url, option: Options(headers: requestHeader));
    }
    catch(e){
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }
  Future<dynamic> requestGetWithHttps() async {
    String url = await getFullUrl();
    try{
      var response = await http.get(
        Uri.parse(url),
        headers: requestHeader!.map((key, value) => MapEntry(key, value.toString())),
      );
      return await handleResponse(response: response, url: url, option: Options(headers: requestHeader));
    }
    catch(e){
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }
  Future<dynamic> requestDeleteWithHttps() async {
    String url = await getFullUrl();
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: requestHeader!.map((key, value) =>
            MapEntry(key, value.toString())),
      );
      return await handleResponse(response: response, url: url, option: Options(headers: requestHeader));
    }
    catch(e){
      FileUtils.printLog(' \n error: $e \n\n');
    }
  }
  Future<dynamic> requestPutWithHttps() async {
    String url = await getFullUrl();
    try{
      var response = await http.put(
        Uri.parse(url),
        headers: requestHeader!.map((key, value) => MapEntry(key, value.toString())),
      );
      return await handleResponse(response: response, url: url, option: Options(headers: requestHeader));
    }
    catch(e){
      handleResponse(response: e, url: url);
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }

  Future<dynamic> requestPostWithDio() async {
    String url = await getFullUrl();
    Map<String, dynamic> params = await getParamsFinal();
    Map<String, dynamic> body = await getBodyAdd();
    try{
      var option = Options(
        headers: await getHeaderAdd(),
        sendTimeout: const Duration(seconds: timeout), // 30 seconds
        receiveTimeout: const Duration(seconds: timeout),
        validateStatus: (_) => true,);
      Response response = await DioClient().getDioClient().post(url, queryParameters: params, data: body, options: option);
      return await handleResponse(response: response, url: url, option: option, params: params, body: body);
    }
    catch(e){
      handleResponse(response: e, url: url,params: params, body: body);
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }

  Future<dynamic> requestGetWithDio() async {
    String url = await getFullUrl();
    Map<String, dynamic> params =  await getParamsFinal();

    DioClient().getDioClient().options = DioClient().getDioClient().options.copyWith(headers: await getHeaderAdd(), validateStatus: (_) => true,);
    try{
      var option = Options(
        headers: await getHeaderAdd(),
        validateStatus: (_) => true,
        receiveDataWhenStatusError: true,
        sendTimeout: const Duration(seconds: timeout), // 30 seconds
        receiveTimeout: const Duration(seconds: timeout), // 3);
      );

      Response response = await DioClient().getDioClient().get(url, queryParameters: params, options: option);
      return await handleResponse(response: response, url: url, params: params);
    }
    catch(e){
      handleResponse(response: e, url: url,params: params,);

      FileUtils.printLog(' \n error: $e \n\n');
    }


  }

  Future<dynamic> requestDeleteWithDio() async {
    String url = await getFullUrl();
    Map<String, dynamic> params =  await getParamsFinal();
    DioClient().getDioClient().options = DioClient().getDioClient().options.copyWith(headers: await getHeaderAdd(), validateStatus: (_) => true,);
    try{
      var option = Options(
        headers: await getHeaderAdd(),
        validateStatus: (_) => true,
        receiveDataWhenStatusError: true,
        sendTimeout: const Duration(seconds: timeout), // 30 seconds
        receiveTimeout: const Duration(seconds: timeout), // 3);
      );

      Response response = await DioClient().getDioClient().delete(url, queryParameters: params, options: option);
       return await handleResponse(response: response, url: url, params: params);
    }
    catch(e){
      handleResponse(response: e, url: url,params: params);
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }

  Future<dynamic> requestPutWithDio() async {
    String url = await getFullUrl();
    Map<String, dynamic> params =  await getParamsFinal();
    Map<String, dynamic> body = await getBodyAdd();
    DioClient().getDioClient().options = DioClient().getDioClient().options.copyWith(headers: await getHeaderAdd(), validateStatus: (_) => true,);
    try{
      var option = Options(
        headers: await getHeaderAdd(),
        validateStatus: (_) => true,
        receiveDataWhenStatusError: true,
        sendTimeout: const Duration(seconds: timeout), // 30 seconds
        receiveTimeout: const Duration(seconds: timeout), // 3);
      );
      Response response =  await DioClient().getDioClient().put(url, queryParameters: params, data: body,options: option);
      return await handleResponse(response: response, url: url, params: params);
    }
    catch(e){
      handleResponse(response: e, url: url,params: params, body: body);
      FileUtils.printLog(' \n error: $e \n\n');
    }

  }

  Future<dynamic> handleResponse(
      {
        required var response,
        required String url,
        Options? option,
        Map<String, dynamic> params =const {},
        dynamic body=const{}
      }) async {
    if(response.runtimeType == DioException)
    {
      handleDioExceptionError(error: response);
      return;
    }
    try {
      FileUtils.printLog(
          ' url: $url, '
              '\n headers:${option!=null?option.headers:""},'
              '\n params:$params,'
              '\n requestBody:$body,'
              ' \n ressponse: $response \n\n');
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> responseBody = response.data;
        ResponseCommon responseCommon = ResponseCommon(
            datetime: responseBody["datetime"],
            data: responseBody["data"],
            errorCode: responseBody["errorCode"],
            message: responseBody["message"],
            success: responseBody["success"]

        );
        if(!responseBody.containsKey("data")) /// truong hop repponse tra ve khong dung dinh dang chung
        {
          ResponseCommon responseCommon = ResponseCommon(
              datetime: null,
              data: responseBody,
              errorCode: null,
              message: null,
              success: null
          );
          return responseCommon;
        }
        if(responseBody["errorCode"]!= "200") /// data tra ve la loi
        {

          handleDataError(responseBody);
          return responseCommon;
        }
        BaseAPIResponse baseAPIResponse = BaseAPIResponse.fromJson(responseBody);
        //ToastUtils.showToastSuccess(baseAPIResponse.message??"", position: ToastGravity.TOP );
        await onRequestSuccess(baseAPIResponse.result);
        return baseAPIResponse.result!;
      }
      else if (response.statusCode == 401 || response.statusCode == 403)// qua han token
          {
        SqliteManager.getInstance.deleteCurrentLoginUserInfo();
        return ResponseCommon(
            errorCode: response.statusCode,
            message: response.statusMessage,
            success: false,
            data:  null
        );
      }
      else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        // TODO: Add loading information animation
        FileUtils.printLog(
            ' errorUrl: $url, '
                '\n headers:${option!=null?option.headers:""},'
                '\n params:$params,'
                '\n requestBody:$body,'
                ' \n ressponse: $response \n\n');
        if(response.data!=null && response.data!='' && response.data["message"]!=null) {
          response.statusMessage= response.data["message"];
        }
        await onRequestError(response.statusCode, response.statusMessage);
        return ResponseCommon(
            errorCode: response.statusCode.toString(),
            message: response.statusMessage,
            success: false,
            data:  null
        );
      }
    } catch (e) {
      // TODO: Add loading information
      FileUtils.printLog(
          ' errorUrl: $url, '
              '\n headers:${option!=null?option.headers:""},'
              '\n params:$params,'
              '\n requestBody:$body,'
              ' \n error: $e \n\n');
      if(e.runtimeType == DioException)
      {
        DioException error = e as DioException;
        handleDioExceptionError(error:error );
        return ResponseCommon(
            errorCode: "",
            message: response.statusMessage,
            success: false,
            data:  null
        );
      }
    }
  }

  Future<void> onRequestSuccess(var data) async{}
  Future<void> onRequestError(int? statusCode, String? statusMessage) async{
    onShowError(statusCode, statusMessage);
  }
  Future<void> onShowError(int? statusCode, String? statusMessage) async{
    if(statusMessage==null) {
      return;
    }
    //TODO : show toast
    //ToastUtils.showToastError(statusMessage, position: ToastGravity.BOTTOM );
  }

  Future<void> handleDioExceptionError({Response? response,DioException? error}) async {
    ResponseCommon? responseErrorCommon;
    if(error!=null )
    {
      if(error.response!=null)
      {
        responseErrorCommon = ResponseCommon.fromJson(error.response!.data!);
        if(error.response!.statusCode !=null && (error.response!.statusCode ==401 ||error.response!.statusCode ==403 )  )
        {
          UserInfo? currentUserInfo = await SqliteManager.getInstance.getCurrentSelectUserInfo();
          currentUserInfo!.token = "";
          currentUserInfo.expiredAt = "";
          // TODO: save user info
          await UserHelper().saveCurrentUserInfo(currentUserInfo);
          //         AppPages.route(Routes.loginRoute, isReplace: true);
        }
      }
      else
      {
        handlerDioExceptionType(error.type);
      }

    }
    else if(response!=null)
    {
      try{
        responseErrorCommon = ResponseCommon.fromJson(response.data!);
      }
      catch(e){
        responseErrorCommon = null;
      }
    }

    if(responseErrorCommon!=null)
    {
      if(isShowErrorPopup!){
        //TODO: show dialog
      }
      await onRequestError(int.tryParse(responseErrorCommon.errorCode??"",), responseErrorCommon.message??"");
    }
  }
  void handlerDioExceptionType(DioExceptionType type){
    //String message= S.of(InstanceManager().navigatorKey.currentContext!).no_internet;
    switch (type)
    {
      case DioExceptionType.connectionTimeout:
      // TODO: Handle this case.
      case DioExceptionType.sendTimeout:
      // TODO: Handle this case.
      case DioExceptionType.receiveTimeout:
      // TODO: Handle this case.
        {
          //message= S.of(InstanceManager().navigatorKey.currentContext!).time_out_connection;
        }
        break;
      case DioExceptionType.connectionError:
      // TODO: Handle this case.
        {
          //message= S.of(InstanceManager().navigatorKey.currentContext!).not_connect_to_server;
        }
        break;
      case DioExceptionType.badCertificate:
      // TODO: Handle this case.
      case DioExceptionType.badResponse:
      // TODO: Handle this case.
      case DioExceptionType.cancel:
      // TODO: Handle this case.
      case DioExceptionType.unknown:
      // TODO: Handle this case.
        {
          //message= S.of(InstanceManager().navigatorKey.currentContext!).notify_error;
        }
        break;
    }
    //TODO: show dialog
    //NotifyDialog.showDialogOneButton(description: message);

  }
  Future<void> handleDataError(dynamic data) async {
    ResponseCommon requestResponseErrorModel = ResponseCommon.fromJson(data);
    if(isShowErrorPopup!){
      // TODO : show dialog
      // NotifyDialog.showDialogOneButton(description: requestResponseErrorModel.message);
    }

    await onRequestError(int.tryParse(requestResponseErrorModel.errorCode!,), requestResponseErrorModel.message);
  }
}
