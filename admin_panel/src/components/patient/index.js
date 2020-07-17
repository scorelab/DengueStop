import React, { useState, useEffect } from "react";
import "./patient.css";
import { MDBContainer, MDBRow } from "mdbreact";
import PatientList from "./patientList";
import PatientSearch from "./patientSearch";
import IncidentService from "../../services/incidentService";

const Patient = () => {
    const [incidentArray, setIncidentArray] = useState([]);
    const incidentService = new IncidentService();

    const getIncidents = (patientName, province, status, dateRange) => {
        incidentService
            .queryIncidents(patientName, province, status, dateRange)
            .then((res) => {
                setIncidentArray(res);
            });
    };

    useEffect(() => {
        getIncidents("", "all", "all", "all");
    }, []);

    return (
        <MDBContainer className="py-3 patient-container" fluid>
            <MDBRow>
                <PatientSearch getIncidents={getIncidents}></PatientSearch>
            </MDBRow>
            <MDBRow>
                <PatientList incidentArray={incidentArray}></PatientList>
            </MDBRow>
        </MDBContainer>
    );
};

export default Patient;
