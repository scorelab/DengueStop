import React from "react";
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

const CommunityStats = (props) => {
    const verificationBreakdown = props.verificationBreakdown;
    const userBaseBreakdown = props.userBaseBreakdown;
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
                                        {/* <MDBDropdownItem
                                            onClick={() => {
                                                setAgeGroupIncidentCountFilter(
                                                    "all"
                                                );
                                            }}
                                        >
                                            All
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setAgeGroupIncidentCountFilter(
                                                    "weekly"
                                                );
                                            }}
                                        >
                                            Last 7 days
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setAgeGroupIncidentCountFilter(
                                                    "monthly"
                                                );
                                            }}
                                        >
                                            Last 30 days
                                        </MDBDropdownItem>
                                        <MDBDropdownItem
                                            onClick={() => {
                                                setAgeGroupIncidentCountFilter(
                                                    "yearly"
                                                );
                                            }}
                                        >
                                            Last Year
                                        </MDBDropdownItem> */}
                                    </MDBDropdownMenu>
                                </MDBDropdown>
                            </MDBCol>
                        </MDBRow>
                        <MDBRow>
                            <MDBCol className="border-right">
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center percent-text orange-text">
                                            98%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            12
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
                                            98%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            12
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
                                            98%
                                        </p>
                                    </MDBCol>
                                </MDBRow>
                                <MDBRow>
                                    <MDBCol>
                                        <p className="text-center count-text">
                                            12
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
                                            12
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
                                            12
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
