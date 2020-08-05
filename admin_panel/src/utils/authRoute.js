import React from "react";
import { Route, Redirect } from "react-router-dom";
import { getSession } from "../services/sessionService";

const AuthRoute = ({ component: Component, ...rest }) => {
    const session = getSession();
    var authenticated = false;
    if (session && session.email) {
        authenticated = true;
    } else {
        authenticated = false;
    }
    return (
        <Route
            {...rest}
            render={(props) =>
                authenticated ? (
                    <Component {...props} />
                ) : (
                    <Redirect to="/login" />
                )
            }
        />
    );
};

export default AuthRoute;
