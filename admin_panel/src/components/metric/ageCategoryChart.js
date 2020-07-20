import React, { useEffect, useState } from "react";
import {
    MDBCard,
    MDBDropdown,
    MDBCardFooter,
    MDBDropdownMenu,
    MDBDropdownItem,
    MDBDropdownToggle,
    MDBIcon,
    MDBRow,
    MDBCol,
} from "mdbreact";
import {
    PieChart,
    Pie,
    ResponsiveContainer,
    Legend,
    Tooltip,
    Cell,
} from "recharts";

const AgeCategoryChart = (props) => {
    const ageGroupIncidentCount = props.ageGroupIncidentCount;
    const setAgeGroupIncidentCountFilter = props.setAgeGroupIncidentCountFilter;
    const COLORS = ["#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600"];
    const RADIAN = Math.PI / 180;
    const renderCustomizedLabel = ({
        cx,
        cy,
        midAngle,
        innerRadius,
        outerRadius,
        percent,
        index,
    }) => {
        const radius = innerRadius + (outerRadius - innerRadius) * 0.5;
        const x = cx + radius * Math.cos(-midAngle * RADIAN);
        const y = cy + radius * Math.sin(-midAngle * RADIAN);
        if (percent !== 0) {
            return (
                <text
                    x={x}
                    y={y}
                    fill="white"
                    textAnchor={x > cx ? "start" : "end"}
                    dominantBaseline="central"
                >
                    {`${(percent * 100).toFixed(0)}%`}
                </text>
            );
        }
    };

    return (
        <MDBCard className="age-category-chart-container w-100 py-2 px-5">
            <MDBRow>
                <MDBCol size="10">
                    <p className="text-center m-0 font-weight-bold float">
                        Incidents Reported by Age Group
                    </p>
                </MDBCol>
                <MDBCol size="2">
                    <MDBDropdown className="float-right" dropright>
                        <MDBDropdownToggle
                            className="black-text text-uppercase p-0"
                            nav
                            caret
                        >
                            <MDBIcon icon="filter" className="black-text" />
                        </MDBDropdownToggle>
                        <MDBDropdownMenu className="dropdown-default">
                            <MDBDropdownItem
                                onClick={() => {
                                    setAgeGroupIncidentCountFilter("all");
                                }}
                            >
                                All
                            </MDBDropdownItem>
                            <MDBDropdownItem
                                onClick={() => {
                                    setAgeGroupIncidentCountFilter("weekly");
                                }}
                            >
                                Last 7 days
                            </MDBDropdownItem>
                            <MDBDropdownItem
                                onClick={() => {
                                    setAgeGroupIncidentCountFilter("monthly");
                                }}
                            >
                                Last 30 days
                            </MDBDropdownItem>
                            <MDBDropdownItem
                                onClick={() => {
                                    setAgeGroupIncidentCountFilter("yearly");
                                }}
                            >
                                Last Year
                            </MDBDropdownItem>
                        </MDBDropdownMenu>
                    </MDBDropdown>
                </MDBCol>
            </MDBRow>
            <hr></hr>
            <ResponsiveContainer width="100%" height={400}>
                <PieChart>
                    <Pie
                        data={ageGroupIncidentCount}
                        isAnimationActive={false}
                        dataKey="count"
                        nameKey="range"
                        label={renderCustomizedLabel}
                        cx="50%"
                        cy="50%"
                        fill="#8884d8"
                    >
                        {ageGroupIncidentCount.map((entry, index) => (
                            <Cell
                                key={index}
                                fill={COLORS[index % COLORS.length]}
                            />
                        ))}
                    </Pie>
                    <Tooltip />
                    <Legend iconType="circle" />
                </PieChart>
            </ResponsiveContainer>
        </MDBCard>
    );
};

export default AgeCategoryChart;
