import React, { useState, useEffect, useRef } from "react";
import "./patient.css";
import { MDBContainer, MDBRow } from "mdbreact";
import PatientList from "./patientList";
import PatientSearch from "./patientSearch";
import IncidentService from "../../services/incidentService";
import CommonService from "../../services/commonService";

const Patient = () => {
    console.log("Patient Re Render");

    const [incidentArray, setIncidentArray] = useState([]);
    const [provinceArray, setProvinceArray] = useState([]);
    const [statusArray, setStatusArray] = useState([]);
    const incidentService = new IncidentService();
    const commonService = new CommonService();
    const previousIncidentArray = usePrevious(incidentArray);

    const getIncidents = (patientName, province, status, dateRange) => {
        incidentService
            .queryIncidents(patientName, province, status, dateRange)
            .then((res) => {
                setIncidentArray(res);
            });
    };

    function usePrevious(value) {
        const ref = useRef();
        useEffect(() => {
            ref.current = value;
        });
        return ref.current;
    }

    useEffect(() => {
        console.log("REFRESSSSHHHH 1");
        getIncidents("", "all", "all", "all");
    }, []);

    useEffect(() => {
        console.log("REFRESSSSHHHH status");
        // getIncidents("", "all", "all", "all");
    }, [incidentArray]);

    useEffect(() => {
        console.log("REFRESSSSHHHH 2");
        commonService.getProvinceNames().then((res) => {
            makeProvinceArray(res);
        });
        commonService.getPatientStatuses().then((res) => {
            setStatusArray(res);
        });
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
            <MDBRow>
                <PatientList
                    statusArray={statusArray}
                    incidentArray={incidentArray}
                    setIncidentArray={setIncidentArray}
                ></PatientList>
            </MDBRow>
        </MDBContainer>
    );
};

export default Patient;
