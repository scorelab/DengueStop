import React, { useEffect, useState } from "react";
import {
    MDBContainer,
    MDBCard,
    MDBCardBody,
    MDBRow,
    MDBCol,
    MDBInput,
    MDBBtn,
} from "mdbreact";
import "./login.css";

const Login = (props) => {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    useEffect(() => {
        console.log(username);
    }, [username]);

    return (
        <MDBContainer className="login-main-container" fluid>
            <MDBRow className="h-100">
                <MDBCol sm="1" md="1" lg="2"></MDBCol>
                <MDBCol sm="10" md="10" lg="8">
                    <MDBCard className="login-card p-0 m-0">
                        <MDBCardBody className="p-0 m-0">
                            <MDBRow className="h-100 p-0 m-0">
                                <MDBCol className="splash-overlay p-0 m-0">
                                    <div className="login-splash-panel"></div>
                                </MDBCol>
                                <MDBCol className="p-5 m-0">
                                    <MDBRow>
                                        <MDBCol>
                                            <h3 className="my-5 text-center font-weight-bolder">
                                                Welcome to Dengue-Stop
                                            </h3>
                                        </MDBCol>
                                    </MDBRow>
                                    <MDBRow>
                                        <MDBCol>
                                            <div className="form-group text-center mt-5 px-5">
                                                <label>Username</label>
                                                <input
                                                    value={username}
                                                    type="text"
                                                    className="form-control form-control-lg"
                                                    onChange={(event) =>
                                                        setUsername(
                                                            event.target.value
                                                        )
                                                    }
                                                />
                                            </div>
                                        </MDBCol>
                                    </MDBRow>
                                    <MDBRow>
                                        <MDBCol>
                                            <div className="form-group text-center mt-4 px-5">
                                                <label>Password</label>
                                                <input
                                                    value={password}
                                                    type="password"
                                                    className="form-control form-control-lg"
                                                    onChange={(event) =>
                                                        setPassword(
                                                            event.target.value
                                                        )
                                                    }
                                                />
                                            </div>
                                        </MDBCol>
                                    </MDBRow>
                                    <MDBRow>
                                        <MDBCol>
                                            <div className="mt-5 px-5">
                                                <MDBBtn size="lg" block>
                                                    Sign in
                                                </MDBBtn>
                                            </div>
                                        </MDBCol>
                                    </MDBRow>
                                </MDBCol>
                            </MDBRow>
                        </MDBCardBody>
                    </MDBCard>
                </MDBCol>
                <MDBCol sm="1" md="1" lg="2"></MDBCol>
            </MDBRow>
        </MDBContainer>
    );
};

export default Login;
