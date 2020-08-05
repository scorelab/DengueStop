import React, { useState, useEffect } from "react";
import {
    LineChart,
    Line,
    CartesianGrid,
    XAxis,
    YAxis,
    ResponsiveContainer,
    Tooltip,
} from "recharts";
import { MDBCard, MDBCardBody } from "mdbreact";
import IncidentService from "../../services/incidentService";
import { getSession } from "../../services/sessionService";

const AnnualIncidentsChart = () => {
    const currentUser = getSession();
    const incidentService = new IncidentService();
    const [annualIncidentCount, setAnnualIncidentCount] = useState([]);

    useEffect(() => {
        const orgId = currentUser.org_id;
        incidentService.getMonthlyIncidentCount(orgId).then((res) => {
            setAnnualIncidentCount(res);
        });
    }, []);

    return (
        <MDBCard className="annual-incidents-chart-container">
            <MDBCardBody>
                <p className="text-center font-weight-bold">
                    Dengue Incidents Reported Over the year
                </p>
                <ResponsiveContainer width="100%" height={250}>
                    <LineChart data={annualIncidentCount}>
                        <XAxis dataKey="name" />
                        <YAxis />
                        <Tooltip />
                        <Line
                            type="monotone"
                            dataKey="count"
                            strokeWidth={3}
                            stroke="#0783EC"
                            fill="#0783EC"
                        />
                    </LineChart>
                </ResponsiveContainer>
            </MDBCardBody>
        </MDBCard>
    );
};

export default AnnualIncidentsChart;
