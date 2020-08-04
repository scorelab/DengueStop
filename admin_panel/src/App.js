import React, { useContext } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import "./App.css";
import { createBrowserHistory } from "history";
import Login from "./components/login";
import Navbar from "./components/navbar";
import AuthRoute from "./utils/authRoute";
import { ProtectedHandler } from "./services/sessionService";
import Home from "./components/home";

const history = createBrowserHistory();

const Routes = () => {
    return (
        <Router history={history}>
            <Switch>
                <Route exact path="/login" component={Login} />
                <AuthRoute path="/dash" component={Navbar} />
                <Route path="*" component={ProtectedHandler} />
            </Switch>
        </Router>
    );
};

function App() {
    return (
        <div>
            <Routes />
        </div>
    );
}

export default App;
