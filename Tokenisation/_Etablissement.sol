// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./JeuneDiplomeToken.sol";

contract EstablishmentContract {
    address public admin; 
    JeuneDiplomeToken private tokenContract;

    constructor(JeuneDiplomeToken _tokenContract) {
        admin = msg.sender;
        tokenContract = _tokenContract;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Seul l'administrateur peut effectuer cette operation");
        _;
    }

    struct Student {
        uint id;
        string name;
        string surname;
        string gender;
        uint evaluation;
        address profileAgent; 
    }

    struct Establishment {
        uint id;
        string name;
        string type_;
        address adminAgent; 
    }

    struct Diploma {
        uint id;
        uint studentId;
        uint establishmentId;
        string establishmentName;
        string type_;
        string mention;
    }

    mapping(address => Establishment) public establishmentAdmins;
    mapping(uint => Student) public students;
    mapping(uint => Diploma) public diplomas;

    function createEstablishment(uint _id, string memory _name, string memory _type) public onlyAdmin {
        establishmentAdmins[msg.sender] = Establishment(_id, _name, _type, msg.sender);
    }

    function createStudent(uint _id, string memory _name, string memory _surname, string memory _gender) public {
        Establishment storage establishment = establishmentAdmins[msg.sender];
        require(establishment.id > 0, "L'etablissement n'existe pas ou n'a pas le droit de creer un profil");
        students[_id] = Student(_id, _name, _surname, _gender, 0, msg.sender);
    }

    function addDiploma(uint _id, uint _studentId, string memory _establishmentName, string memory _type, string memory _mention) public {
        Establishment storage establishment = establishmentAdmins[msg.sender];
        require(establishment.id > 0, "L'etablissement n'existe pas ou n'a pas le droit d'ajouter un diplome");
        require(students[_studentId].profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut ajouter un diplome");
        diplomas[_id] = Diploma(_id, _studentId, establishment.id, _establishmentName, _type, _mention);
    }

    function updateStudent(uint _studentId, string memory _name, string memory _surname, string memory _gender) public {
        Student storage student = students[_studentId];
        require(student.profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut mettre a jour un etudiant");
        student.name = _name;
        student.surname = _surname;
        student.gender = _gender;
    }

    function updateStudentEvaluation(uint _studentId, uint _evaluation) public {
        Student storage student = students[_studentId];
        student.evaluation = _evaluation;
    }

    function verifyDiploma(uint _diplomaId, address user) public {
        require(diplomas[_diplomaId].id != 0, "Le diplome n'existe pas");
        require(students[diplomas[_diplomaId].studentId].profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut verifier un diplome");

        // Charge the user for diploma verification
        tokenContract.chargeForVerification(user);
    }
}
