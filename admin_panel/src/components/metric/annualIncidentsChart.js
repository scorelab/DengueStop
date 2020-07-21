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
import { MDBCard } from "mdbreact";
import IncidentService from "../../services/incidentService";

const AnnualIncidentsChart = () => {
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
        <MDBCard className="annual-incidents-chart-container py-2 px-5">
            <p className="text-center font-weight-bold">
                Dengue Incidents Reported Over the year
            </p>
            <ResponsiveContainer width="100%" height={250}>
                <LineChart data={annualIncidentCount}>
                    <Line
                        type="monotone"
                        dataKey="count"
                        strokeWidth="3"
                        stroke="#0783EC"
                    />
                    <CartesianGrid
                        stroke="#ccc"
                        vertical={false}
                        horizontal={false}
                    />
                    <XAxis tickLine={false} axisLine={true} dataKey="name" />
                    <YAxis tickLine={false} axisLine={true} />
                    <Tooltip />
                </LineChart>
            </ResponsiveContainer>
        </MDBCard>
    );
};

export default AnnualIncidentsChart;
