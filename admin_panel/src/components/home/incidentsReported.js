import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
import IncidentCard from "./incidentCard";

const IncidentsReported = (props) => {
    const [incidents, setIncidents] = useState([]);

    useEffect(() => {
        const incidentService = new IncidentService();
        incidentService.getIncidentsByOrgId(1).then((res) => {
            setIncidents(res);
        });
    }, []);

    if (!incidents || incidents.length <= 0) {
        return <p>No incidents reported</p>;
    } else {
        const incidentArray = incidents.map((data, index) => {
            if (data) {
                return (
                    <IncidentCard
                        key={index}
                        index={index}
                        setIncidents={setIncidents}
                        incidents={incidents}
                    />
                );
            } else {
                return <p>No incidents reported</p>;
            }
        });
        return <div className="w-100">{incidentArray}</div>;
    }
};

export default IncidentsReported;
