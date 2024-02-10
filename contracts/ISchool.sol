// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ISchool{
    //ENUM of role
    enum Role {
        ADMIN,
        TEACHER,
        STUDENT
    }
    //ENUM of classes from Primary 1 - Primary 6
    enum  Class {
        PRY1,
        PRY2,
        PRY3,
        PRY4,
        PRY5,
        PRY6
    }

    //Struct of Person Object
    struct Person {
        address id;
        Role role;
    }

    //Struct of Student Object
    struct Student {
        Person info;
        Class class;
        uint16 result;
    }

    //Struct of Admin Object
    struct Admin {
        Person info;
        string adminNo;
    }

    //Struct of Teacher Object
    struct Teacher {
        Person info;
        string teachNo;
        Class class;
        string subject;
    }

    function authorityAddStudent(address _student, Role role, Class _class) external ;

    //Admin add teachers. Only admin can add teachers
    function adminAddTeacher(address _teacher, Role _role, string memory _teachNo, Class class, string memory _subject)  external ;

    // Admin removes teachers. Only admin can remove teachers
    function adminRemoveTeacher(address _teacher) external  ;

    // To get a teacher... if the address does not belong to a teacher it throws an exception
    function getTeacher(address _teacher) external  view returns(Teacher memory);

    // To get a student... if the address does not belong to a student it throws an exception
    function getStudent(address _student) external  view  returns (Student memory) ;

    //Teacher updates the result of a student. Only the teacher of a student can update the result of his student
    function teacherUpdateStudentResult(address _student, uint16 result) external ;

    //Admin or teacher removes student... Only the admin and teachers can remove student
    function authorityRemoveStudent(address _student) external  ;
}