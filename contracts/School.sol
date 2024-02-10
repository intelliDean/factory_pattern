// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ISchool} from "contracts/ISchool.sol";

contract School is ISchool {
    //State variables
    mapping (address=>Student) private students;
    mapping (address=>Teacher) private teachers;
    mapping (address => Person) private persons;
    address private admin;

    //Constructor to initialize state at contract creation
    constructor(address _eoaAddress) {
        admin = _eoaAddress;
        persons[admin] = Person(admin, Role.ADMIN);
    }

    //modifier to make sure that only the admin can perform the operation
    modifier onlyAdmin() {
        require(admin == tx.origin, "Only admin can perform this operation");
        _;
    }

     //modifier to validate teachers only
    modifier onlyTeacher(address _teacher) {
        require(teachers[_teacher].info.role == Role.TEACHER, "This address does not belong to a teacher");
        _;
    }

    //modifier to validate student only
    modifier onlyStudent(address _student) {
        require(students[_student].info.role == Role.STUDENT, "This address does not belong to a student");
        _;
    }

    //modifier to validate admin and teachers only
    modifier adminAndTeacher() {
        address caller = tx.origin;
        require(admin == caller || teachers[caller].info.role == Role.TEACHER, "Unauthorized operation");
        _;
    }

    //Admin or teacher create student. Only admin and teachers can add student
    function authorityAddStudent(address _student, Role role, Class _class) external override  adminAndTeacher {
        Person memory newPerson = Person(_student, role);
        persons[_student] = newPerson;
        Student memory newStudent = Student({
            info: newPerson,
            class: _class,
            result: 0
        });
        students[_student] = newStudent;
    }

    //Admin add teachers. Only admin can add teachers
    function adminAddTeacher(address _teacher, Role _role, string memory _teachNo, Class class, string memory _subject)  external override onlyAdmin {
        Person memory newPerson = Person(_teacher, _role);
        persons[_teacher] = newPerson;
        Teacher memory newTeacher = Teacher({
            info: newPerson,
            teachNo: _teachNo,
            class: class,
            subject: _subject
        });
        teachers[_teacher] = newTeacher;
    }

    // Admin removes teachers. Only admin can remove teachers
    function adminRemoveTeacher(address _teacher) external override  onlyAdmin onlyTeacher(_teacher) {
        delete teachers[_teacher];
    }

    // To get a teacher... if the address does not belong to a teacher it throws an exception
    function getTeacher(address _teacher) external override view onlyTeacher(_teacher) returns(Teacher memory) {
        return teachers[_teacher];
    }

    // To get a student... if the address does not belong to a student it throws an exception
    function getStudent(address _student) external override view  onlyStudent(_student) returns (Student memory) {
        return students[_student];
    }

    //Teacher updates the result of a student. Only the teacher of a student can update the result of his student
    function teacherUpdateStudentResult(address _student, uint16 result) external override {
        require(teachers[msg.sender].class == students[_student].class, "This student is not your student");
         Student memory foundStudent = students[_student];
            foundStudent.result = result;
            students[_student] = foundStudent;
    }

    //Admin or teacher removes student... Only the admin and teachers can remove student
    function authorityRemoveStudent(address _student) external override adminAndTeacher {
        delete students[_student];
    }
}