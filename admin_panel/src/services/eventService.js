import FetchApi from "../utils/apiProviderService";
import { getSession } from "./sessionService";

class EventService {
    getEventsByOrgId(orgId) {
        var apiUrl = "get_events_by_org/" + orgId.toString();
        return FetchApi("GET", apiUrl)
            .then((res) => {
                if (res.status === 200) {
                    return res.data;
                }
                return null;
            })
            .catch((err) => {
                console.log("error : ", err);
                throw err;
            });
    }

    queryEvents(eventName, province, status, dateRange) {
        var apiUrl = "query_events";
        const currentUser = getSession();
        var orgId = currentUser.org_id;
        var data = {
            orgId: orgId,
            eventName: eventName,
            province: province,
            status: status,
            dateRange: dateRange,
        };
        return FetchApi("POST", apiUrl, data)
            .then((res) => {
                if (res.status === 200) {
                    return res.data;
                }
                return null;
            })
            .catch((err) => {
                console.log("error : ", err);
                throw err;
            });
    }

    updateEventStatus(eventId, newStatus) {
        const apiUrl =
            "update_event_status/" +
            eventId.toString() +
            "/" +
            newStatus.toString();
        return FetchApi("GET", apiUrl)
            .then((res) => {
                if (res.status === 200) {
                    return true;
                }
                return false;
            })
            .catch((err) => {
                console.log("error : ", err);
                throw err;
            });
    }

    createEvent(eventObject) {
        const apiUrl = "create_event";
        const currentUser = getSession();
        const orgId = currentUser.org_id;
        const adminId = currentUser.id;
        // status_id for sets the event to a pending event by default
        const data = {
            name: eventObject.name,
            venue: eventObject.venue,
            location_lat: eventObject.location_lat,
            location_long: eventObject.location_long,
            start_time: eventObject.start_time,
            duration: eventObject.duration,
            coordinator_name: eventObject.coordinator_name,
            coordinator_contact: eventObject.coordinator_contact,
            description: eventObject.description,
            status_id: 1, //status 1 for pending event
            org_id: orgId,
            created_by: adminId,
        };
        console.log(data);
        return FetchApi("POST", apiUrl, data)
            .then((res) => {
                if (res.status === 200) {
                    return res.data;
                }
                return null;
            })
            .catch((err) => {
                console.log("error : ", err);
                throw err;
            });
    }
}

export default EventService;
