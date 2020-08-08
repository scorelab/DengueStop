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

const EventList = (props) => {
    const setEventArray = props.setEventArray;
    const eventArray = props.eventArray;
    const statusArray = props.statusArray;
    const lastRefresh = props.lastRefresh;

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
        // {
        //     name: "Patient Status",
        //     selector: "status.status",
        //     sortable: true,
        // },
        // {
        //     name: "Incident Verified",
        //     selector: "incident.is_verified",
        //     cell: (row) => (
        //         <div>
        //             {row.incident.is_verified === 0
        //                 ? "No"
        //                 : row.incident.is_verified === 1
        //                 ? "Yes"
        //                 : "Declined"}
        //         </div>
        //     ),
        //     sortable: true,
        // },
    ];

    return (
        <MDBCard className="patient-table-container">
            <DataTable
                keyField={"ID"}
                columns={columns}
                data={eventArray}
                theme="solarized"
                responsive={true}
                expandableRows
                expandableRowsComponent={<h1>Hello</h1>}
                pagination
            />
            <p className="px-3 text-right">
                Updated <Moment fromNow>{lastRefresh}</Moment>
            </p>
        </MDBCard>
    );
};

export default EventList;
