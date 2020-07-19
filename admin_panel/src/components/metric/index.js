import React, { useEffect } from "react";
import "./metric.css";
import { MDBContainer, MDBRow } from "mdbreact";

import AnnualIncidentsChart from "./annualIncidentsChart";

const Metric = (props) => {
    return (
        <MDBContainer className="metric-container" fluid>
            <MDBRow>
                <AnnualIncidentsChart />
            </MDBRow>

            <MDBRow></MDBRow>
        </MDBContainer>
    );
};

export default Metric;
