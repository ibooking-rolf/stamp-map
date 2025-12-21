import mapboxgl from "mapbox-gl";

const MapHook = {
  mounted() {
    mapboxgl.accessToken = this.el.dataset.accessToken;

    const map = new mapboxgl.Map({
      container: this.el.id,
      zoom: 12,
      center: [10.3566333, 63.4340182], // [lng, lat]
      // Vintage
      // style: 'mapbox://styles/resa911/cmj91wlg2003f01s966xsdu1z',
    });

    var newMarker;

    this.handleEvent("add-marker", ({ longitude, latitude }) => {
      if(longitude !== null && latitude !== null) {
        // new mapboxgl.Marker().setLngLat([longitude, latitude]).addTo(map);
      }
    });
    
    this.handleEvent("add-stamp", (_) => {
      const {lng, lat} = map.getCenter();
      newMarker = new mapboxgl.Marker({
        draggable: true
      }).setLngLat([lng, lat]).addTo(map);

      this.pushEvent("update-stamp-location", {"new_lng_lat": newMarker.getLngLat()});

      newMarker.on('dragend', ({_, target}) => {
        this.pushEvent("update-stamp-location", {"new_lng_lat": target.getLngLat()});
      });
    });

    this.handleEvent("new_stamp_reset", (_) => {
      newMarker.remove();
      newMarker = null;
    })
  },
};

export default MapHook;
