import React, { useState, useEffect, useRef } from "react";
import Map from '../components/Map';

export default function App() {
  const [userLocation, setUserLocation] = useState({latitude: null, longitude: null})
  const [trucksToDisplay, setTrucksToDisplay] = useState([])
  const [selectedVendor, setSelectedVendor] = useState(null)

  async function getVendors(zip = null) {
    const path = zip ? `location/${zip}` : ""
    try {
      const response = await fetch("http://localhost:4000/api/vendors" + path, {
        headers: {
          Origin: "http://localhost:4000",
          Authorization: "Bearer <put api token here>"
        },
      })
      const jsonResponse = await response.json();
      getRandomTrucks(jsonResponse.data)
    } catch (error) {
      console.log(error)
    }
  }

  function getRandomTrucks(truckArr) {
    const range = [...Array(100).keys()]

    const randomSelection = range.map((x) => {
      const randomNum = Math.floor(Math.random() * truckArr.length)
      return truckArr[randomNum]
    })
    setTrucksToDisplay([...new Set(randomSelection)])
  }

  function getUserPosition() {
    navigator.geolocation.getCurrentPosition((pos) => {
      const newUserPos = {latitude: pos.coords.latitude, longitude: pos.coords.longitude};
      setUserLocation(newUserPos)
    }, (err) => {
      console.log(err);
    });
  }

  useEffect(() => {
    getUserPosition()
    getVendors()
  }, [])

  return (
    <>
      <div className="px-4 py-10 sm:px-6 sm:py-28 lg:px-8 xl:px-8 xl:py-8">
        <div className="home-header">
          <div className="home-header-img">
            <svg xmlns="http://www.w3.org/2000/svg" fill="#50C878" version="1.1" viewBox="4.86 21.41 90.45 73.9">
              <g>
              <path d="m75 62.5h-6.25c-0.86328 0-1.5625 0.69922-1.5625 1.5625s0.69922 1.5625 1.5625 1.5625h6.25c0.86328 0 1.5625-0.69922 1.5625-1.5625s-0.69922-1.5625-1.5625-1.5625z"/>
              <path d="m95.062 61.652-10.625-16.418c-1.2969-1.9258-3.4727-3.0703-5.7969-3.0469h-5.7812c4.6211-0.10547 8.5898-3.3086 9.6641-7.8008l7.0703 0.054687h0.011719v-0.003906c0.089843 0 0.17969-0.007812 0.26953-0.023438 1.2227-0.21094 2.2031-1.125 2.5-2.3281 0.29688-1.207-0.14453-2.4727-1.1328-3.2305-0.13281-0.10156-0.28125-0.18359-0.44141-0.23828l-2.6562-0.91016 0.92969-2.6211h-0.003907c0.058594-0.16016 0.085938-0.33203 0.089844-0.50391 0.019532-1.2422-0.69922-2.375-1.8281-2.8906-1.1328-0.51562-2.4609-0.30859-3.3828 0.51953-0.070313 0.0625-0.13672 0.13281-0.19531 0.20703l-2.8711 3.6953v0.003907c-1.8984-2.6562-4.9609-4.2344-8.2266-4.2422-0.13281 0-0.26562 0.015625-0.39844 0.050781-15.617 4.082-32.023 4.082-47.641 0-0.13281-0.035156-0.26563-0.050781-0.39844-0.050781-3.1406 0.003906-6.0977 1.457-8.0156 3.9453l-2.6562-3.4062c-0.058594-0.074218-0.12109-0.14062-0.19141-0.20312-0.92969-0.83203-2.2617-1.0312-3.3906-0.50781-1.1328 0.51172-1.8438 1.6523-1.8047 2.8945 0.003906 0.16406 0.03125 0.32422 0.085938 0.48047l0.91797 2.6289-2.6406 0.91016c-0.16016 0.054687-0.30859 0.13281-0.44141 0.23828-0.98438 0.75391-1.4297 2.0234-1.1328 3.2266 0.29688 1.207 1.2773 2.1211 2.5039 2.332 0.085937 0.015626 0.17578 0.023438 0.26562 0.023438h0.011719l6.6172-0.050781h0.003906c0.41797 1.7578 1.3008 3.3711 2.5547 4.6758h-5.9688c-2.5898 0-4.6875 2.0977-4.6875 4.6875v40.625c0 0.41406 0.16406 0.8125 0.45703 1.1055s0.69141 0.45703 1.1055 0.45703h10.977c-0.023437 0.25781-0.039062 0.51562-0.039062 0.78125 0 4.7461 3.8477 8.5938 8.5938 8.5938s8.5938-3.8477 8.5938-8.5938c0-0.26562-0.015625-0.52344-0.039062-0.78125h34.453c-0.023437 0.25781-0.039062 0.51562-0.039062 0.78125 0 4.7461 3.8477 8.5938 8.5938 8.5938s8.5938-3.8477 8.5938-8.5938c0-0.26562-0.015625-0.52344-0.039062-0.78125h6.2891c0.41406 0 0.8125-0.16406 1.1055-0.45703s0.45703-0.69141 0.45703-1.1055v-21.875c0-0.30078-0.085938-0.59375-0.25-0.84766zm-13.246-14.727 9.0625 14.012h-7.418l-2.668-2.668c-0.29297-0.29297-0.69141-0.45703-1.1055-0.45703h-14.062v-12.5h13.016c1.2617-0.03125 2.457 0.57812 3.1758 1.6133zm-27.129 21.824h-37.5v-15.625c1.8008-0.003906 3.5117-0.79297 4.6875-2.1602 1.1758 1.3672 2.8867 2.1562 4.6875 2.1602h4.6875c1.8008-0.003906 3.5117-0.79297 4.6875-2.1602 1.1758 1.3672 2.8867 2.1562 4.6875 2.1602h4.6875c1.8008-0.003906 3.5117-0.79297 4.6875-2.1602 1.1758 1.3672 2.8867 2.1562 4.6875 2.1602zm-31.25-26.562h10.938v4.6875c0 0.82812-0.32812 1.625-0.91406 2.2109-0.58594 0.58594-1.3828 0.91406-2.2109 0.91406h-4.6875c-1.7266 0-3.125-1.3984-3.125-3.125zm25 0v4.6875c0 0.82812-0.32812 1.625-0.91406 2.2109-0.58594 0.58594-1.3828 0.91406-2.2109 0.91406h-4.6875c-1.7266 0-3.125-1.3984-3.125-3.125v-4.6875zm6.25 7.8125c-1.7266 0-3.125-1.3984-3.125-3.125v-4.6875h9.375c0.41406 0 0.8125 0.16406 1.1055 0.45703s0.45703 0.69141 0.45703 1.1055v3.125c0 0.82812-0.32812 1.625-0.91406 2.2109-0.58594 0.58594-1.3828 0.91406-2.2109 0.91406zm31.18-25.191-1.1836 3.3438c-0.14062 0.39062-0.11719 0.82422 0.066406 1.1992 0.17969 0.375 0.50391 0.66406 0.89844 0.79688l3.375 1.1562-6.25-0.046876v0.003907c-0.050782-0.67969-0.17188-1.3555-0.35938-2.0117zm-61.84 0.19141c16.008 4.1445 32.812 4.1445 48.82 0 3.8828 0.054688 6.9883 3.2422 6.9375 7.1289-0.054687 3.8828-3.2461 6.9883-7.1289 6.9336-0.13281 0-0.26562 0.015625-0.39844 0.050781-2.6328 0.6875-5.1719 1.2227-7.7305 1.6602h0.003906c-0.88281-1.0781-2.1992-1.707-3.5938-1.7109h-36.719c-3.8828 0.054688-7.0742-3.0508-7.1289-6.9336-0.050782-3.8867 3.0547-7.0742 6.9375-7.1289zm-12.363 5.1562c0.39453-0.13672 0.71875-0.42188 0.89844-0.79688 0.17969-0.37109 0.20703-0.80469 0.070312-1.1953l-1.1641-3.3203 3.125 3.9961c-0.26172 0.78516-0.42578 1.6016-0.48438 2.4297l-5.7969 0.046875zm-0.72656 12.031h9.375v4.6875c0 0.82812-0.32812 1.625-0.91406 2.2109-0.58594 0.58594-1.3828 0.91406-2.2109 0.91406h-4.6875c-1.7266 0-3.125-1.3984-3.125-3.125v-3.125c0-0.86328 0.69922-1.5625 1.5625-1.5625zm16.406 50c-2.2109 0-4.207-1.332-5.0508-3.375-0.84766-2.043-0.37891-4.3984 1.1836-5.9609s3.918-2.0312 5.9609-1.1836c2.043 0.84375 3.375 2.8398 3.375 5.0508 0 1.4492-0.57422 2.8398-1.6016 3.8672-1.0273 1.0273-2.418 1.6016-3.8672 1.6016zm32.031-9.375h-24.387c-1.4609-2.875-4.418-4.6875-7.6445-4.6875s-6.1836 1.8125-7.6445 4.6875h-10.324v-30.555c0.94531 0.5625 2.0234 0.85938 3.125 0.86719h1.5625v15.625h-1.5625c-0.86328 0-1.5625 0.69922-1.5625 1.5625s0.69922 1.5625 1.5625 1.5625h46.875c0.86328 0 1.5625-0.69922 1.5625-1.5625s-0.69922-1.5625-1.5625-1.5625h-1.5625v-15.625h1.5625c1.1016-0.007812 2.1797-0.30469 3.125-0.86719v30.555zm19.531 9.375c-2.2109 0-4.207-1.332-5.0508-3.375-0.84766-2.043-0.37891-4.3984 1.1836-5.9609s3.918-2.0312 5.9609-1.1836c2.043 0.84375 3.375 2.8398 3.375 5.0508 0 1.4492-0.57422 2.8398-1.6016 3.8672-1.0273 1.0273-2.418 1.6016-3.8672 1.6016zm7.8125-9.375c-0.054688 0-0.10156 0.027344-0.15625 0.03125-1.4531-2.8906-4.4102-4.7188-7.6484-4.7266-3.2344-0.003907-6.1992 1.8086-7.6641 4.6953h-5.625v-21.875h13.414l2.668 2.668c0.29297 0.29297 0.69141 0.45703 1.1055 0.45703h9.375v4.6875h-6.25c-0.48047 0-0.9375 0.22266-1.2305 0.60156-0.29688 0.37891-0.40234 0.875-0.28516 1.3398l1.0664 4.2617c0.69141 2.7852 3.1914 4.7383 6.0625 4.7344h0.63672v3.125zm5.4688-6.25h-0.63672c-1.4336 0-2.6836-0.97656-3.0312-2.3672l-0.58203-2.3203h4.25z"/>
              <path d="m57.812 73.438h-1.5625c-0.86328 0-1.5625 0.69922-1.5625 1.5625s0.69922 1.5625 1.5625 1.5625h1.5625c0.86328 0 1.5625-0.69922 1.5625-1.5625s-0.69922-1.5625-1.5625-1.5625z"/>
              <path d="m50 73.438h-6.25c-0.86328 0-1.5625 0.69922-1.5625 1.5625s0.69922 1.5625 1.5625 1.5625h6.25c0.86328 0 1.5625-0.69922 1.5625-1.5625s-0.69922-1.5625-1.5625-1.5625z"/>
              <path d="m23.82 31.199c5.543 1.0391 11.168 1.5781 16.805 1.6133 0.86328 0 1.5625-0.69922 1.5625-1.5625s-0.69922-1.5625-1.5625-1.5625c-5.3711-0.03125-10.727-0.53906-16.008-1.5117-0.82813-0.19922-1.6641 0.30078-1.8789 1.1211-0.21875 0.82422 0.26562 1.668 1.082 1.9023z"/>
              </g>
            </svg>
          </div>
          <h1 className="header mx-4">SF Food Trucks</h1>
        </div>
        <div className="home-centerpiece">
          <div className="cta">
            {selectedVendor ? (
              <div className="vendor-card">
                <div className="vendor-info">
                  <h3>{selectedVendor.name}</h3>
                  <div className="block">{selectedVendor.address}</div>
                  <div className="block">{selectedVendor.days_hours}</div>
                </div>
                <div>
                  {selectedVendor.food_items &&
                    <ul className="block t-2">
                    <p>Items offered:</p>
                      {selectedVendor.food_items.map(item => {
                        return <li className="ml-2">- {item}</li>
                      })}
                    </ul>
                  }
                </div>
              </div>
            ) : (
              <h2 className="bold mb-8">Discover everything SF has to offer</h2>
            )
            }
          </div>
          <Map userLocation={userLocation} trucksToDisplay={trucksToDisplay} selectedVendor={selectedVendor} setVendor={setSelectedVendor} />
        </div>
      </div>
    </>
  )
}
