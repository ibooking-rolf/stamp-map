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
      if(longitude !== null && latitude !== null) {
        // new mapboxgl.Marker().setLngLat([longitude, latitude]).addTo(map);
      }
    });
    
  },
};

export default MapHook;
