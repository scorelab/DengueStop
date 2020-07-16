import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
import Moment from "react-moment";
import {
    MDBRow,
    MDBCol,
    MDBCardBody,
    MDBCardTitle,
    MDBCardFooter,
} from "mdbreact";

const IncidentsSummary = (props) => {
    const [summaries, setSummaries] = useState([]);
    const setLastRefresh = props.setLastRefresh;
    const lastRefresh = props.lastRefresh;

    const getSummaryData = () => {
        const incidentService = new IncidentService();
        incidentService.getTotalIncidentSummary().then((res) => {
            setSummaries(res);
            setLastRefresh(Date());
        });
    };

    useEffect(() => {
        getSummaryData();
    }, []);

    return (
        <React.Fragment>
            <MDBCardBody>
                <MDBCardTitle className="card-title">
                    <b>Incident Summary</b>
                </MDBCardTitle>
                <div className="mt-1 summary-array-container">
                    <SummaryData summaries={summaries}></SummaryData>
                </div>
            </MDBCardBody>
            <MDBCardFooter className="thin-footer">
                <span>
                    <a
                        href="#!"
                        onClick={() => getSummaryData()}
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

const SummaryData = (props) => {
    const summaries = props.summaries;

    if (!summaries || summaries.length <= 0) {
        return <p>No incidents reported</p>;
    } else {
        const summaryArray = summaries.map((data, index) => {
            if (data) {
                return (
                    <SummaryRow key={index} name={data[0]} count={data[1]} />
                );
            } else {
                return <p>No incidents reported</p>;
            }
        });
        return summaryArray;
    }
};

const SummaryRow = (props) => {
    const name = props.name;
    const count = props.count;
    return (
        <React.Fragment>
            <MDBRow className="mt-3 px-3 w-100">
                <MDBCol size="7" className="text-left">
                    <b>{name} Province</b>
                </MDBCol>
                <MDBCol className="text-right">
                    <b>
                        {count}
                        {count > 1 ? " Incidents" : " Incident"}
                    </b>
                </MDBCol>
            </MDBRow>
        </React.Fragment>
    );
};

export default IncidentsSummary;
