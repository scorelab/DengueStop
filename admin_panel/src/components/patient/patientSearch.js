import React, { useState, useEffect } from "react";
import { MDBCard, MDBRow, MDBCol, MDBBtn } from "mdbreact";
import CommonService from "../../services/commonService";

const PatientSearch = (props) => {
    const commonService = new CommonService();
    const [patientName, setPatientName] = useState("");
    const [province, setProvince] = useState("all");
    const [provinceArray, setProvinceArray] = useState([]);
    const [statusArray, setStatusArray] = useState([]);
    const [status, setStatus] = useState("all");
    const [dateRange, setDateRange] = useState("all");
    const getIncidents = props.getIncidents;

    useEffect(() => {
        commonService.getProvinceNames().then((res) => {
            makeProvinceArray(res);
        });
        commonService.getPatientStatuses().then((res) => {
            setStatusArray(res);
        });
    }, []);

    const makeProvinceArray = (data) => {
        var tempArray = [];
        data.forEach((province) => {
            tempArray.push(province.name);
        });
        setProvinceArray(tempArray);
    };

    const makeStatusArray = (data) => {
        var tempArray = [];
        data.forEach((status) => {
            tempArray.push(status);
        });
        setStatusArray(tempArray);
    };

    const searchPatient = () => {
        // queries the incidents based on the params
        getIncidents(patientName, province, status, dateRange);
    };

    return (
        <MDBCard className="patient-search-container p-4">
            <MDBRow>
                <MDBCol xs="12" md="12" lg="4">
                    <label>Search by patient name</label>
                    <input
                        type="text"
                        className="form-control"
                        value={patientName}
                        onChange={(event) => {
                            setPatientName(event.target.value);
                        }}
                    />
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by province</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setProvince(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <ProvinceDropdownOptions
                                provinceArray={provinceArray}
                            ></ProvinceDropdownOptions>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by status</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setStatus(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <StatusDropdownOptions
                                statusArray={statusArray}
                            ></StatusDropdownOptions>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Filter by date</label>
                    <div>
                        <select
                            className="browser-default custom-select"
                            onChange={(event) => {
                                setDateRange(event.target.value);
                            }}
                        >
                            <option value="all">All</option>
                            <option value="weekly">Last 7 Days</option>
                            <option value="monthly">From Last Month</option>
                            <option value="yearly">From Last Year</option>
                        </select>
                    </div>
                </MDBCol>
                <MDBCol xs="12" md="3" lg="2">
                    <label>Search</label>
                    <MDBBtn
                        onClick={() => searchPatient()}
                        className="search-patient-button"
                        size="md"
                    >
                        Search
                    </MDBBtn>
                </MDBCol>
            </MDBRow>
        </MDBCard>
    );
};

const ProvinceDropdownOptions = (props) => {
    const provinceArray = props.provinceArray;

    return provinceArray.map((data, index) => {
        if (data) {
            return (
                <option key={index} value={data}>
                    {data}
                </option>
            );
        } else {
            return null;
        }
    });
};

const StatusDropdownOptions = (props) => {
    const statusArray = props.statusArray;

    return statusArray.map((data, index) => {
        if (data) {
            return (
                <option key={index} value={data.id}>
                    {data.status}
                </option>
            );
        } else {
            return null;
        }
    });
};

export default PatientSearch;
