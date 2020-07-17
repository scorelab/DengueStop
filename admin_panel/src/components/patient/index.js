import React, { Component } from "react";
import "./patient.css";
import { MDBContainer, MDBRow, MDBCol, MDBCard } from "mdbreact";
import PatientList from "./patientList";
import PatientSearch from "./patientSearch";

class Patient extends Component {
    render() {
        return (
            <MDBContainer className="py-3 patient-container" fluid>
                <MDBRow>
                    <PatientSearch></PatientSearch>
                </MDBRow>
                <MDBRow>
                    <PatientList></PatientList>
                </MDBRow>
            </MDBContainer>
        );
    }
}

export default Patient;
