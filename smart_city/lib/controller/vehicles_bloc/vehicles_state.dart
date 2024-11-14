part of 'vehicles_bloc.dart';

enum VehicleType {
  car,
  motorbike,
  bicycle,
  truck,
  bus,
  train,
  subway,
  tram,
  ambulance,
  fireTruck,
  militaryVehicle,
  armoredCar,
  tractor,
  agriculturalVehicle,
  pedestrian,
  officialVehicle,
}

extension VehicleTypeExtension on VehicleType {
  String get code {
    switch (this) {
      case VehicleType.car:
        return "CAR";
      case VehicleType.motorbike:
        return "MOTORBIKE";
      case VehicleType.bicycle:
        return "BICYCLE";
      case VehicleType.truck:
        return "TRUCK";
      case VehicleType.bus:
        return "BUS";
      case VehicleType.train:
        return "TRAIN";
      case VehicleType.subway:
        return "SUBWAY";
      case VehicleType.tram:
        return "TRAM";
      case VehicleType.ambulance:
        return "AMBULANCE";
      case VehicleType.fireTruck:
        return "FIRE_TRUCK";
      case VehicleType.militaryVehicle:
        return "MILITARY_VEHICLE";
      case VehicleType.armoredCar:
        return "ARMORED_CAR";
      case VehicleType.tractor:
        return "TRACTOR";
      case VehicleType.agriculturalVehicle:
        return "AGRICULTURAL_VEHICLE";
      case VehicleType.pedestrian:
        return "PEDESTRIAN";
      case VehicleType.officialVehicle:
        return "OFFICAL_VEHICLE";
    }
  }

  static int getVehicleId(VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return 1;
      case VehicleType.motorbike:
        return 2;
      case VehicleType.bicycle:
        return 3;
      case VehicleType.truck:
        return 4;
      case VehicleType.bus:
        return 5;
      case VehicleType.train:
        return 6;
      case VehicleType.subway:
        return 7;
      case VehicleType.tram:
        return 8;
      case VehicleType.ambulance:
        return 9;
      case VehicleType.fireTruck:
        return 10;
      case VehicleType.militaryVehicle:
        return 11;
      case VehicleType.armoredCar:
        return 12;
      case VehicleType.tractor:
        return 13;
      case VehicleType.agriculturalVehicle:
        return 14;
      case VehicleType.pedestrian:
        return 15;
      case VehicleType.officialVehicle:
        return 16;
      default:
        return 1;
    }
  }

  static VehicleType? getVehicleType(int type) {
    switch (type) {
      case 1:
        return VehicleType.car;
      case 15:
        return VehicleType.pedestrian;
      case 4:
        return VehicleType.truck;
      case 16:
        return VehicleType.officialVehicle;
      case 10:
        return VehicleType.fireTruck;
      case 5:
        return VehicleType.bus;
      case 3:
        return VehicleType.bicycle;
      case 9:
        return VehicleType.ambulance;
      default:
        return ResponsiveInfo.isTablet() ? VehicleType.car  : VehicleType.pedestrian;
    }
  }

  static VehicleType? fromCode(String code) {
    return VehicleType.values.firstWhere(
          (e) => e.code == code,
      orElse: () => VehicleType.pedestrian,
    );
  }
}



class VehiclesState extends Equatable {
  final VehicleType vehicleType;

  const VehiclesState({required this.vehicleType});

  @override
  List<Object> get props => [vehicleType];
}
