import FetchApi from "../utils/apiProviderService";

class AuthService {
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

    async loginAdminUser(username, password) {
        const userObject = {
            user: username,
            pass: password,
        };
        var apiUrl = "login_admin_user";
        return FetchApi("POST", apiUrl, userObject)
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

    logoutAdminUser() {}

    createAdminUser(adminObject) {}
}

export default AuthService;
