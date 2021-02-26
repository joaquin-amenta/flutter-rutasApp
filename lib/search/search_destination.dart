import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import 'package:rutasapp/models/search_response.dart';
import 'package:rutasapp/models/search_result.dart';
import 'package:rutasapp/services/traffic_service.dart';



class SearchDestination extends SearchDelegate<SearchResult> {

  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestination( this.proximidad, this.historial )
    : this.searchFieldLabel = 'Buscar',
      this._trafficService = new TrafficService();


  @override
  List<Widget> buildActions(BuildContext context) {

    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () => this.query = '',
      )
    ];

    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon( Icons.arrow_back ),
        onPressed: () => this.close(context, SearchResult(cancelo: true) ),
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      
      return this._construirResultadosSugerencias();
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {

      if( this.query.length == 0 ){
        return ListView(
          children: [

            ListTile(
              leading: Icon( Icons.location_on ),
              title: Text('Ingresar ubicacion con mapa'),
              onTap: (){
                // TODO: Retornar algo
                this.close(context, SearchResult( cancelo: false, manual: true ));
              },
            ),

            ...this.historial.map(
              (result) => ListTile(
                leading: Icon(Icons.history),
                title: Text( result.nombreDestino ),
                subtitle: Text( result.descripcion ),
                onTap: () {
                  this.close( context, result);
                },
              )
            ).toList()

          ],
        );
      }else{
        return this._construirResultadosSugerencias();
      }


      
    }

  Widget _construirResultadosSugerencias() {

    if( this.query == '' ) {
      return Container();
    }

    this._trafficService.getSugerenciasPorQuery( this.query.trim(), proximidad );
    
    return StreamBuilder(
      stream: this._trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {

        if( !snapshot.hasData ){
          return Center(child: CircularProgressIndicator());
        }

        final lugares = snapshot.data.features;

        if( lugares.length == 0 ){
          return ListTile(
            title: Text('No hay resultados con $query'),
          );
        }

        return ListView.separated(
          itemCount: lugares.length,
          separatorBuilder: (_, i) => Divider(),
          itemBuilder: ( _, i ){
            final lugar = lugares[i];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text( lugar.textEs ),
              subtitle: Text( lugar.placeNameEs ),
              onTap: () {
                
                this.close( context, SearchResult(
                  cancelo: false,
                  manual: false,
                  position: LatLng( lugar.center[1] ,lugar.center[0]),
                  nombreDestino: lugar.textEs,
                  descripcion: lugar.placeNameEs
                ));

              },
            );
          },
        );
      },
    );

  }


}