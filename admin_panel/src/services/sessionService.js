import React from "react";
import { Redirect } from "react-router-dom";

export const setSession = (session) => {
    const token = session.token;
    const userData = JSON.stringify(session.userData);
    sessionStorage.setItem("token", token);
    sessionStorage.setItem("userData", userData);
};

export const getSession = () => {
    const userData = sessionStorage.getItem("userData");

    if (userData === undefined) {
        return {};
    } else {
        return JSON.parse(userData);
    }
};

export const hasToken = () => {
    // checks if token is available
    const token = getToken();
    return !!token;
};

export const getToken = () => {
    // returns the token
    return sessionStorage.getItem("token");
};

export const endSession = () => {
    sessionStorage.clear();
};

export const ProtectedHandler = ({ history }) => {
    const session = getSession();
    // checks if the session details are there
    if (session && session.email) {
        // redirect home if session is there
        return <Redirect to="/dash/home" />;
    }
    // redirect to login else
    return <Redirect to="/login" />;
};

export const SessionContext = React.createContext(getSession());
