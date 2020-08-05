import React, { useState, useEffect, useContext } from "react";
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
import Truncate from "react-truncate";
import IncidentService from "../../services/incidentService";
import L from "leaflet";
import { SessionContext, getSession } from "../../services/sessionService";

delete L.Icon.Default.prototype._getIconUrl;

L.Icon.Default.mergeOptions({
    iconRetinaUrl: require("leaflet/dist/images/marker-icon-2x.png"),
    iconUrl: require("leaflet/dist/images/marker-icon.png"),
    shadowUrl: require("leaflet/dist/images/marker-shadow.png"),
});

const IncidentCard = (props) => {
    const [verifyModal, setVerifyModal] = useState(false);
    const [declineModal, setDeclineModal] = useState(false);
    const [viewModal, setViewModal] = useState(false);
    const index = props.index;
    const setIncidents = props.setIncidents;
    const data = props.incidents[index];

    return (
        <React.Fragment>
            <MDBCard className="m-2 mt-3 px-2 py-0 incident-card">
                <MDBRow>
                    <MDBCol size="7" className="text-left">
                        <span className="incident-reporter-text">
                            By {data.user.first_name} {data.user.last_name}
                        </span>
                    </MDBCol>
                    <MDBCol size="5" className="text-right">
                        <span className="timestamp-text">
                            <Moment fromNow>
                                {data.incident.reported_time}
                            </Moment>
                        </span>
                    </MDBCol>
                </MDBRow>
                <MDBRow className="px-3 mt-1">
                    <Truncate
                        className="incident-description-text text-left"
                        lines={1}
                        ellipsis={<span>...</span>}
                    >
                        {data.incident.description ||
                            "No description available"}
                    </Truncate>
                </MDBRow>
                <MDBRow className="mt-1">
                    {" "}
                    <MDBCol size="4" className="text-left">
                        <a
                            href="#!"
                            className="view-report-text"
                            onClick={() => setViewModal(true)}
                        >
                            View More
                        </a>
                    </MDBCol>
                    <MDBCol size="4" className="text-center">
                        <a
                            href="#!"
                            className="verify-report-text"
                            onClick={() => setVerifyModal(true)}
                        >
                            Verify
                        </a>
                    </MDBCol>
                    <MDBCol size="4" className="text-right">
                        <a
                            href="#!"
                            className="decline-report-text"
                            onClick={() => setDeclineModal(true)}
                        >
                            Decline
                        </a>
                    </MDBCol>
                </MDBRow>
            </MDBCard>
            <ViewReportModal
                isOpen={viewModal}
                data={data}
                setViewModal={setViewModal}
            />
            <VerifyReportModal
                isOpen={verifyModal}
                index={index}
                setIncidents={setIncidents}
                incidents={props.incidents}
                setVerifyModal={setVerifyModal}
                data={data}
            />
            <DeclineReportModal
                isOpen={declineModal}
                index={index}
                setIncidents={setIncidents}
                incidents={props.incidents}
                setDeclineModal={setDeclineModal}
                data={data}
            />
        </React.Fragment>
    );
};

const DeclineReportModal = (props) => {
    const currentUser = getSession();
    const [isOpen, setIsOpen] = useState(false);
    const setIncidents = props.setIncidents;
    const index = props.index;
    const currentIncident = props.data;
    const setDeclineModal = props.setDeclineModal;

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    async function declineIncident(incidentId) {
        //get admin Id from user context data
        setDeclineModal(false);
        // getting a copy of incidents array
        const adminId = currentUser.id;
        const incidents = [...props.incidents];
        // removing the declined element
        incidents.splice(index, 1);
        const incidentService = new IncidentService();
        const res = await incidentService.declineIncident(incidentId, adminId);
        if (res) {
            // setting the new state when the request is successful
            setIncidents(incidents);
        } else {
            //show error
        }
    }

    return (
        <React.Fragment>
            {/* decline incident modal */}
            <MDBModal
                isOpen={isOpen}
                toggle={() => setDeclineModal(false)}
                className="modal-notify modal-danger text-white"
                size="sm"
            >
                <MDBModalHeader>Decline Incident?</MDBModalHeader>
                <MDBModalBody>
                    Please make sure to contact reporter and verify the incident
                    before declining. Do you want to decline?
                </MDBModalBody>
                <MDBModalFooter>
                    <MDBBtn
                        color="danger"
                        onClick={() =>
                            declineIncident(currentIncident.incident.id)
                        }
                    >
                        Yes
                    </MDBBtn>
                    <MDBBtn
                        color="secondary"
                        onClick={() => setDeclineModal(false)}
                    >
                        No
                    </MDBBtn>
                </MDBModalFooter>
            </MDBModal>
        </React.Fragment>
    );
};

const VerifyReportModal = (props) => {
    const currentUser = getSession();
    const [isOpen, setIsOpen] = useState(false);
    const setIncidents = props.setIncidents;
    const index = props.index;
    const currentIncident = props.data;
    const setVerifyModal = props.setVerifyModal;

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    async function verifyIncident(incidentId) {
        //get admin Id from user context data
        setVerifyModal(false);
        // getting a copy of incidents array
        const adminId = currentUser.id;
        const incidents = [...props.incidents];
        // removing the verified element
        incidents.splice(index, 1);
        const incidentService = new IncidentService();
        const res = await incidentService.verifyIncident(incidentId, adminId);
        if (res) {
            // setting the new state when the request is successful
            setIncidents(incidents);
        } else {
            //show error
        }
    }

    return (
        <React.Fragment>
            {/* verify incident modal */}
            <MDBModal
                isOpen={isOpen}
                toggle={() => setVerifyModal(false)}
                className="modal-notify modal-primary text-white"
                size="sm"
            >
                <MDBModalHeader>Verify Incident?</MDBModalHeader>
                <MDBModalBody>
                    Please make sure to contact reporter and verify the incident
                    before confirmation. Do you want to verify?
                </MDBModalBody>
                <MDBModalFooter>
                    <MDBBtn
                        color="primary"
                        onClick={() =>
                            verifyIncident(currentIncident.incident.id)
                        }
                    >
                        Yes
                    </MDBBtn>
                    <MDBBtn
                        color="secondary"
                        onClick={() => setVerifyModal(false)}
                    >
                        No
                    </MDBBtn>
                </MDBModalFooter>
            </MDBModal>
        </React.Fragment>
    );
};

const ViewReportModal = (props) => {
    const data = props.data;
    const [isOpen, setIsOpen] = useState(props.isOpen);
    const lat = data.incident.location_lat || 0.0;
    const long = data.incident.location_long || 0.0;
    const position = [lat, long];
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
                <MDBModalHeader>
                    Incident #{data.incident.id} Report
                </MDBModalHeader>
                <MDBModalBody>
                    <MDBRow>
                        <MDBCol size="8">
                            <b>Reported Time : </b>
                            <Moment format="DD/MM/YYYY @ hh:mm:ss">
                                {data.incident.reported_time}
                            </Moment>{" "}
                            (
                            <Moment fromNow>
                                {data.incident.reported_time}
                            </Moment>
                            )
                        </MDBCol>
                        <MDBCol className="text-right text-danger">
                            <b>Not Verified</b>
                        </MDBCol>
                    </MDBRow>
                    <hr></hr>
                    <h4 className="mt-2">Patient Details</h4>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Name : </b>
                            {data.incident.patient_name}{" "}
                        </MDBCol>
                        <MDBCol>
                            <b>Gender : </b>
                            {data.incident.gender === "m"
                                ? "Male"
                                : "Female"}{" "}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Date of Birth : </b>
                            <Moment format="DD/MM/YYYY">
                                {data.incident.patient_dob}
                            </Moment>
                        </MDBCol>
                        <MDBCol>
                            <b>Status : </b>
                            {data.status.status}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow>
                        <MDBCol>
                            <b>Description :</b>
                            <br></br>
                            <Truncate lines={2} ellipsis={<span>...</span>}>
                                {data.incident.description ||
                                    "No description available"}
                            </Truncate>
                        </MDBCol>
                    </MDBRow>
                    <hr></hr>
                    <h4 className="mt-2">Reported User</h4>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Name : </b>
                            {data.user.first_name} {data.user.last_name}
                        </MDBCol>
                        <MDBCol>
                            <b>Contact : </b>
                            {data.user.telephone}
                        </MDBCol>
                        <MDBCol>
                            {data.user.email ? (
                                <span>
                                    <b>Email : </b>
                                    {data.user.email}
                                </span>
                            ) : (
                                ""
                            )}
                        </MDBCol>
                    </MDBRow>
                    <hr></hr>
                    <h4 className="mt-2">Incident Location</h4>
                    <MDBRow className="mt-1">
                        <MDBCol>
                            <b>Address : </b>
                            {data.incident.city}
                        </MDBCol>
                        <MDBCol>
                            {data.incident.province} | {data.incident.district}
                        </MDBCol>
                    </MDBRow>
                    {/* does not return the map if both lat and long are 0.0 */}
                    {lat !== 0.0 && long !== 0.0 ? (
                        <MDBRow>
                            <MDBCol>
                                <Map
                                    className="map-container"
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
                            </MDBCol>
                        </MDBRow>
                    ) : (
                        ""
                    )}
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

export default IncidentCard;
