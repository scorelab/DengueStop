import React, { useState, useEffect } from "react";
import { Map, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import {
    MDBCard,
    MDBRow,
    MDBCol,
    MDBBtn,
    MDBModal,
    MDBModalBody,
    MDBModalHeader,
    MDBModalFooter,
    MDBDropdown,
    MDBDropdownToggle,
    MDBDropdownMenu,
    MDBDropdownItem,
} from "mdbreact";
import DataTable from "react-data-table-component";
import Moment from "react-moment";
import IncidentService from "../../services/incidentService";

const PatientList = (props) => {
    const setIncidentArray = props.setIncidentArray;
    const incidentArray = props.incidentArray;
    const statusArray = props.statusArray;
    const lastRefresh = props.lastRefresh;

    const columns = [
        {
            name: "ID",
            selector: "incident.id",
            sortable: true,
        },
        {
            name: "Reported Time",
            selector: "incident.reported_time",
            cell: (row) => (
                <Moment format="DD/MM/YYYY @ hh:mm a">
                    {row.incident.reported_time}
                </Moment>
            ),
            sortable: true,
        },
        {
            name: "Patient Name",
            selector: "incident.patient_name",
            sortable: true,
        },
        {
            name: "Gender",
            selector: "incident.patient_gender",
            cell: (row) => (
                <div>
                    {row.incident.patient_gender === "m" ? "Male" : "Female"}
                </div>
            ),
            sortable: true,
        },
        {
            name: "Date of Birth",
            selector: "incident.patient_dob",
            cell: (row) => (
                <Moment format="DD/MM/YYYY">{row.incident.patient_dob}</Moment>
            ),
            sortable: true,
        },
        {
            name: "Province",
            selector: "incident.province",
            sortable: true,
        },
        {
            name: "District",
            selector: "incident.district",
            sortable: true,
        },
        {
            name: "Patient Status",
            selector: "status.status",
            sortable: true,
        },
        {
            name: "Incident Verified",
            selector: "incident.is_verified",
            cell: (row) => (
                <div>
                    {row.incident.is_verified === 0
                        ? "No"
                        : row.incident.is_verified === 1
                        ? "Yes"
                        : "Declined"}
                </div>
            ),
            sortable: true,
        },
    ];

    return (
        <MDBCard className="patient-table-container">
            <DataTable
                keyField={"ID"}
                columns={columns}
                data={incidentArray}
                theme="solarized"
                responsive={true}
                expandableRows
                expandableRowsComponent={
                    <ExpandedComponent
                        statusArray={statusArray}
                        setIncidentArray={setIncidentArray}
                        incidentArray={incidentArray}
                    ></ExpandedComponent>
                }
                pagination
            />
            <p className="px-3 text-right">
                Updated <Moment fromNow>{lastRefresh}</Moment>
            </p>
        </MDBCard>
    );
};

const ExpandedComponent = (props) => {
    const statusArray = props.statusArray;
    const incidentArray = props.incidentArray;
    const setIncidentArray = props.setIncidentArray;
    const [locationModal, setLocationModal] = useState(false);
    const [patientStatusModal, setPatientStatusModal] = useState(false);
    const [verifyModal, setVerifyModal] = useState(false);
    const [declineModal, setDeclineModal] = useState(false);
    const data = props.data;

    const showChangePatientStatusButton = (data) => {
        if (
            data.incident.is_verified !== 1 ||
            data.incident.patient_status_id >= 5
        ) {
            return false;
        }
        return true;
    };

    return (
        <div className="p-5 border-bottom">
            <MDBRow>
                <MDBCol size="5">
                    <h5 className="mt-2 font-weight-bold">
                        More Patient Details
                    </h5>
                    <hr />
                    <MDBRow>
                        <MDBCol>
                            <b>Incident ID : </b>
                            {data.incident.id}
                        </MDBCol>
                        <MDBCol>
                            <b>Address : </b>
                            {data.incident.city}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow>
                        <MDBCol>
                            {data.incident.description
                                ? ((<b>Description : </b>),
                                  data.incident.description)
                                : null}
                        </MDBCol>
                    </MDBRow>
                    {data.incident.is_verified !== 0 ? (
                        <div>
                            <h5 className="mt-5 font-weight-bold">
                                {data.incident.is_verified === 1
                                    ? "Approved By"
                                    : "Declined By"}
                            </h5>
                            <hr />
                            <MDBRow>
                                <MDBCol>
                                    <b>Admin ID : </b>
                                    {data.admin.id}
                                </MDBCol>
                                <MDBCol>
                                    <b>Admin Name : </b>
                                    {data.admin.name}
                                </MDBCol>
                            </MDBRow>
                            <MDBRow>
                                <MDBCol>
                                    <b>Email : </b>
                                    {data.admin.email}
                                </MDBCol>
                                <MDBCol>
                                    <b>Contact : </b>
                                    {data.admin.contact}
                                </MDBCol>
                            </MDBRow>
                        </div>
                    ) : null}
                </MDBCol>
                <MDBCol size="5">
                    <h5 className="mt-2 font-weight-bold">
                        Reporter's Details
                    </h5>
                    <hr />
                    <MDBRow>
                        <MDBCol>
                            <b>User ID : </b>
                            {data.user.id}
                        </MDBCol>
                        <MDBCol>
                            <b>Telephone : </b>
                            {data.user.telephone}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow>
                        <MDBCol>
                            <b>Name : </b>
                            {data.user.first_name} {data.user.last_name}
                        </MDBCol>
                        {data.user.email ? (
                            <MDBCol>
                                <b>Email : </b>
                                {data.user.email}
                            </MDBCol>
                        ) : null}
                    </MDBRow>
                </MDBCol>
                <MDBCol className="px-3 pt-2" size="2">
                    {data.incident.location_lat &&
                    data.incident.location_long ? (
                        <MDBRow className="p-2">
                            <MDBBtn
                                block
                                onClick={() => setLocationModal(true)}
                            >
                                View Reported Location
                            </MDBBtn>
                        </MDBRow>
                    ) : null}
                    {/* only show if incident is verified */}
                    {showChangePatientStatusButton(data) ? (
                        <MDBRow className="p-2">
                            <MDBBtn
                                color="elegant"
                                block
                                onClick={() => setPatientStatusModal(true)}
                            >
                                Change Patient Status
                            </MDBBtn>
                        </MDBRow>
                    ) : null}
                    {/* only show if incident is not verified */}
                    {data.incident.is_verified === 0 ? (
                        <React.Fragment>
                            <MDBRow className="p-2">
                                <MDBBtn
                                    color="primary"
                                    block
                                    onClick={() => setVerifyModal(true)}
                                >
                                    Approve Incident
                                </MDBBtn>
                            </MDBRow>
                            <MDBRow className="p-2">
                                <MDBBtn
                                    color="danger"
                                    block
                                    onClick={() => setDeclineModal(true)}
                                >
                                    Decline Incident
                                </MDBBtn>
                            </MDBRow>
                        </React.Fragment>
                    ) : null}
                </MDBCol>
            </MDBRow>
            {data.incident.location_lat && data.incident.location_long ? (
                <LocationModal
                    isOpen={locationModal}
                    setLocationModal={setLocationModal}
                    latitude={data.incident.location_lat}
                    longitude={data.incident.location_long}
                ></LocationModal>
            ) : null}
            <PatientStatusModal
                incidentArray={incidentArray}
                statusArray={statusArray}
                data={data}
                isOpen={patientStatusModal}
                setPatientStatusModal={setPatientStatusModal}
                setIncidentArray={setIncidentArray}
            ></PatientStatusModal>
            <VerifyReportModal
                isOpen={verifyModal}
                setIncidentArray={setIncidentArray}
                incidentArray={incidentArray}
                setVerifyModal={setVerifyModal}
                data={data}
            />
            <DeclineReportModal
                isOpen={declineModal}
                setIncidentArray={setIncidentArray}
                incidentArray={incidentArray}
                setDeclineModal={setDeclineModal}
                data={data}
            />
        </div>
    );
};

const LocationModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const setLocationModal = props.setLocationModal;
    const position = [props.latitude, props.longitude];

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    return (
        <MDBModal
            isOpen={isOpen}
            toggle={() => setLocationModal(false)}
            className="modal-notify modal-info text-white"
            size="md"
        >
            <MDBModalHeader>Reported Location</MDBModalHeader>
            <MDBModalBody>
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
            </MDBModalBody>
            <MDBModalFooter>
                <MDBBtn
                    color="secondary"
                    onClick={() => setLocationModal(false)}
                >
                    Close
                </MDBBtn>
            </MDBModalFooter>
        </MDBModal>
    );
};

const PatientStatusModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const [selectedStatus, setSelectedStatus] = useState("");
    const [selectedStatusName, setSelectedStatusName] = useState("");
    const setPatientStatusModal = props.setPatientStatusModal;
    const setIncidentArray = props.setIncidentArray;
    const data = props.data;
    const statusArray = props.statusArray;
    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    const availableDropdownItems = statusArray.map((item, index) => {
        if (item) {
            // if current id is greater or equal to status it will be disabled as they cannot go back in status
            // decline patient status cannot be added manually. it needs to be set from the declined incident
            // therefore id 7 corresponding to decline would be disabled as well
            if (item.id <= data.status.id || item.id === 7 || item.id === 2) {
                return null;
            }
            return (
                <MDBDropdownItem
                    key={index}
                    onClick={() => {
                        setSelectedStatus(item.id);
                        setSelectedStatusName(item.status);
                    }}
                >
                    {item.status}
                </MDBDropdownItem>
            );
        }
    });

    const changePatientStatus = () => {
        const incidentService = new IncidentService();
        setPatientStatusModal(false);
        let incidents = [...props.incidentArray];

        const updatedIncidentArray = incidents.map((incidentRow, index) => {
            if (incidentRow.incident.id === data.incident.id) {
                incidentRow.incident.patient_status_id = selectedStatus;
                incidentRow.status.id = selectedStatus;
                incidentRow.status.status = selectedStatusName;
                return incidentRow;
            }
            return incidentRow;
        });
        // updating the state
        incidentService
            .updatePatientStatus(data.incident.id, selectedStatus)
            .then((res) => {
                if (res) {
                    setIncidentArray(updatedIncidentArray);
                }
            });
    };

    return (
        <MDBModal
            isOpen={isOpen}
            toggle={() => setPatientStatusModal(false)}
            className="modal-notify text-white"
            size="md"
        >
            <MDBModalHeader className="modal-custom-dark-header">
                Patient Status
            </MDBModalHeader>
            <MDBModalBody>
                <MDBRow>
                    <MDBCol>
                        <b>Current Status : </b> {data.status.status}
                    </MDBCol>
                </MDBRow>
                <MDBRow>
                    <MDBCol>
                        <b>New Status : </b> {selectedStatusName}
                    </MDBCol>
                </MDBRow>
                <MDBRow className="mt-3">
                    <MDBCol>
                        Select the new status of the patient from below
                        <hr />
                    </MDBCol>
                </MDBRow>
                <MDBRow>
                    <MDBCol>
                        <MDBDropdown className="w-100">
                            <MDBDropdownToggle
                                className="w-100"
                                caret
                                color="white"
                            >
                                Select Status
                            </MDBDropdownToggle>
                            <MDBDropdownMenu className="w-100" basic>
                                {availableDropdownItems}
                            </MDBDropdownMenu>
                        </MDBDropdown>
                    </MDBCol>
                </MDBRow>
            </MDBModalBody>
            <MDBModalFooter>
                <MDBBtn color="primary" onClick={() => changePatientStatus()}>
                    Change Status
                </MDBBtn>
                <MDBBtn
                    color="secondary"
                    onClick={() => setPatientStatusModal(false)}
                >
                    Close
                </MDBBtn>
            </MDBModalFooter>
        </MDBModal>
    );
};

const VerifyReportModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const setIncidentArray = props.setIncidentArray;
    const currentIncident = props.data;
    const setVerifyModal = props.setVerifyModal;

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    async function verifyIncident(incidentId) {
        //get admin Id from user context data
        setVerifyModal(false);
        // getting a copy of incidents array
        const adminId = 1;
        let incidents = [...props.incidentArray];

        const updatedIncidentArray = incidents.map((incidentRow, index) => {
            if (incidentRow.incident.id === incidentId) {
                incidentRow.incident.patient_status_id = 2;
                incidentRow.incident.is_verified = 1;
                return incidentRow;
            }
            return incidentRow;
        });
        const incidentService = new IncidentService();
        const res = await incidentService.verifyIncident(incidentId, adminId);
        if (res) {
            // setting the new state when the request is successful
            setIncidentArray(updatedIncidentArray);
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

const DeclineReportModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const setIncidentArray = props.setIncidentArray;
    const currentIncident = props.data;
    const setDeclineModal = props.setDeclineModal;

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    async function declineIncident(incidentId) {
        //get admin Id from user context data
        setDeclineModal(false);
        // getting a copy of incidents array
        const adminId = 1;
        let incidents = [...props.incidentArray];

        const updatedIncidentArray = incidents.map((incidentRow, index) => {
            if (incidentRow.incident.id === incidentId) {
                incidentRow.incident.patient_status_id = 7;
                incidentRow.incident.is_verified = 2;
                incidentRow.status.id = 7;
                incidentRow.status.status = "Declined";
                return incidentRow;
            }
            return incidentRow;
        });
        const incidentService = new IncidentService();
        const res = await incidentService.declineIncident(incidentId, adminId);
        if (res) {
            // setting the new state when the request is successful
            setIncidentArray(updatedIncidentArray);
        } else {
            //show error
        }
    }

    return (
        <React.Fragment>
            {/* verify incident modal */}
            <MDBModal
                isOpen={isOpen}
                toggle={() => setDeclineModal(false)}
                className="modal-notify modal-danger text-white"
                size="sm"
            >
                <MDBModalHeader>Decline Incident?</MDBModalHeader>
                <MDBModalBody>
                    Are you sure you want to decline this incident? This action
                    is irreversible.
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

export default PatientList;
