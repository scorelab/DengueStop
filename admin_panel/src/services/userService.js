import FetchApi from "../utils/apiProviderService";

class UserService {
    getUserBaseBreakdown() {
        var apiUrl = "get_user_base_breakdown";
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

    loginAdminUser(username, password) {
        console.log(username);
        console.log(password);
    }
}

export default UserService;
