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
