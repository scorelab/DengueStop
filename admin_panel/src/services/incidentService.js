import FetchApi from "../utils/apiProviderService";

class IncidentService {
    getIncidentsByOrgId(orgId) {
        var apiUrl = "get_pending_incidents_by_org/" + orgId.toString();
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

    verifyIncident(incident_id, verified_admin_id) {
        var apiUrl =
            "verify_incident/" +
            incident_id.toString() +
            "/" +
            verified_admin_id.toString();
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

    declineIncident(incident_id, verified_admin_id) {
        var apiUrl =
            "decline_incident/" +
            incident_id.toString() +
            "/" +
            verified_admin_id.toString();
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

    getTotalIncidentSummary() {
        var apiUrl = "get_total_incident_summary";
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

export default IncidentService;
