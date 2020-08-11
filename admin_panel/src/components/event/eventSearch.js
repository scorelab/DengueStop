import React, { useState, useEffect } from "react";
import { MDBCard, MDBRow, MDBCol, MDBBtn } from "mdbreact";

const EventSearch = (props) => {
    const provinceArray = props.provinceArray;
    const statusArray = props.statusArray;
    const getEvents = props.getEvents;
    const [eventName, setEventName] = useState("");
    const [province, setProvince] = useState("all");
    const [status, setStatus] = useState("all");
    const [dateRange, setDateRange] = useState("all");

    const searchEvent = () => {
        // queries the events based on the params
        getEvents(eventName, province, status, dateRange);
    };

    return (
        <MDBCard className="event-search-container p-4">
            <MDBRow>
                <MDBCol xs="12" md="12" lg="4">
                    <label>Search by event name</label>
                    <input
                        type="text"
                        className="form-control"
                        value={eventName}
                        onChange={(event) => {
                            setEventName(event.target.value);
                        }}
                    />
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by province</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setProvince(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <ProvinceDropdownOptions
                                provinceArray={provinceArray}
                            ></ProvinceDropdownOptions>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by status</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setStatus(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <StatusDropdownOptions
                                statusArray={statusArray}
                            ></StatusDropdownOptions>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by date</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setDateRange(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <option value="weekly">Last 7 Days</option>
                            <option value="monthly">From Last Month</option>
                            <option value="yearly">From Last Year</option>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Search</label>
                    <MDBBtn
                        onClick={() => searchEvent()}
                        className="search-event-button"
                        size="md"
                    >
                        Search
                    </MDBBtn>
                </MDBCol>
            </MDBRow>
        </MDBCard>
    );
};

const ProvinceDropdownOptions = (props) => {
    const provinceArray = props.provinceArray;

    return provinceArray.map((data, index) => {
        if (data) {
            return (
                <option key={index} value={data}>
                    {data}
                </option>
            );
        } else {
            return null;
        }
    });
};

const StatusDropdownOptions = (props) => {
    const statusArray = props.statusArray;

    return statusArray.map((data, index) => {
        if (data) {
            return (
                <option key={index} value={data.id}>
                    {data.status}
                </option>
            );
        } else {
            return null;
        }
    });
};

export default EventSearch;
