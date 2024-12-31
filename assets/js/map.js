import mapboxgl from 'mapbox-gl';

// esbuild will create a CSS bundle we can include in the page
import "mapbox-gl/dist/mapbox-gl.css"

// mapboxgl.accessToken = '';
const map = new mapboxgl.Map({
    container: 'map', // container ID
    style: 'mapbox://styles/mapbox/streets-v12', // style URL
    center: [139.71, 35.64], // starting position [lng, lat]
    zoom: 12, // starting zoom
});

const popup = new mapboxgl.Popup({ closeOnClick: false })
    .setLngLat([139.71, 35.64])
    .setHTML('<h1 class="text-lg">Hello From Phoenix!</h1>')
    .addTo(map);

// Add zoom and rotation controls to the map.
map.addControl(new mapboxgl.NavigationControl());