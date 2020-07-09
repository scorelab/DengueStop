import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
import IncidentCard from "./incidentCard";

const IncidentsSummary = (props) => {
    useEffect(() => {
        const incidentService = new IncidentService();
        incidentService.getTotalIncidentSummary().then((res) => {
            console.log(res);
        });
    }, []);

    return <h1>Summary</h1>;
};

export default IncidentsSummary;
