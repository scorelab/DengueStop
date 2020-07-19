import React from "react";
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

const AnnualIncidentsChart = (props) => {
    const annualIncidentCount = props.annualIncidentCount;
    return (
        <MDBCard className="annual-incidents-chart-container px-5">
            <p className="text-center py-1 font-weight-bold">
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
