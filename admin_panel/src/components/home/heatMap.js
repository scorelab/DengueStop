import React, { useState, useEffect } from "react";
import { Map, TileLayer, CircleMarker, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import "./home.css";
import {
    MDBRow,
    MDBCol,
    MDBCardBody,
    MDBCardTitle,
    MDBDropdown,
    MDBDropdownMenu,
    MDBDropdownItem,
    MDBDropdownToggle,
    MDBIcon,
} from "mdbreact";
import Moment from "react-moment";
import IncidentService from "../../services/incidentService";
import CommonService from "../../services/commonService";

const HeatMap = (props) => {
    const incidentService = new IncidentService();
    const commonService = new CommonService();
    const [markers, setMarkers] = useState([]);
    const [provinces, setProvinces] = useState([]);
    const [lastRefresh, setLastRefresh] = useState(Date());
    const [selectedProvince, setSelectedProvince] = useState("all");
    // this defines the center of the map at initial load
    const mapCenter = [7.9, 80.747452];
    useEffect(() => {
        var tempArr = [];
        commonService.getProvinceNames().then((res) => {
            res.forEach((data) => {
                tempArr.push(data);
            });
            setProvinces(tempArr);
        });
    }, []);

    useEffect(() => {
        incidentService.getIncidentMarkers(selectedProvince).then((res) => {
            setMarkers(res);
            setLastRefresh(Date());
        });
    }, [selectedProvince]);

    return (
        <MDBCardBody>
            <MDBRow>
                <MDBCol size="6">
                    <h4>
                        <b>Dengue Heat Map</b>
                    </h4>
                </MDBCol>
                <MDBCol size="6" className="px-1 text-right">
                    <ProvinceList
                        provinces={provinces}
                        setSelectedProvince={setSelectedProvince}
                        selectedProvince={selectedProvince}
                    />
                </MDBCol>
            </MDBRow>
            <div className="mt-1 heat-map-container">
                <MDBRow>
                    <MDBCol>
                        <Map className="heat-map" center={mapCenter} zoom={8}>
                            <TileLayer
                                attribution='&amp;copy <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                            />
                            <MarkersList markers={markers} />
                        </Map>
                        <p className="event-coordinator-text text-right">
                            Last refresh <Moment fromNow>{lastRefresh}</Moment>
                        </p>
                    </MDBCol>
                </MDBRow>
            </div>
        </MDBCardBody>
    );
};

const ProvinceList = (props) => {
    const provinces = props.provinces;
    const setSelectedProvince = props.setSelectedProvince;
    const selectedProvince = props.selectedProvince;

    function changeProvince(data) {
        setSelectedProvince(data);
    }

    const provinceDropdownList = provinces.map((data, key) => {
        const province = data[0];
        if (province) {
            return (
                <MDBDropdownItem
                    key={key}
                    onClick={() => changeProvince(province)}
                >
                    {province}
                </MDBDropdownItem>
            );
        }
        return null;
    });

    return (
        <MDBDropdown className="px-1 text-right">
            <MDBDropdownToggle className="black-text text-uppercase" nav caret>
                {selectedProvince}
                {"  "}
                <MDBIcon icon="filter" className="black-text" />
            </MDBDropdownToggle>
            <MDBDropdownMenu className="dropdown-default ">
                <MDBDropdownItem onClick={() => changeProvince("all")}>
                    All
                </MDBDropdownItem>
                {provinceDropdownList}
            </MDBDropdownMenu>
        </MDBDropdown>
    );
};

const MarkersList = (props) => {
    const markers = props.markers;
    const items = markers.map((marker, key) => {
        // marker returns an array with latitude, longitude, district name and patient status id in order
        if (
            marker[0] !== null &&
            marker[1] !== null &&
            marker[2] !== null &&
            marker[3] !== null
        ) {
            const position = [marker[0], marker[1]];
            const content = marker[2];
            const status = marker[3];
            return (
                <MyPopupMarker
                    key={key}
                    position={position}
                    content={content}
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
