import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rutasapp/bloc/mapa/mapa_bloc.dart';
import 'package:rutasapp/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:rutasapp/widgets/widgets.dart';


class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  @override
  void initState() { 
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() { 
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (context, state) => crearMapa(state)
          ),

          Positioned(
            top: 15,
            child: SearchBar()
          ),

        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          BtnUbicacion(),
          BtnSeguirUbicacion(),
          BtnMiRuta(),

        ],
      ),
   );
  }

  Widget crearMapa( MiUbicacionState state ) {

    if( !state.existeUbicacion ) return Center(child: Text('Ubicando...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add( OnNuevaUbicacion( state.ubicacion ) );

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15,
    );

    return GoogleMap(
      initialCameraPosition: cameraPosition,
      // compassEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: mapaBloc.initMapa,
      polylines: mapaBloc.state.polylines.values.toSet(),
      onCameraMove: (cameraPosition) {
        // cameraPosition.target = LatLng central del mapa
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },
      onCameraIdle: () {
        // print('MapaIdle');
      },
    );


  }





}