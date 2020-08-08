// This will provide an abstraction for get and post requests so that it can be used as a common function
import axios from "axios";
import { getToken, hasToken } from "../services/sessionService";

const FetchApi = (method, apiUrl, params) => {
    var baseUrl = "http://127.0.0.1:5000/";
    var url = baseUrl + apiUrl;
    return new Promise((resolve, reject) => {
        if (hasToken) {
            // this will perform auth for token values
            axios({
                method: method,
                url: url,
                data: params,
                headers: {
                    Authorization: "Bearer " + getToken(), // to be changed
                },
                responseType: "json",
            })
                .then((res) => resolve(res))
                .catch((err) => reject(err));
        } else {
            axios({
                method: method,
                url: url,
                data: params,
                responseType: "json",
            })
                .then((res) => resolve(res))
                .catch((err) => reject(err));
        }
    });
};

export default FetchApi;
