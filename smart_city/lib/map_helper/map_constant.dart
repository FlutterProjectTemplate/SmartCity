class MapNameConst {
  MapNameConst._();

  // ========================IMAGE===========================
  // ========================ICON===========================
  // ========================SVG===========================
  // Home page
  static const mapStypeFolder = "map_stype/";
  static const standardNoLandmarksStype = "standard_no_landmarks_stype.json";
  static const disableAlStyle = "disable_all_style.json";
  /*------------------------------------*/

  static String getMapStypeJson({required String name}) {
    return "assets/$mapStypeFolder$name";
  }

}
