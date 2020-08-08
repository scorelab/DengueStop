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
    MDBIcon,
} from "mdbreact";
import DataTable from "react-data-table-component";
import Moment from "react-moment";
import { getSession } from "../../services/sessionService";
import EventService from "../../services/eventService";

const EventList = (props) => {
    const currentUser = getSession();
    const setEventArray = props.setEventArray;
    const eventArray = props.eventArray;
    const statusArray = props.statusArray;
    const lastRefresh = props.lastRefresh;
    const [addEventModal, setAddEventModal] = useState(false);

    const columns = [
        {
            name: "Event ID",
            selector: "event.id",
            sortable: true,
        },
        {
            name: "Event Start Time",
            selector: "event.start_time",
            cell: (row) => (
                <Moment format="DD/MM/YYYY @ hh:mm a">
                    {row.event.start_time}
                </Moment>
            ),
            sortable: true,
        },
        {
            name: "Event Name",
            selector: "event.name",
            sortable: true,
        },
        {
            name: "Event Venue",
            selector: "event.venue",
            sortable: true,
        },
        {
            name: "Coordinator",
            selector: "event.coordinator_name",
            sortable: true,
        },
        {
            name: "Province",
            selector: "org_unit.province",
            sortable: true,
        },
        {
            name: "Org Name",
            selector: "org_unit.name",
            sortable: true,
        },
        {
            name: "Status",
            selector: "status.status",
            sortable: true,
        },
    ];

    const conditionalRowStyles = [
        {
            when: (row) => row.event.status_id === 5,
            style: {
                backgroundColor: "#ffcfcf",
            },
        },
    ];

    return (
        <MDBCard className="patient-table-container">
            <NewEventModal isOpen={addEventModal} />
            <MDBRow className="w-100">
                <MDBCol>
                    <MDBBtn
                        size="lg"
                        color="primary"
                        onClick={() => setAddEventModal(true)}
                    >
                        <MDBIcon icon="plus" /> Add New Event
                    </MDBBtn>
                </MDBCol>
            </MDBRow>
            <DataTable
                keyField={"ID"}
                columns={columns}
                data={eventArray}
                theme="solarized"
                responsive={true}
                expandableRows
                conditionalRowStyles={conditionalRowStyles}
                expandableRowsComponent={
                    <ExpandedComponent
                        currentUser={currentUser}
                        eventArray={eventArray}
                        setEventArray={setEventArray}
                        statusArray={statusArray}
                    />
                }
                pagination
            />
            <p className="px-3 text-right">
                Updated <Moment fromNow>{lastRefresh}</Moment>
            </p>
        </MDBCard>
    );
};

const NewEventModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);

    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    return (
        <MDBModal size="lg" isOpen={isOpen} toggle={() => setIsOpen(false)}>
            <MDBModalHeader>Add New Event</MDBModalHeader>
            <MDBModalBody></MDBModalBody>
            <MDBModalFooter>
                <MDBBtn color="primary">Save Event</MDBBtn>
                <MDBBtn color="secondary" onClick={() => setIsOpen(false)}>
                    Close
                </MDBBtn>
            </MDBModalFooter>
        </MDBModal>
    );
};

const ExpandedComponent = (props) => {
    const data = props.data;
    const setEventArray = props.setEventArray;
    const eventArray = props.eventArray;
    const statusArray = props.statusArray;
    const currentUser = props.currentUser;
    const currentOrg = currentUser.org_id;
    const [locationModal, setLocationModal] = useState(false);
    const [eventStatusModal, setEventStatusModal] = useState(false);

    return (
        <div className="p-5 border-bottom">
            <MDBRow>
                <MDBCol size="5">
                    <h5 className="mt-2 font-weight-bold">
                        More Event Details
                    </h5>
                    <hr />
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event Created at : </b>
                            <Moment format="DD/MM/YYYY @ hh:mm a">
                                {data.event.date_created}
                            </Moment>{" "}
                            (<Moment fromNow>{data.event.date_created}</Moment>)
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event ID : </b>
                            {data.event.id}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event Venue : </b>
                            {data.event.venue}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event Coordinator : </b>
                            {data.event.coordinator_name}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event Contact : </b>
                            {data.event.coordinator_contact}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Event Ends at : </b>
                            <Moment
                                format="DD/MM/YYYY @ hh:mm a"
                                add={{ hours: data.event.duration }}
                            >
                                {data.event.start_time}
                            </Moment>{" "}
                            ({data.event.duration} hours)
                        </MDBCol>
                    </MDBRow>
                    <MDBRow>
                        <MDBCol>
                            <b>Event Description : </b>
                            <br></br>
                            {data.event.description}
                        </MDBCol>
                    </MDBRow>
                </MDBCol>
                <MDBCol size="5">
                    <h5 className="mt-2 font-weight-bold">
                        Host Organization Details
                    </h5>
                    <hr />
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Organization : </b>
                            {data.org_unit.name}
                        </MDBCol>
                        <MDBCol>
                            <b>Contact : </b>
                            {data.org_unit.contact}
                        </MDBCol>
                    </MDBRow>
                    <MDBRow className="mb-2">
                        <MDBCol>
                            <b>Province : </b>
                            {data.org_unit.province}
                        </MDBCol>
                        <MDBCol>
                            <b>District : </b>
                            {data.org_unit.district}
                        </MDBCol>
                    </MDBRow>
                    {data.event.org_id === currentOrg ? (
                        <b className="blue-text">
                            This is event is organized by our organization
                        </b>
                    ) : null}
                </MDBCol>
                <MDBCol className="px-3 pt-2" size="2">
                    <MDBRow className="p-2">
                        <MDBBtn block onClick={() => setLocationModal(true)}>
                            View Event Location
                        </MDBBtn>
                    </MDBRow>
                    {data.event.org_id === currentOrg &&
                    data.event.status_id !== 5 ? (
                        <MDBRow className="p-2">
                            <MDBBtn
                                color="elegant"
                                block
                                onClick={() => setEventStatusModal(true)}
                            >
                                Change Event Status
                            </MDBBtn>
                        </MDBRow>
                    ) : null}
                </MDBCol>
            </MDBRow>
            <LocationModal
                isOpen={locationModal}
                setLocationModal={setLocationModal}
                latitude={data.event.location_lat}
                longitude={data.event.location_long}
            ></LocationModal>
            <EventStatusModal
                eventArray={eventArray}
                statusArray={statusArray}
                data={data}
                isOpen={eventStatusModal}
                setEventStatusModal={setEventStatusModal}
                setEventArray={setEventArray}
            ></EventStatusModal>
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
            <MDBModalHeader>Event Location</MDBModalHeader>
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

const EventStatusModal = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const [selectedStatus, setSelectedStatus] = useState("");
    const [selectedStatusName, setSelectedStatusName] = useState("");
    const setEventStatusModal = props.setEventStatusModal;
    const setEventArray = props.setEventArray;
    const data = props.data;
    const statusArray = props.statusArray;
    useEffect(() => {
        setIsOpen(props.isOpen);
    });

    const availableDropdownItems = statusArray.map((item, index) => {
        if (item) {
            // event can't be set to pending as it is set by default
            if (item.id <= data.status.id || item.id === 4) {
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

    const changeEventStatus = () => {
        const eventService = new EventService();
        setEventStatusModal(false);
        let event = [...props.eventArray];

        const updatedEventArray = event.map((eventRow, index) => {
            if (eventRow.event.id === data.event.id) {
                eventRow.event.status_id = selectedStatus;
                eventRow.status.id = selectedStatus;
                eventRow.status.status = selectedStatusName;
                return eventRow;
            }
            return eventRow;
        });
        // updating the state
        eventService
            .updateEventStatus(data.event.id, selectedStatus)
            .then((res) => {
                if (res) {
                    setEventArray(updatedEventArray);
                }
            });
    };

    return (
        <MDBModal
            isOpen={isOpen}
            toggle={() => setEventStatusModal(false)}
            className="modal-notify text-white"
            size="md"
        >
            <MDBModalHeader className="modal-custom-dark-header">
                Event Status
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
                        Select the new status of the event from below
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
                <MDBBtn color="primary" onClick={() => changeEventStatus()}>
                    Change Status
                </MDBBtn>
                <MDBBtn
                    color="secondary"
                    onClick={() => setEventStatusModal(false)}
                >
                    Close
                </MDBBtn>
            </MDBModalFooter>
        </MDBModal>
    );
};

export default EventList;
