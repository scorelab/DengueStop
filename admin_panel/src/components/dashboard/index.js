import React, { Component } from "react";
import { BrowserRouter as Router } from "react-router-dom";
import Navbar from "../navbar/index";

class Dashboard extends Component {
  render() {
    return (
      <Router>
        <Navbar />
      </Router>
    );
  }
}

export default Dashboard;
