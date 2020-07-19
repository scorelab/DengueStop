import React from "react";
import {
    LineChart,
    Line,
    CartesianGrid,
    XAxis,
    YAxis,
    ResponsiveContainer,
} from "recharts";
import { MDBCard } from "mdbreact";

const data = [
    { name: "Page A", uv: 400, pv: 2400, amt: 2400 },
    { name: "Page A", uv: 60, pv: 2400, amt: 2400 },
];

const AnnualIncidentsChart = (props) => {
    return (
        <MDBCard className="annual-incidents-chart-container px-5">
            <p className="text-center py-1">
                Dengue Incidents Reported Over the year
            </p>
            <ResponsiveContainer width="100%" height={250}>
                <LineChart data={data}>
                    <Line type="monotone" dataKey="uv" stroke="#8884d8" />
                    <CartesianGrid stroke="#ccc" />
                    <XAxis dataKey="name" />
                    <YAxis />
                </LineChart>
            </ResponsiveContainer>
        </MDBCard>
    );
};

export default AnnualIncidentsChart;
