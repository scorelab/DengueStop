import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
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
    MDBCardBody,
} from "mdbreact";
import {
    ResponsiveContainer,
    Radar,
    RadarChart,
    PolarGrid,
    PolarAngleAxis,
    Tooltip,
} from "recharts";

const ProvinceStatusRadarChart = () => {
    const incidentService = new IncidentService();
    const [provinceStatusCount, setProvinceStatusCount] = useState([]);
    const [provinceStatusCountFilter, setProvinceStatusCountFilter] = useState(
        "all"
    );

    useEffect(() => {
        incidentService
            .getProvinceVsStatusCount(provinceStatusCountFilter)
            .then((res) => {
                console.log(res);
                setProvinceStatusCount(res);
            });
    }, [provinceStatusCountFilter]);

    const getFilterText = (filter) => {
        if (filter === "all") return "Showing results of all time";
        else if (filter === "weekly") return "Showing results from last 7 days";
        else if (filter === "monthly")
            return "Showing results from last 30 days";
        else if (filter === "yearly")
            return "Showing results from last 365 days";
        else return "";
    };

    return (
        <MDBCard className=" w-100">
            <MDBCardBody>
                <MDBRow>
                    <MDBCol size="10">
                        <p className="text-center m-0 font-weight-bold float">
                            Incidents Status Across All Provinces
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
                                        setProvinceStatusCountFilter("all");
                                    }}
                                >
                                    All
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setProvinceStatusCountFilter("weekly");
                                    }}
                                >
                                    Last 7 days
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setProvinceStatusCountFilter("monthly");
                                    }}
                                >
                                    Last 30 days
                                </MDBDropdownItem>
                                <MDBDropdownItem
                                    onClick={() => {
                                        setProvinceStatusCountFilter("yearly");
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
                    <RadarChart
                        margin={{ top: 5, right: 5, bottom: 5, left: 5 }}
                        data={provinceStatusCount}
                    >
                        <PolarGrid />
                        <PolarAngleAxis dataKey="province" />
                        <Radar
                            name="Pending Verification"
                            dataKey="Pending Verification"
                            stroke="#8884d8"
                            fill="#8884d8"
                            fillOpacity={0.8}
                        />
                        <Radar
                            name="Pending Treatment"
                            dataKey="Pending Treatment"
                            stroke="#E67F0D"
                            fill="#E67F0D"
                            fillOpacity={0.6}
                        />
                        <Radar
                            name="Under Treatment"
                            dataKey="Under Treatment"
                            stroke="#40BCD8"
                            fill="#40BCD8"
                            fillOpacity={0.6}
                        />
                        <Radar
                            name="Recovering"
                            dataKey="Recovering"
                            stroke="#1C77C3"
                            fill="#1C77C3"
                            fillOpacity={0.6}
                        />
                        <Radar
                            name="Recovered"
                            dataKey="Recovered"
                            stroke="#82ca9d"
                            fill="#82ca9d"
                            fillOpacity={0.6}
                        />
                        <Radar
                            name="Death"
                            dataKey="Death"
                            stroke="#BD1E1E"
                            fill="#BD1E1E"
                            fillOpacity={0.6}
                        />
                        <Radar
                            name="Declined"
                            dataKey="Declined"
                            stroke="#3E4C5E"
                            fill="#3E4C5E"
                            fillOpacity={0.6}
                        />
                        <Tooltip />
                    </RadarChart>
                </ResponsiveContainer>
            </MDBCardBody>
            <MDBCardFooter className="thin-footer text-center font-weight-bold">
                {getFilterText(provinceStatusCountFilter)}
            </MDBCardFooter>
        </MDBCard>
    );
};

export default ProvinceStatusRadarChart;
