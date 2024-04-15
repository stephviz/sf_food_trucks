import React, {useRef, useState} from "react";
import GoogleMap from 'google-maps-react-markers'
import { MapPin } from 'lucide-react';

export default function Map({trucksToDisplay, setVendor, selectedVendor}) {
  const mapRef = useRef(null)
  const [mapReady, setMapReady] = useState(false)

  const defaultProps = {
    center: {
      lat: 37.755760,
      lng: -122.445194
    },
    zoom: 12
  };

  const onGoogleApiLoaded = ({ map, maps }) => {
    mapRef.current = map
    setMapReady(true)
  }

  return (
    <>
      <div className='map cursor-pointer'>
        <GoogleMap
          apiKey="<put google api key here>"
          defaultCenter={defaultProps.center}
          defaultZoom={defaultProps.zoom}
          onGoogleApiLoaded={onGoogleApiLoaded}
        >
           {trucksToDisplay && trucksToDisplay.map(t => {
            return (
              <MapPin
                key={t.id}
                lat={t.latitude}
                lng={t.longitude}
                fill="red"
                onClick={() => setVendor(t)}
                style={{position: "relative"}}
                value={t}
              />
            )
          })}
        </GoogleMap>
      </div>
    </>
  )
}
