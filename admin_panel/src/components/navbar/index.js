import React, { Component, useState, useEffect } from "react";
import {
    MDBContainer,
    MDBBtn,
    MDBModal,
    MDBModalBody,
    MDBCol,
    MDBRow,
    MDBModalHeader,
    MDBModalFooter,
    MDBNavbar,
    MDBNavbarBrand,
    MDBNavbarNav,
    MDBNavItem,
    MDBNavLink,
    MDBNavbarToggler,
    MDBCollapse,
    MDBDropdown,
    MDBDropdownToggle,
    MDBDropdownMenu,
    MDBDropdownItem,
    MDBIcon,
} from "mdbreact";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Home from "../home";
import Metric from "../metric";
import Event from "../event";
import Patient from "../patient";
import { ProtectedHandler, endSession } from "../../services/sessionService";
import AuthRoute from "../../utils/authRoute";

const Navbar = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    const [logoutDialogue, setLogoutDialogue] = useState(false);
    const toggleCollapse = () => {
        setIsOpen(!isOpen);
    };

    const logoutPrompt = () => {
        setLogoutDialogue(true);
    };

    const logoutUser = () => {
        endSession();
        props.history.push("/login");
    };

    const LogoutPromptDialogue = (props) => {
        return (
            <MDBContainer>
                <MDBModal
                    modalStyle="danger"
                    className="text-white"
                    size="sm"
                    centered
                    position="top-center"
                    isOpen={logoutDialogue}
                    toggle={() => setLogoutDialogue(false)}
                >
                    <MDBModalHeader
                        className="text-center"
                        titleClass="w-100"
                        tag="p"
                    >
                        Logging Out?
                    </MDBModalHeader>
                    <MDBModalBody className="text-center">
                        <MDBIcon
                            icon="times"
                            size="4x"
                            className="animated rotateIn"
                        />
                        <h5>Do you want to log out?</h5>
                    </MDBModalBody>
                    <MDBModalFooter className="justify-content-center">
                        <MDBBtn
                            color="danger"
                            onClick={() => {
                                logoutUser();
                            }}
                        >
                            Yes
                        </MDBBtn>
                        <MDBBtn
                            color="danger"
                            outline
                            onClick={() => setLogoutDialogue(false)}
                        >
                            No
                        </MDBBtn>
                    </MDBModalFooter>
                </MDBModal>
            </MDBContainer>
        );
    };

    return (
        <Router>
            <LogoutPromptDialogue isOpen={logoutDialogue} />
            <MDBNavbar color="unique-color" dark expand="md">
                <MDBNavbarBrand>
                    <strong className="white-text">Dengue Stop</strong>
                </MDBNavbarBrand>
                <MDBNavbarToggler onClick={() => toggleCollapse()} />
                <MDBCollapse id="navbarCollapse3" isOpen={isOpen} navbar>
                    <MDBNavbarNav left>
                        <MDBNavItem>
                            <MDBNavLink to="/dash/home">Home</MDBNavLink>
                        </MDBNavItem>
                        <MDBNavItem>
                            <MDBNavLink to="/dash/metric">Metrics</MDBNavLink>
                        </MDBNavItem>
                        <MDBNavItem>
                            <MDBNavLink to="/dash/patient">Patients</MDBNavLink>
                        </MDBNavItem>
                        <MDBNavItem>
                            <MDBNavLink to="/dash/event">Events</MDBNavLink>
                        </MDBNavItem>
                    </MDBNavbarNav>
                    <MDBNavbarNav right>
                        <MDBNavItem>
                            <MDBDropdown>
                                <MDBDropdownToggle nav caret>
                                    <MDBIcon icon="globe" />
                                </MDBDropdownToggle>
                                <MDBDropdownMenu className="dropdown-default">
                                    <MDBDropdownItem href="#!">
                                        English
                                    </MDBDropdownItem>
                                    <MDBDropdownItem href="#!">
                                        Sinhala
                                    </MDBDropdownItem>
                                </MDBDropdownMenu>
                            </MDBDropdown>
                        </MDBNavItem>
                        <MDBNavItem>
                            <MDBNavLink
                                className="waves-effect waves-light"
                                to="#!"
                            >
                                <MDBIcon
                                    icon="sign-out-alt"
                                    onClick={() => logoutPrompt()}
                                />
                            </MDBNavLink>
                        </MDBNavItem>
                    </MDBNavbarNav>
                </MDBCollapse>
            </MDBNavbar>
            <Switch>
                <AuthRoute exact path="/dash/home" component={Home} />
                <AuthRoute exact path="/dash/metric" component={Metric} />
                <AuthRoute exact path="/dash/patient" component={Patient} />
                <AuthRoute exact path="/dash/event" component={Event} />
                <Route path="*" component={ProtectedHandler} />
            </Switch>
        </Router>
    );
};

export default Navbar;
