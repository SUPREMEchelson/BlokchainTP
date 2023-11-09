// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./JeuneDiplomeToken.sol";
import "./_Etablissement.sol";

contract CompanyContract {
    address public adminC; 
    JeuneDiplomeToken private tokenContract;
    EstablishmentContract public establishmentContract;

    constructor(EstablishmentContract _establishmentContract, JeuneDiplomeToken _tokenContract) {
        adminC = msg.sender;
        establishmentContract = _establishmentContract;
        tokenContract = _tokenContract;
    }

    modifier onlyAdminC() {
        require(msg.sender == adminC, "Seul l'administrateur peut effectuer cette operation");
        _;
    }

    struct Company {
        uint id;
        string name;
        string address_;
        address recruitmentAgent; 
    }

    mapping(uint => Company) public companies;

    function createCompany(uint _id, string memory _name, string memory _address) public onlyAdminC {
        companies[_id] = Company(_id, _name, _address, msg.sender);
    }

    function insertEvaluation(uint _companyId, uint _studentId, uint _evaluation) public {
        Company storage company = companies[_companyId];
        require(company.recruitmentAgent == msg.sender, "Seul l'agent de recrutement peut inserer une evaluation");
        establishmentContract.updateStudentEvaluation(_studentId, _evaluation);

        // Reward the company with tokens for adding an evaluation
        tokenContract.rewardCompany(company.recruitmentAgent);
    }
}

