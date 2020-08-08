import React, { useState, useEffect } from "react";
import { MDBContainer, MDBRow, MDBIcon } from "mdbreact";
import "./event.css";
import EventSearch from "./eventSearch";
import CommonService from "../../services/commonService";

const Event = () => {
    const commonService = new CommonService();
    const [eventArray, setEventArray] = useState([]);
    const [provinceArray, setProvinceArray] = useState([]);
    const [statusArray, setStatusArray] = useState([]);
    const [lastRefresh, setLastRefresh] = useState(Date());

    const getEvents = (eventName, province, status, dateRange) => {
        console.log(eventName);
        console.log(province);
        console.log(status);
        console.log(dateRange);
        // incidentService
        //     .queryIncidents(patientName, province, status, dateRange)
        //     .then((res) => {
        //         setIncidentArray(res);
        //         setLastRefresh(Date());
        //     });
    };

    useEffect(() => {
        getEvents("", "all", "all", "all");
        commonService.getProvinceNames().then((res) => {
            makeProvinceArray(res);
        });
        commonService.getEventStatuses().then((res) => {
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
        <MDBContainer className="py-3 event-container" fluid>
            <MDBRow>
                <EventSearch
                    provinceArray={provinceArray}
                    statusArray={statusArray}
                    getEvents={getEvents}
                ></EventSearch>
            </MDBRow>
        </MDBContainer>
    );
};

export default Event;
