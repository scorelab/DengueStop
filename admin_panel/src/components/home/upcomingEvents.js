import React, { useState, useEffect } from "react";
import EventService from "../../services/eventService";
import EventCard from "./eventCard";

const UpcomingEvents = (props) => {
    const [events, setEvents] = useState([]);

    useEffect(() => {
        const eventService = new EventService();
        // should get org id from logged in user
        eventService.getEventsByOrgId(1).then((res) => {
            setEvents(res);
        });
    }, []);

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
        return <div className="w-100">{eventsArray}</div>;
    }
};

export default UpcomingEvents;
