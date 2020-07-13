import React, { useState, useEffect } from "react";
import { Map, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import "./home.css";
import { MDBRow, MDBCol } from "mdbreact";

const HeatMap = (props) => {
    const [markers, setMarkers] = useState([]);
    // this defines the center of the map at initial load
    const mapCenter = [7.753016, 80.747452];
    const dummyMarkers = [
        {
            position: [7.753016, 80.747452],
            content: "this is teh center",
        },
    ];
    useEffect(() => {
        setMarkers(dummyMarkers);
    }, []);
    console.log(markers);

    return (
        <div>
            <MDBRow>
                <MDBCol>
                    <Map className="heat-map" center={mapCenter} zoom={8}>
                        <TileLayer
                            attribution='&amp;copy <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                        />
                        <MarkersList markers={markers} />
                    </Map>
                </MDBCol>
            </MDBRow>
        </div>
    );
};

const MarkersList = (props) => {
    const markers = props.markers;
    const items = markers.map((marker, key) => {
        if (marker) {
            return (
                <MyPopupMarker
                    key={key}
                    position={marker.position}
                    content={marker.content}
                />
            );
        }
        return null;
    });
    return <React.Fragment>{items}</React.Fragment>;
};

const MyPopupMarker = (props) => {
    const position = props.position;
    const content = props.content;

    return (
        <Marker position={position}>
            <Popup>{content}</Popup>
        </Marker>
    );
};

export default HeatMap;
