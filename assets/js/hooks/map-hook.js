import mapboxgl from "mapbox-gl";

const MapHook = {
  mounted() {
    mapboxgl.accessToken = this.el.dataset.accessToken;

    const map = new mapboxgl.Map({
      container: this.el.id,
      zoom: 12,
      center: [10.3566333, 63.4340182], // [lng, lat]
    });

    this.handleEvent("add-marker", ({ longitude, latitude }) => {
      console.log('long: ', longitude);
      console.log('lat: ', latitude);
      // new mapboxgl.Marker().setLngLat(location).addTo(map);
    });
    
  },
};

export default MapHook;
