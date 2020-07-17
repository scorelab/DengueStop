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
                console.log(res);

                setIncidentArray(res);
            });
    };

    useEffect(() => {
        getIncidents("bAR", "all", "all", "all");
    }, []);

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
};

export default Patient;
