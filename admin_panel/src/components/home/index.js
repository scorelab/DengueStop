import React, { useState, useEffect } from "react";
import "./home.css";
import IncidentsReported from "./incidentsReported";
import IncidentSummary from "./incidentSummary";
import UpcomingEvents from "./upcomingEvents";
import HeatMap from "./heatMap";
import { MDBContainer, MDBRow, MDBCol, MDBCard } from "mdbreact";

const Home = () => {
    const [lastMapRefresh, setLastMapRefresh] = useState(Date());
    const [lastSummaryRefresh, setLastSummaryRefresh] = useState(Date());
    const [lastEventRefresh, setLastEventRefresh] = useState(Date());
    const [lastIncidentRefresh, setLastIncidentRefresh] = useState(Date());
    return (
        <MDBContainer className="pt-3 pb-3 home-container" fluid>
            <MDBRow className="h-100">
                <MDBCol xs="12" md="12" xl="6">
                    <MDBCard className="h-100 main-card">
                        <HeatMap
                            lastRefresh={lastMapRefresh}
                            setLastRefresh={setLastMapRefresh}
                        ></HeatMap>
                    </MDBCard>
                </MDBCol>
                <MDBCol xs="12" md="6" xl="3">
                    <MDBRow>
                        <MDBCard className="w-100 main-card">
                            <IncidentSummary
                                lastRefresh={lastSummaryRefresh}
                                setLastRefresh={setLastSummaryRefresh}
                            ></IncidentSummary>
                        </MDBCard>
                    </MDBRow>
                    <MDBRow className="pt-3">
                        <MDBCard className="w-100 main-card">
                            <UpcomingEvents
                                lastRefresh={lastEventRefresh}
                                setLastRefresh={setLastEventRefresh}
                            ></UpcomingEvents>
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
                        <IncidentsReported
                            lastRefresh={lastIncidentRefresh}
                            setLastRefresh={setLastIncidentRefresh}
                        ></IncidentsReported>
                    </MDBCard>
                </MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Home;
