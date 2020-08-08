import React, { useState, useEffect } from "react";
import { MDBContainer, MDBRow, MDBIcon } from "mdbreact";
import "./event.css";
import EventSearch from "./eventSearch";
import EventList from "./eventList";
import CommonService from "../../services/commonService";
import EventService from "../../services/eventService";

const Event = () => {
    const commonService = new CommonService();
    const eventService = new EventService();
    const [eventArray, setEventArray] = useState([]);
    const [provinceArray, setProvinceArray] = useState([]);
    const [statusArray, setStatusArray] = useState([]);
    const [lastRefresh, setLastRefresh] = useState(Date());

    const getEvents = (eventName, province, status, dateRange) => {
        eventService
            .queryEvents(eventName, province, status, dateRange)
            .then((res) => {
                console.log(res);

                setEventArray(res);
                setLastRefresh(Date());
            });
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
            <p className="text-center p-0 m-0">
                Click on <MDBIcon icon="angle-right mx-1" /> icon to view more
                information or to change status of the event
            </p>
            <MDBRow>
                <EventList
                    lastRefresh={lastRefresh}
                    statusArray={statusArray}
                    eventArray={eventArray}
                    setEventArray={setEventArray}
                ></EventList>
            </MDBRow>
        </MDBContainer>
    );
};

export default Event;
