import React, { useState, useEffect } from "react";
import "./patient.css";
import { MDBContainer, MDBRow, MDBIcon } from "mdbreact";
import PatientList from "./patientList";
import PatientSearch from "./patientSearch";
import IncidentService from "../../services/incidentService";
import CommonService from "../../services/commonService";

const Patient = () => {
    const [incidentArray, setIncidentArray] = useState([]);
    const [provinceArray, setProvinceArray] = useState([]);
    const [statusArray, setStatusArray] = useState([]);
    const [lastRefresh, setLastRefresh] = useState(Date());
    const incidentService = new IncidentService();
    const commonService = new CommonService();

    const getIncidents = (patientName, province, status, dateRange) => {
        incidentService
            .queryIncidents(patientName, province, status, dateRange)
            .then((res) => {
                setIncidentArray(res);
                setLastRefresh(Date());
            });
    };

    useEffect(() => {
        getIncidents("", "all", "all", "all");
        commonService.getProvinceNames().then((res) => {
            makeProvinceArray(res);
        });
        commonService.getPatientStatuses().then((res) => {
            setStatusArray(res);
        });
        setLastRefresh(Date());
    }, []);

    const makeProvinceArray = (data) => {
        var tempArray = [];
        data.forEach((province) => {
            tempArray.push(province.name);
        });
        setProvinceArray(tempArray);
    };

    return (
        <MDBContainer className="py-3 patient-container" fluid>
            <MDBRow>
                <PatientSearch
                    provinceArray={provinceArray}
                    statusArray={statusArray}
                    getIncidents={getIncidents}
                ></PatientSearch>
            </MDBRow>
            <p className="text-center p-0 m-0">
                Click on <MDBIcon icon="angle-right mx-1" /> icon to view more
                information or to change status of the patient
            </p>
            <MDBRow>
                <PatientList
                    lastRefresh={lastRefresh}
                    statusArray={statusArray}
                    incidentArray={incidentArray}
                    setIncidentArray={setIncidentArray}
                ></PatientList>
            </MDBRow>
        </MDBContainer>
    );
};

export default Patient;
