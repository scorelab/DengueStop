import React, { useEffect, useState } from "react";
import "./metric.css";
import { MDBContainer, MDBRow, MDBCol } from "mdbreact";
import IncidentService from "../../services/incidentService";
import AnnualIncidentsChart from "./annualIncidentsChart";
import AgeCategoryChart from "./ageCategoryChart";
import StatusCategoryChart from "./statusCategoryChart";

const Metric = (props) => {
    const incidentService = new IncidentService();
    const [annualIncidentCount, setAnnualIncidentCount] = useState([]);
    const [ageGroupIncidentCount, setAgeGroupIncidentCount] = useState([]);
    const [statusIncidentCount, setStatusIncidentCount] = useState([]);
    const [
        ageGroupIncidentCountFilter,
        setAgeGroupIncidentCountFilter,
    ] = useState("all");
    const [statusIncidentCountFilter, setStatusIncidentCountFilter] = useState(
        "all"
    );

    useEffect(() => {
        // todo get orgId from user data
        const orgId = 1;
        incidentService.getMonthlyIncidentCount(orgId).then((res) => {
            setAnnualIncidentCount(res);
        });
    }, []);

    useEffect(() => {
        // todo get orgId from user data
        const orgId = 1;
        incidentService
            .getIncidentAgeGroupCount(orgId, ageGroupIncidentCountFilter)
            .then((res) => {
                setAgeGroupIncidentCount(res);
            });
    }, [ageGroupIncidentCountFilter]);

    return (
        <MDBContainer className="metric-container" fluid>
            <MDBRow>
                <AnnualIncidentsChart
                    annualIncidentCount={annualIncidentCount}
                />
            </MDBRow>
            <MDBRow>
                <MDBCol size="3">
                    <AgeCategoryChart
                        ageGroupIncidentCount={ageGroupIncidentCount}
                        setAgeGroupIncidentCountFilter={
                            setAgeGroupIncidentCountFilter
                        }
                    />
                </MDBCol>
                <MDBCol size="3">
                    <StatusCategoryChart
                        statusIncidentCount={statusIncidentCount}
                        setStatusIncidentCountFilter={
                            setStatusIncidentCountFilter
                        }
                    />
                </MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Metric;
