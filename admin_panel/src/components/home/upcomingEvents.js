import React, { useState, useEffect, useContext } from "react";
import EventService from "../../services/eventService";
import EventCard from "./eventCard";
import Moment from "react-moment";
import { MDBCardBody, MDBCardTitle, MDBCardFooter } from "mdbreact";
import { getSession } from "../../services/sessionService";

const UpcomingEvents = (props) => {
    const [events, setEvents] = useState([]);
    const setLastRefresh = props.setLastRefresh;
    const lastRefresh = props.lastRefresh;
    const currentUser = getSession();

    useEffect(() => {
        getEventData();
    }, []);

    const getEventData = () => {
        const eventService = new EventService();
        eventService.getEventsByOrgId(currentUser.org_id).then((res) => {
            setEvents(res);
            setLastRefresh(Date());
        });
    };

    return (
        <React.Fragment>
            <MDBCardBody className="pb-0 px-1">
                <MDBCardTitle className="card-title">
                    <b>Upcoming Events</b>
                </MDBCardTitle>
                <div className="mt-1 event-array-container">
                    <EventData events={events}></EventData>
                </div>
            </MDBCardBody>
            <MDBCardFooter className="thin-footer">
                <span>
                    <a
                        href="#!"
                        onClick={() => getEventData()}
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

const EventData = (props) => {
    const events = props.events;

    if (!events || events.length <= 0) {
        return <p>No events reported</p>;
    } else {
        const eventsArray = events.map((data, index) => {
            if (data) {
                return <EventCard key={index} event={data} />;
            } else {
                return <p>No events reported</p>;
            }
        });
        return (
            <React.Fragment>
                <div className="w-100">{eventsArray} </div>
            </React.Fragment>
        );
    }
};

export default UpcomingEvents;
