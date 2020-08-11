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
                return null;
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
                return null;
            });
    }

    updateEventStatus(eventId, newStatus) {
        var apiUrl =
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
                return false;
            });
    }
}

export default EventService;
