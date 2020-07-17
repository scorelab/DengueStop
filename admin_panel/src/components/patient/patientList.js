import React from "react";
import { MDBCard } from "mdbreact";
import DataTable, { createTheme } from "react-data-table-component";
import Moment from "react-moment";

const PatientList = (props) => {
    const incidentArray = props.incidentArray;
    const columns = [
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
                <div>{row.incident.is_verified === "0" ? "No" : "Yes"}</div>
            ),
            sortable: true,
        },
    ];

    return (
        <MDBCard className="patient-table-container">
            <DataTable
                columns={columns}
                data={incidentArray}
                theme="solarized"
                responsive={true}
                expandableRows
                expandableRowsComponent={<h1> hello </h1>}
                pagination
            />
        </MDBCard>
    );
};

export default PatientList;
