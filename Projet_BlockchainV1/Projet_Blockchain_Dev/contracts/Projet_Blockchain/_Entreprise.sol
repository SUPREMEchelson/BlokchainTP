// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./_Etablissement.sol";

contract EntrepriseContrat {
    address public adminEntreprise; // L'administrateur du système

    // Référence au contrat d'établissement pour accéder aux données d'évaluation
    EtablissementContrat public etablissementContrat;

    constructor(EtablissementContrat _contractAddress) {
        adminEntreprise = msg.sender;
        etablissementContrat = EtablissementContrat(_contractAddress);
    }

    modifier onlyAdminEntreprise() {
        require(msg.sender == adminEntreprise, "Seul l'administrateur peut effectuer cette operation");
        _;
    }

    struct Entreprise {
        uint id_entreprise;
        string nom_entreprise;
        string date_creation;
        string classification_taille;
        string pays_entreprise;
        string adresse_entreprise;
        string courriel_entreprise;
        string telephone_entreprise;
        string site_web_entreprise;
        uint Agent_entreprise;
        address recruteur; // Seul cet agent peut créer un compte pour l'entreprise
    }

    //mapping(uint => Entreprise) public entreprises;
    mapping(address => Entreprise) public entreprises;

    uint public EntrepriseId = 1;
    uint public Agent_entreprise_Id = 1;

    function creerEntreprise(string memory _nom_entreprise, string memory _date_creation, string memory _classification_taille, string memory _pays_entreprise, string memory _adresse_entreprise, string memory _courriel, string memory _telephone, string memory _site_web) public onlyAdminEntreprise {
        entreprises[msg.sender] = Entreprise(EntrepriseId, _nom_entreprise, _date_creation, _classification_taille, _pays_entreprise, _adresse_entreprise, _courriel, _telephone, _site_web, Agent_entreprise_Id, msg.sender);
        EntrepriseId++;
        Agent_entreprise_Id++;
    }

    function insertEvaluation(uint _id_etudiant, uint _evaluation) public {
        Entreprise storage entreprise = entreprises[msg.sender];

        require(entreprise.recruteur == msg.sender, "Seul l'agent de recrutement peut inserer une evaluation");

        //establishmentContract.evaluation = _evaluation;
        
        // Utilisez le contrat d'établissement pour mettre à jour l'évaluation de l'étudiant
        etablissementContrat.updateStudentEvaluation(_id_etudiant, _evaluation);
    }

    function VerifierDiplome(uint _id_diplome) public view returns(bool, string memory) {
        Entreprise storage entreprise = entreprises[msg.sender];

        require(entreprise.recruteur == msg.sender, "Seul l'agent de recrutement peut verifier un diplome");
        
        // Utilisez le contrat d'établissement pour mettre à jour l'évaluation de l'étudiant
        return etablissementContrat.VerifierDiplome(_id_diplome);
    }
}
