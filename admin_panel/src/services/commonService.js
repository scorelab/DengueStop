import FetchApi from "../utils/apiProviderService";

class CommonService {
    getProvinceNames() {
        var apiUrl = "get_province_names";
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

    getPatientStatuses() {
        var apiUrl = "get_patient_statuses";
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

    getEventStatuses() {
        var apiUrl = "get_event_statuses";
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
}

export default CommonService;
