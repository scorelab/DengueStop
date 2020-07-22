import React from "react";
import "./metric.css";
import { MDBContainer, MDBRow, MDBCol } from "mdbreact";
import AnnualIncidentsChart from "./annualIncidentsChart";
import AgeCategoryChart from "./ageCategoryChart";
import StatusCategoryChart from "./statusCategoryChart";
import CommunityStats from "./communityStats";
import ProvinceStatusRadarChart from "./provinceStatusRadarChart";

const Metric = (props) => {
    return (
        <MDBContainer className="metric-container" fluid>
            <MDBRow>
                <AnnualIncidentsChart />
            </MDBRow>
            <MDBRow>
                <MDBCol sm="12" md="6" xl="3" className="pl-3 p-2 d-flex">
                    <AgeCategoryChart />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3" className="p-2 d-flex">
                    <StatusCategoryChart />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3" className="p-2 d-flex">
                    <ProvinceStatusRadarChart />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3" className="d-flex flex-column">
                    <CommunityStats />
                </MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Metric;
