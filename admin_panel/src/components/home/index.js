import React, { Component } from "react";
import "./home.css";
import IncidentsReported from "./incidentsReported";
import {
    MDBContainer,
    MDBRow,
    MDBCol,
    MDBCard,
    MDBCardBody,
    MDBCardTitle,
} from "mdbreact";

class Home extends Component {
    render() {
        return (
            <MDBContainer className="pt-3 pb-3 home-container" fluid>
                <MDBRow className="h-100">
                    <MDBCol xs="12" md="12" xl="5">
                        <MDBCard className="h-100 main-card">
                            <MDBCardBody>
                                <MDBCardTitle className="card-title">
                                    <b>Dengue Heat Map</b>
                                </MDBCardTitle>
                            </MDBCardBody>
                        </MDBCard>
                    </MDBCol>
                    <MDBCol xs="12" md="6" xl="4">
                        <MDBRow>
                            <MDBCard className="w-100 main-card">
                                <MDBCardBody>
                                    <MDBCardTitle className="card-title">
                                        <b>Incident Summary</b>
                                    </MDBCardTitle>
                                </MDBCardBody>
                            </MDBCard>
                        </MDBRow>
                        <MDBRow className="pt-3">
                            <MDBCard className="w-100 main-card">
                                <MDBCardBody>
                                    <MDBCardTitle className="card-title">
                                        <b>Upcoming Events</b>
                                    </MDBCardTitle>
                                </MDBCardBody>
                            </MDBCard>
                        </MDBRow>
                    </MDBCol>
                    <MDBCol xs="12" md="6" xl="3">
                        <MDBCard className="main-card h-100 align-content-stretch">
                            <MDBCardBody>
                                <MDBCardTitle className="card-title">
                                    <b>Pending Reports</b>
                                </MDBCardTitle>
                                <MDBRow className="mt-1 incident-array-container">
                                    <IncidentsReported></IncidentsReported>
                                </MDBRow>
                            </MDBCardBody>
                        </MDBCard>
                    </MDBCol>
                </MDBRow>
            </MDBContainer>
        );
    }
}

export default Home;
