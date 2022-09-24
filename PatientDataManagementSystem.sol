// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PatientDataManagementSystem {

     address data_analyst = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
     address health_care_policy_maker = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
     address pharmacists = 0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678;
     address [] patientID; 

     uint patientsEnrolled = 0;

     struct patientStruct {
       string name;
       uint age; 
       bool notHealthy; // patient is healty or not
       bool medicalHistory; //patient must provide their medical history
       string medicalHistoryHash; //hashed file of patient's medical history
   }

     mapping (address => patientStruct) patientData;

     modifier onlyDataAnalyst() {
        if (msg.sender == data_analyst)
        _;
    }

     modifier onlyHealthCarePolicyMaker() {
        if (msg.sender == health_care_policy_maker)
        _;
    }

     modifier onlyPharmacists() {
        if (msg.sender == pharmacists)
        _;
    }

    event logData(string message, address);

    function patientEnrollment(
         address _patientID,
         string memory _name,
         uint _age,
         bool _notHealthy,
         bool _medicalHistory,
         string memory _medicalHistoryHash) public onlyDataAnalyst{
            
        patientData[_patientID].name = _name;
        patientData[_patientID].age = _age;
        patientData[_patientID].notHealthy = _notHealthy;
        patientData[_patientID].medicalHistory = _medicalHistory;
        patientData[_patientID].medicalHistoryHash = _medicalHistoryHash;
                
        patientID.push(_patientID);
        patientsEnrolled++;

        emit logData ("New patient has been successfully enrolled with a patient ID:", _patientID);        
    }

    function totalPatients() public view onlyDataAnalyst onlyHealthCarePolicyMaker returns (uint){
        return patientsEnrolled;
    }

     function getPatientDetails(address _patientID) public view onlyDataAnalyst onlyPharmacists returns(
          patientStruct memory
          ){return patientData[_patientID];}

}
