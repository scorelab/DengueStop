import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
import IncidentCard from "./incidentCard";
import Moment from "react-moment";
import { MDBCardBody, MDBCardTitle, MDBCardFooter } from "mdbreact";
import { getSession } from "../../services/sessionService";

const IncidentsReported = (props) => {
    const [incidents, setIncidents] = useState([]);
    const setLastRefresh = props.setLastRefresh;
    const lastRefresh = props.lastRefresh;
    const currentUser = getSession();

    const getIncidentData = () => {
        const incidentService = new IncidentService();
        incidentService
            .getPendingIncidentsByOrgId(currentUser.org_id)
            .then((res) => {
                setIncidents(res);
                setLastRefresh(Date());
            });
    };

    useEffect(() => {
        getIncidentData();
    }, []);

    return (
        <React.Fragment>
            <MDBCardBody className="pb-0 px-1">
                <MDBCardTitle className="card-title">
                    <b>Pending Reports</b>
                </MDBCardTitle>
                <div className="mt-1 incident-array-container">
                    <IncidentData
                        incidents={incidents}
                        setIncidents={setIncidents}
                    ></IncidentData>
                </div>
            </MDBCardBody>
            <MDBCardFooter className="thin-footer">
                <span>
                    <a
                        href="#!"
                        onClick={() => getIncidentData()}
                        className="px-1 last-refresh-text float-left font-weight-bold"
                    >
                        Update
                    </a>
                    <p className="px-1 last-refresh-text float-right">
                        Updated <Moment fromNow>{lastRefresh}</Moment>
                    </p>
                </span>
            </MDBCardFooter>
        </React.Fragment>
    );
};

const IncidentData = (props) => {
    const incidents = props.incidents;
    const setIncidents = props.setIncidents;

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
