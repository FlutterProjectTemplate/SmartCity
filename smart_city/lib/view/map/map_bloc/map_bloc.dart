import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent,MapState>{
  MapBloc():super(const MapState()){
    on<NormalMapEvent>((event, emit) {
      emit(state.copyWith(mapType: MapType.normal));
    });

    on<SatelliteMapEvent>((event, emit) {
      emit(state.copyWith(mapType: MapType.satellite));
    });

    on<HybridMapEvent>((event, emit) {
      emit(state.copyWith(mapType: MapType.hybrid));
    });

    on<TerrainMapEvent>((event, emit) {
      emit(state.copyWith(mapType: MapType.terrain));
    });

  }


}