
enum affiliateStatus {
  wait,
  processing,
  accepted,
  denied,
  warned,
}

Map<affiliateStatus,String> mapStAffiliateStatus = {
  affiliateStatus.wait : 'wait',
  affiliateStatus.processing : 'processing',
  affiliateStatus.accepted : 'accepted',
  affiliateStatus.denied : 'denied',
  affiliateStatus.warned : 'warned',
};

Map<String,List<String>> getDataCountries(){
  Map<String,List<String>> dataInfoCodigoMarcado = {};
  dataInfoCodigoMarcado[''] = ["","","","",""];
  dataInfoCodigoMarcado['ARG'] = ["Argentina","+54","14","10","11"];
  dataInfoCodigoMarcado['CHL'] = ["Chile","+56","50","8","9"];
  dataInfoCodigoMarcado['COL'] = ["Colombia","+57","54","10","10"];
  dataInfoCodigoMarcado['CRI'] = ["Costa Rica","+506","59","8","8"];
  dataInfoCodigoMarcado['CUB'] = ["Cuba","+53","1","8","8"];
  dataInfoCodigoMarcado['ECU'] = ["Ecuador","+593","70","9","10"];
  dataInfoCodigoMarcado['USA'] = ["Estados Unidos","+1","237","10","10"];
  dataInfoCodigoMarcado['ESP'] = ["España","+34","210","9","9"];
  dataInfoCodigoMarcado['GTM'] = ["Guatemala","+502","96","8","8"];
  dataInfoCodigoMarcado['HND'] = ["Honduras","+504","101","8","8"];
  dataInfoCodigoMarcado['MEX'] = ["México","+52","153","10","10"];
  dataInfoCodigoMarcado['PER'] = ["Perú","+51","186","9","9"];
  dataInfoCodigoMarcado['VEN'] = ["Venezuela","+58","241","10","10"];
  return dataInfoCodigoMarcado;
}