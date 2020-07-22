import React, { useEffect, useState } from "react";
import {
    MDBCard,
    MDBDropdown,
    MDBDropdownMenu,
    MDBDropdownItem,
    MDBDropdownToggle,
    MDBIcon,
    MDBRow,
    MDBCol,
    MDBCardFooter,
    MDBCardBody,
} from "mdbreact";
import {
    PieChart,
    Pie,
    ResponsiveContainer,
    Legend,
    Tooltip,
    Cell,
} from "recharts";
import IncidentService from "../../services/incidentService";

const StatusCategoryChart = (props) => {
    const incidentService = new IncidentService();
    const [statusIncidentCount, setStatusIncidentCount] = useState([]);
    const [statusIncidentCountFilter, setStatusIncidentCountFilter] = useState(
        "all"
    );
    const COLORS = ["#E67F0D", "#40BCD8", "#1C77C3", "#157145", "#BD1E1E"];
    const RADIAN = Math.PI / 180;
    const renderCustomizedLabel = ({
        cx,
        cy,
        midAngle,
        innerRadius,
        outerRadius,
        percent,
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

    const getFilterText = (filter) => {
        if (filter === "all") return "Showing results of all time";
        else if (filter === "weekly") return "Showing results from last 7 days";
        else if (filter === "monthly")
            return "Showing results from last 30 days";
        else if (filter === "yearly")
            return "Showing results from last 365 days";
        else return "";
    };

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
        <MDBCard className="age-category-chart-container w-100">
            <MDBCardBody>
                <MDBRow>
                    <MDBCol size="10">
                        <p className="text-center m-0 font-weight-bold float">
                            Incident Status Breakdown
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
                                        setStatusIncidentCountFilter("all");
                                    }}
                                >
                                    All
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setStatusIncidentCountFilter("weekly");
                                    }}
                                >
                                    Last 7 days
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setStatusIncidentCountFilter("monthly");
                                    }}
                                >
                                    Last 30 days
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setStatusIncidentCountFilter("yearly");
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
                            data={statusIncidentCount}
                            dataKey="count"
                            nameKey="name"
                            label={renderCustomizedLabel}
                            innerRadius={80}
                            cx="50%"
                            cy="50%"
                            fill="#8884d8"
                        >
                            {statusIncidentCount.map((entry, index) => (
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
            </MDBCardBody>
            <MDBCardFooter className="thin-footer text-center font-weight-bold">
                {getFilterText(statusIncidentCountFilter)}
            </MDBCardFooter>
        </MDBCard>
    );
};

export default StatusCategoryChart;
