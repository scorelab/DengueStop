import React, { useState, useEffect } from "react";
import IncidentService from "../../services/incidentService";
import { MDBRow, MDBCol } from "mdbreact";

const IncidentsSummary = (props) => {
    const [summaries, setSummaries] = useState([]);

    useEffect(() => {
        const incidentService = new IncidentService();
        incidentService.getTotalIncidentSummary().then((res) => {
            setSummaries(res);
        });
    }, []);
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
