import React, { useState, useEffect } from "react";
import { Map, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import Moment from "react-moment";
import "./home.css";
import {
    MDBRow,
    MDBCol,
    MDBCard,
    MDBModal,
    MDBModalBody,
    MDBModalHeader,
    MDBModalFooter,
    MDBBtn,
} from "mdbreact";
import L from "leaflet";

delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
    iconRetinaUrl: require("leaflet/dist/images/marker-icon-2x.png"),
    iconUrl: require("leaflet/dist/images/marker-icon.png"),
    shadowUrl: require("leaflet/dist/images/marker-shadow.png"),
});

const EventCard = (props) => {
    const [locationModal, setLocationModal] = useState(false);
    const data = props.event;

    return (
        <React.Fragment>
            <MDBCard className="m-2 mt-3 px-2 py-0 event-card">
                <MDBRow>
                    <MDBCol size="6" className="text-left">
                        <span className="timestamp-text">
                            {data.status.status}
                        </span>
                    </MDBCol>
                    <MDBCol size="6" className="text-right">
                        <span className="timestamp-text">
                            <Moment fromNow>{data.event.start_time}</Moment>
                        </span>
                    </MDBCol>
                </MDBRow>
                <MDBRow>
                    <MDBCol size="7" className="text-left ellipsis">
                        <span className="event-name-text ellipsis">
                            {data.event.name}
                        </span>
                    </MDBCol>
                </MDBRow>
                <MDBRow className="mt-1">
                    <MDBCol className="event-coordinator-text text-left">
                        {data.event.coordinator_name}
                    </MDBCol>
                </MDBRow>
                <MDBRow>
                    <MDBCol className="event-coordinator-text text-left">
                        <Moment format="Do MMMM YYYY">
                            {data.event.start_time}
                        </Moment>
                        <b>{" | "}</b>
                        <Moment format="hh.mm a">
                            {data.event.start_time}
                        </Moment>
                        {" to "}
                        <Moment
                            add={{ hours: data.event.duration }}
                            format="hh.mm a"
                        >
                            {data.event.start_time}
                        </Moment>
                    </MDBCol>
                </MDBRow>
                <MDBRow className="mt-1">
                    {" "}
                    <MDBCol size="6" className="text-left">
                        <a
                            href="#!"
                            className="view-event-text"
                            onClick={() => setLocationModal(true)}
                        >
                            View Event Info
                        </a>
                    </MDBCol>
                    <MDBCol size="6" className="text-right decline-report-text">
                        {/* Implement this feature */}
                        <a href="#!" className="decline-report-text">
                            Edit Event
                        </a>
                    </MDBCol>
                </MDBRow>
            </MDBCard>
            <ViewEventModal
                isOpen={locationModal}
                data={data}
                setViewModal={setLocationModal}
            />
        </React.Fragment>
    );
};

const ViewEventModal = (props) => {
    const data = props.data;
    const position = [data.event.location_lat, data.event.location_long];
    const [isOpen, setIsOpen] = useState(props.isOpen);
    const setViewModal = props.setViewModal;

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    return (
        <React.Fragment>
            <MDBModal
                isOpen={isOpen}
                toggle={() => setViewModal(false)}
                className="modal-primary modal-notify text-white"
                size="lg"
            >
                <MDBModalHeader>{data.event.name}</MDBModalHeader>
                <MDBModalBody>
                    <MDBRow>
                        <MDBCol className="text-left">
                            <b>{data.status.status}</b>
                        </MDBCol>
                        <MDBCol className="text-right">
                            <Moment fromNow>{data.event.start_time}</Moment>
                        </MDBCol>
                    </MDBRow>
                    <h4 className="mt-2">Event Details</h4>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Event Name : </b>
                            {data.event.name}{" "}
                        </MDBCol>
                        <MDBCol>
                            <b>Venue : </b>
                            {data.event.venue}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Starts at : </b>
                            <Moment format="Do MMMM YYYY @ hh.mm a">
                                {data.event.start_time}
                            </Moment>
                        </MDBCol>
                        <MDBCol>
                            <b>Ends at : </b>
                            <Moment
                                add={{ hours: data.event.duration }}
                                format="Do MMMM YYYY @ hh.mm a"
                            >
                                {data.event.start_time}
                            </Moment>
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Description : </b>
                            <br></br>
                            {data.event.description ||
                                "No description available"}
                        </MDBCol>
                    </MDBRow>
                    <hr></hr>
                    <h4 className="mt-2">Event Coordinator</h4>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Coordinator Name : </b>{" "}
                            {data.event.coordinator_name}
                        </MDBCol>
                        <MDBCol>
                            <b>Coordinator Contact : </b>{" "}
                            {data.event.coordinator_contact}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Created by : </b> {data.admin.name}
                        </MDBCol>
                        <MDBCol>
                            <b>Created on : </b>{" "}
                            <Moment format="Do MMMM YYYY @ hh.mm a">
                                {data.event.date_created}
                            </Moment>
                        </MDBCol>
                    </MDBRow>
                    <hr></hr>
                    <h4 className="mt-2">Event Location</h4>
                    <div>
                        <Map
                            className="mt-2 venue-map-container"
                            center={position}
                            zoom={17}
                        >
                            <TileLayer
                                attribution='&amp;copy <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                            />
                            <Marker position={position}>
                                <Popup>Reported Location</Popup>
                            </Marker>
                        </Map>
                    </div>
                </MDBModalBody>
                <MDBModalFooter>
                    <MDBBtn
                        color="secondary"
                        onClick={() => setViewModal(false)}
                    >
                        Close
                    </MDBBtn>
                </MDBModalFooter>
            </MDBModal>
        </React.Fragment>
    );
};

export default EventCard;
