import React from "react";
import { MDBDataTable, MDBCard } from "mdbreact";
import DataTable, { createTheme } from "react-data-table-component";
import Moment from "react-moment";

const PatientList = (props) => {
    const incidentArray = props.incidentArray;
    const columns = [
        {
            name: "Reported Time",
            selector: "reported_time",
            cell: (row) => (
                <Moment format="DD/MM/YYYY @ hh:mm a">
                    {row.reported_time}
                </Moment>
            ),
            sortable: true,
        },
        {
            name: "Patient Name",
            selector: "patient_name",
            sortable: true,
        },
        {
            name: "Gender",
            selector: "patient_gender",
            cell: (row) => (
                <div>{row.patient_gender == "m" ? "Male" : "Female"}</div>
            ),
            sortable: true,
        },
        {
            name: "Date of Birth",
            cell: (row) => (
                <Moment format="DD/MM/YYYY">{row.patient_dob}</Moment>
            ),
            sortable: true,
        },
        {
            name: "Province",
            selector: "province",
            sortable: true,
        },
        {
            name: "District",
            selector: "district",
            sortable: true,
        },
        {
            name: "Patient Status",
            selector: "patient_status_id",
            sortable: true,
        },
        {
            name: "Incident Status",
            selector: "is_verified",
            sortable: true,
        },
    ];
    const data = {
        columns: columns,
        rows: incidentArray,
    };

    return (
        <MDBCard className="patient-table-container">
            {/* <MDBDataTable
                hover
                autoWidth
                responsive
                noBottomColumns
                searching={false}
                displayEntries={false}
                data={data}
            /> */}
            <DataTable
                columns={columns}
                data={incidentArray}
                theme="solarized"
                pagination
            />
        </MDBCard>
    );
};

export default PatientList;
