import React, { Component } from "react";
import "./home.css";
import IncidentsReported from "./incidentsReported";
import IncidentSummary from "./incidentSummary";
import UpcomingEvents from "./upcomingEvents";
import HeatMap from "./heatMap";
import {
    MDBContainer,
    MDBRow,
    MDBCol,
    MDBCard,
    MDBCardBody,
    MDBCardTitle,
} from "mdbreact";

const Home = () => {
    return (
        <MDBContainer className="pt-3 pb-3 home-container" fluid>
            <MDBRow className="h-100">
                <MDBCol xs="12" md="12" xl="6">
                    <MDBCard className="h-100 main-card">
                        <HeatMap></HeatMap>
                    </MDBCard>
                </MDBCol>
                <MDBCol xs="12" md="6" xl="3">
                    <MDBRow>
                        <MDBCard className="w-100 main-card">
                            <MDBCardBody>
                                <MDBCardTitle className="card-title">
                                    <b>Incident Summary</b>
                                </MDBCardTitle>
                                <div className="mt-1 summary-array-container">
                                    <IncidentSummary></IncidentSummary>
                                </div>
                            </MDBCardBody>
                        </MDBCard>
                    </MDBRow>
                    <MDBRow className="pt-3">
                        <MDBCard className="w-100 main-card">
                            <MDBCardBody>
                                <MDBCardTitle className="card-title">
                                    <b>Upcoming Events</b>
                                </MDBCardTitle>
                                <div className="mt-1 event-array-container">
                                    <UpcomingEvents></UpcomingEvents>
                                </div>
                            </MDBCardBody>
                        </MDBCard>
                    </MDBRow>
                </MDBCol>
                <MDBCol
                    xs="12"
                    md="6"
                    xl="3"
                    className="d-flex align-content-stretch flex-wrap"
                >
                    <MDBCard className="main-card">
                        <MDBCardBody>
                            <MDBCardTitle className="card-title">
                                <b>Pending Reports</b>
                            </MDBCardTitle>
                            <div className="mt-1 incident-array-container">
                                <IncidentsReported></IncidentsReported>
                            </div>
                        </MDBCardBody>
                    </MDBCard>
                </MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Home;
