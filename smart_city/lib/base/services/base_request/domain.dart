const Map<DOMAIN_TYPE, String> liveDomain = {
  DOMAIN_TYPE.MAIN: "https://vdetector-api.smartcitysignals.com/api/",
};

const Map<DOMAIN_TYPE, String> uatDomain = {
  DOMAIN_TYPE.MAIN: "https://smctapi.fft.camdvr.org/api/",
};

const Map<DOMAIN_TYPE, String> devDomain = {
  DOMAIN_TYPE.MAIN: "https://smctapi.fft.camdvr.org/api/",
};

const Map<EVIROMENT_DOMAIN, Map<DOMAIN_TYPE, String>> DOMAIN_FINAL = {
  EVIROMENT_DOMAIN.LIVE_DOMAIN: liveDomain,
  EVIROMENT_DOMAIN.UAT_DOMAIN: uatDomain,
  EVIROMENT_DOMAIN.DEV_DOMAIN: devDomain,
};

enum EVIROMENT_DOMAIN {
  LIVE_DOMAIN,
  UAT_DOMAIN,
  DEV_DOMAIN
}
enum DOMAIN_TYPE {
  MAIN,
  TRANSATION
}

enum SERVICE_TYPE {
  AUTHEN,
  SETTING,
  USER,
  MAP,
  NOTIFICATION,
  NONE,
  NODE,
  NODE_PHASE,
  CUSTOMER,
  VEHICLE_TYPE,
  APPROACH_TYPE,
  VECTOR,
}

const Map<SERVICE_TYPE, String> SERVICE = {
  SERVICE_TYPE.AUTHEN: "auth",
  SERVICE_TYPE.SETTING: "settings",
  SERVICE_TYPE.USER: "users",
  SERVICE_TYPE.MAP: "map",
  SERVICE_TYPE.NOTIFICATION:"notification",
  SERVICE_TYPE.NONE: "",
  SERVICE_TYPE.NODE: "node",
  SERVICE_TYPE.NODE_PHASE: "node_phase",
  SERVICE_TYPE.CUSTOMER: "customer",
  SERVICE_TYPE.VEHICLE_TYPE: "vehicle-type",
  SERVICE_TYPE.VECTOR: "vector",
  SERVICE_TYPE.APPROACH_TYPE: "approach-type"
};
