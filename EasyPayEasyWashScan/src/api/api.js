import axios from "axios";
const apiHost = "https://server.easypayeasywash.tk";

export const sendnoti = (data) => {
    return axios
        .post(apiHost + `/washing/update`, data)
        .then(response => {
            // console.log(response.data);
            return response.data;
        })
        .catch(err => {
            console.log(err);
        });
};