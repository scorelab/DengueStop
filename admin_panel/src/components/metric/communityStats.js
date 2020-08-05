import React, { useEffect, useState } from "react";
import {
    MDBCard,
    MDBRow,
    MDBCardBody,
    MDBCol,
    MDBDropdown,
    MDBDropdownToggle,
    MDBDropdownItem,
    MDBDropdownMenu,
    MDBIcon,
} from "mdbreact";
import IncidentService from "../../services/incidentService";
import AuthService from "../../services/authService";
import { getSession } from "../../services/sessionService";

const CommunityStats = () => {
    const currentUser = getSession();
    const incidentService = new IncidentService();
    const userService = new AuthService();
    const [
        verificationBreakdownCount,
        setVerificationBreakdownCount,
    ] = useState([]);
    const [userBaseBreakdownCount, setUserBaseBreakdownCount] = useState([]);

    const [
        verificationBreakdownCountFilter,
        setVerificationBreakdownCountFilter,
    ] = useState("all");

    useEffect(() => {
        const orgId = currentUser.org_id;
        incidentService
            .getIncidentVerificationBreakdown(
                orgId,
                verificationBreakdownCountFilter
            )
            .then((res) => {
                setVerificationBreakdownCount(res);
            });
    }, [verificationBreakdownCountFilter]);

    useEffect(() => {
        const orgId = currentUser.org_id;
        userService.getUserBaseBreakdown().then((res) => {
            setUserBaseBreakdownCount(res);
        });
    }, []);

    const extractCount = (type) => {
        return verificationBreakdownCount.map((data, index) => {
            if (data.name === type) {
                return data.count;
            }
        });
    };

    const extractUserCount = (type) => {
        return userBaseBreakdownCount.map((data, index) => {
            if (data.name === type) {
                return data.count;
            }
        });
    };

    const extractPercentage = (type) => {
        // calculates percentage
        var total = 0;
        var value = 0;
        verificationBreakdownCount.map((data, index) => {
            if (data.name === type) {
                value = data.count;
            }
            total += data.count;
        });
        const percentage = ((value / total) * 100).toFixed(2);
        return percentage;
    };

    return (
        <React.Fragment>
            <MDBRow className="flex-start p-2 flex-1">
                <MDBCard className="w-100">
                    <MDBCardBody>
                        <MDBRow>
                            <MDBCol size="10">
                                <p className="text-center m-0 font-weight-bold">
                                    Incident Verification Breakdown
                                </p>
                                <hr></hr>
                            </MDBCol>
                            <MDBCol size="2">
                                <MDBDropdown className="float-right" dropright>
                                    <MDBDropdownToggle
                                        className="black-text text-uppercase p-0"
                                        nav
                                        caret
                                    >
                                        <MDBIcon
                                            icon="filter"
                                            className="black-text"
                                        />
                                    </MDBDropdownToggle>
                                    <MDBDropdownMenu className="dropdown-default">
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setVerificationBreakdownCountFilter(
                                                    "all"
                                                );
                                            }}
                                        >
                                            All
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setVerificationBreakdownCountFilter(
                                                    "weekly"
                                                );
                                            }}
                                        >
                                            Last 7 days
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setVerificationBreakdownCountFilter(
                                                    "monthly"
                                                );
                                            }}
                                        >
                                            Last 30 days
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setVerificationBreakdownCountFilter(
                                                    "yearly"
                                                );
                                            }}
                                        >
                                            Last Year
                                        </MDBDropdownItem>
                                    </MDBDropdownMenu>
                                </MDBDropdown>
                            </MDBCol>
                        </MDBRow>
                        <MDBRow>
                            <MDBCol className="border-right">
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center percent-text orange-text">
                                            {extractPercentage("Pending")}%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            {extractCount("Pending")}
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center name-text">
                                            Pending
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                            <MDBCol className="border-right">
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center percent-text green-text">
                                            {extractPercentage("Verified")}%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            {extractCount("Verified")}
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center name-text">
                                            Verified
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                            <MDBCol>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center percent-text red-text">
                                            {extractPercentage("Declined")}%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            {extractCount("Declined")}
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center name-text">
                                            Declined
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                        </MDBRow>
                    </MDBCardBody>
                </MDBCard>
            </MDBRow>
            <MDBRow className="flex-end p-2 flex-1">
                <MDBCard className="w-100">
                    <MDBCardBody>
                        <MDBRow>
                            <MDBCol>
                                <p className="text-center m-0 font-weight-bold">
                                    User Base Breakdown
                                </p>
                                <hr></hr>
                            </MDBCol>
                        </MDBRow>
                        <MDBRow>
                            <MDBCol className="border-right">
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center user-count-text">
                                            {extractUserCount("User")}
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center name-text">
                                            Community Users
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                            <MDBCol>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center user-count-text">
                                            {extractUserCount("Admin")}
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center name-text">
                                            Admin Users
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                            </MDBCol>
                        </MDBRow>
                    </MDBCardBody>
                </MDBCard>
            </MDBRow>
        </React.Fragment>
    );
};

export default CommunityStats;
