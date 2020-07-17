import React from "react";
import { MDBCard, MDBRow, MDBCol, MDBBtn } from "mdbreact";
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
                <div>{row.incident.is_verified === 0 ? "No" : "Yes"}</div>
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
                expandableRowsComponent={<ExpandedComponent />}
                pagination
            />
        </MDBCard>
    );
};

const ExpandedComponent = (props) => {
    const data = props.data;
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
                    <MDBRow className="p-2">
                        <MDBBtn block>View Reported Location</MDBBtn>
                    </MDBRow>
                    <MDBRow className="p-2">
                        <MDBBtn color="elegant" block>
                            Change Patient Status
                        </MDBBtn>
                    </MDBRow>
                    <MDBRow className="p-2">
                        <MDBBtn color="primary" block>
                            Approve Incident
                        </MDBBtn>
                    </MDBRow>
                    <MDBRow className="p-2">
                        <MDBBtn color="danger" block>
                            Decline Incident
                        </MDBBtn>
                    </MDBRow>
                </MDBCol>
            </MDBRow>
        </div>
    );
};

export default PatientList;
