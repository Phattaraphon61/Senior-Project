import axios from "axios";
const apiHost = "https://server.easypayeasywash.tk";

export const getData = (data) => {
    return axios
        .post(apiHost + `/withdraw/getstatus`, data)
        .then(response => {
            // console.log(response.data);
            return response.data;
        })
        .catch(err => {
            console.log(err);
        });
};

export const updatestatus = (data) => {
    return axios
        .post(apiHost + `/withdraw/update`, data)
        .then(response => {
            // console.log(response.data);
            return response.data;
        })
        .catch(err => {
            console.log(err);
        });
};

export const getdashbord = (year) => {
    return axios
        .get(apiHost + `/dashbord/${year}`)
        .then(response => {
            // console.log(response.data);
            return response.data;
        })
        .catch(err => {
            console.log(err);
        });
};