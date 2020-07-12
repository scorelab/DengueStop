import FetchApi from "../utils/apiProviderService";

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
}

export default EventService;
