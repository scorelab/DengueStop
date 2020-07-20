import React, { useEffect, useState } from "react";
import { MDBCard } from "mdbreact";
import { PieChart, Pie, ResponsiveContainer } from "recharts";

const AgeCategoryChart = (props) => {
    const thisData = [
        {
            name: "Group A",
            value: 400,
        },
        {
            name: "Group B",
            value: 300,
        },
        {
            name: "Group C",
            value: 300,
        },
        {
            name: "Group D",
            value: 200,
        },
        {
            name: "Group E",
            value: 278,
        },
        {
            name: "Group F",
            value: 189,
        },
    ];

    return (
        <MDBCard className="age-category-chart-container w-100 py-2 px-5">
            <p className="text-center m-0 font-weight-bold">
                Incidents Reported by Age Group
            </p>
            <hr></hr>
            <ResponsiveContainer width="100%" height={400}>
                <PieChart>
                    <Pie
                        data={thisData}
                        dataKey="value"
                        nameKey="name"
                        cx="50%"
                        cy="50%"
                        fill="#8884d8"
                        legendType="square"
                        isAnimationActive={true}
                    />
                </PieChart>
            </ResponsiveContainer>
        </MDBCard>
    );
};

export default AgeCategoryChart;
