// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ISchool} from "contracts/ISchool.sol";
import {School} from "contracts/School.sol";


contract SchoolFactory {

    address private eoaAddress;
    uint public noOfContract;
    School public school;
    mapping (uint => address) public contracts;

    constructor() {
        eoaAddress = msg.sender;
    }

    function createSchool(address _eoaAddress) public {
        school = new School(_eoaAddress);
        contracts[noOfContract] = address(school);
        noOfContract++;
    }

    function getContract(uint contractIndex) public view returns (address) {
        return contracts[contractIndex];
    }

        //Admin or teacher create student. Only admin and teachers can add student
    function authorityAddStudent(uint index, address _student, ISchool.Role role, ISchool.Class _class) external  {
        ISchool(contracts[index]).authorityAddStudent(_student, role, _class);
    }

    //Admin add teachers. Only admin can add teachers
    function adminAddTeacher(uint index, address _teacher, ISchool.Role role, string memory _teachNo, ISchool.Class _class, string memory _subject)  external {
        ISchool(contracts[index]).adminAddTeacher(_teacher, role, _teachNo, _class, _subject);
    }

    // Admin removes teachers. Only admin can remove teachers
    function adminRemoveTeacher(uint index, address _teacher) external {
        ISchool(contracts[index]).adminRemoveTeacher(_teacher);
    }

    // To get a teacher... if the address does not belong to a teacher it throws an exception
    function getTeacher(uint index, address _teacher) external view returns(ISchool.Teacher memory) {
        return ISchool(contracts[index]).getTeacher(_teacher);
    }

    // To get a student... if the address does not belong to a student it throws an exception
    function getStudent(uint index, address _student) external view returns (ISchool.Student memory) {
        return ISchool(contracts[index]).getStudent(_student);
    }

    //Teacher updates the result of a student. Only the teacher of a student can update the result of his student
    function teacherUpdateStudentResult(uint index, address _student, uint16 result) external {
        ISchool(contracts[index]).teacherUpdateStudentResult(_student, result);
    }

    //Admin or teacher removes student... Only the admin and teachers can remove student
    function authorityRemoveStudent(uint index, address _student) external {
        ISchool(contracts[index]).authorityRemoveStudent(_student);
    }
}