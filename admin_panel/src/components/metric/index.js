import React, { useEffect, useState } from "react";
import "./metric.css";
import { MDBContainer, MDBRow } from "mdbreact";
import IncidentService from "../../services/incidentService";
import AnnualIncidentsChart from "./annualIncidentsChart";

const Metric = (props) => {
    const incidentService = new IncidentService();
    const [annualIncidentCount, setAnnualIncidentCount] = useState([]);

    useEffect(() => {
        // todo get orgId from user data
        const orgId = 1;
        incidentService.getMonthlyIncidentCount(orgId).then((res) => {
            setAnnualIncidentCount(res);
        });
    }, []);

    return (
        <MDBContainer className="metric-container" fluid>
            <MDBRow>
                <AnnualIncidentsChart
                    annualIncidentCount={annualIncidentCount}
                />
            </MDBRow>

            <MDBRow></MDBRow>
        </MDBContainer>
    );
};

export default Metric;
