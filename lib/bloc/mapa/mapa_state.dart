part of 'mapa_bloc.dart';

@immutable
class MapaState {

  final bool mapaListo;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;

  final LatLng ubicacionCentral;

  // Polylines
  final Map<String, Polyline> polylines;

  MapaState({
    this.mapaListo = false,
    this.dibujarRecorrido = false,
    this.seguirUbicacion = false, 
    this.ubicacionCentral,
    Map<String, Polyline> polylines
  }): this.polylines = polylines ?? new Map();


  MapaState copyWith({ bool mapaListo, bool dibujarRecorrido, Map<String, Polyline> polylines, bool seguirUbicacion, LatLng ubicacionCentral }
  ) => MapaState(
    mapaListo: mapaListo ?? this.mapaListo,
    polylines: polylines ?? this.polylines,
    seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
    ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
    dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
  );


}
