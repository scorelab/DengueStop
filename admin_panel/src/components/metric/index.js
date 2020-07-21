import React, { useEffect, useState } from "react";
import "./metric.css";
import { MDBContainer, MDBRow, MDBCol } from "mdbreact";
import IncidentService from "../../services/incidentService";
import AnnualIncidentsChart from "./annualIncidentsChart";
import AgeCategoryChart from "./ageCategoryChart";
import StatusCategoryChart from "./statusCategoryChart";
import CommunityStats from "./communityStats";
import UserService from "../../services/userService";

const Metric = (props) => {
    const incidentService = new IncidentService();
    const userService = new UserService();
    const [annualIncidentCount, setAnnualIncidentCount] = useState([]);
    const [ageGroupIncidentCount, setAgeGroupIncidentCount] = useState([]);
    const [statusIncidentCount, setStatusIncidentCount] = useState([]);
    const [
        verificationBreakdownCount,
        setVerificationBreakdownCount,
    ] = useState([]);
    const [
        ageGroupIncidentCountFilter,
        setAgeGroupIncidentCountFilter,
    ] = useState("all");
    const [statusIncidentCountFilter, setStatusIncidentCountFilter] = useState(
        "all"
    );
    const [
        verificationBreakdownCountFilter,
        setVerificationBreakdownCountFilter,
    ] = useState("all");

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

    useEffect(() => {
        // todo get orgId from user data
        const orgId = 1;
        incidentService
            .getIncidentStatusCount(orgId, statusIncidentCountFilter)
            .then((res) => {
                setStatusIncidentCount(res);
            });
    }, [statusIncidentCountFilter]);

    return (
        <MDBContainer className="metric-container" fluid>
            <MDBRow>
                <AnnualIncidentsChart
                    annualIncidentCount={annualIncidentCount}
                />
            </MDBRow>
            <MDBRow>
                <MDBCol sm="12" md="6" xl="3" className="pl-3 p-2 d-flex">
                    <AgeCategoryChart
                        ageGroupIncidentCount={ageGroupIncidentCount}
                        ageGroupIncidentCountFilter={
                            ageGroupIncidentCountFilter
                        }
                        setAgeGroupIncidentCountFilter={
                            setAgeGroupIncidentCountFilter
                        }
                    />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3" className="p-2 d-flex">
                    <StatusCategoryChart
                        statusIncidentCount={statusIncidentCount}
                        statusIncidentCountFilter={statusIncidentCountFilter}
                        setStatusIncidentCountFilter={
                            setStatusIncidentCountFilter
                        }
                    />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3" className="d-flex flex-column">
                    <CommunityStats
                        verificationBreakdownCount={verificationBreakdownCount}
                        verificationBreakdownCountFilter={
                            verificationBreakdownCountFilter
                        }
                        setVerificationBreakdownCountFilter={
                            setVerificationBreakdownCountFilter
                        }
                    />
                </MDBCol>
                <MDBCol sm="12" md="6" xl="3"></MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Metric;
