const Map<DOMAIN_TYPE, String> liveDomain = {
  DOMAIN_TYPE.MAIN: "https://fft.camdvr.org/smartcity/api/",
};

const Map<DOMAIN_TYPE, String> uatDomain = {
  DOMAIN_TYPE.MAIN: "https://fft.camdvr.org/smartcity/api/",
};

const Map<DOMAIN_TYPE, String> devDomain = {
  DOMAIN_TYPE.MAIN: "https://fft.camdvr.org/smartcity/api/",
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
  NONE
}

const Map<SERVICE_TYPE, String> SERVICE = {
  SERVICE_TYPE.AUTHEN: "auth",
  SERVICE_TYPE.SETTING: "settings",
  SERVICE_TYPE.USER: "users",
  SERVICE_TYPE.MAP: "map",
  SERVICE_TYPE.NOTIFICATION:"notification",
  SERVICE_TYPE.NONE: "",
};
