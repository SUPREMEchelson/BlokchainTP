// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtablissementContrat {
    address public admin; // L'administrateur du système

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Seul l'administrateur peut effectuer cette operation");
        _;
    }

    struct Etudiant {
        uint id_etudiant;
        string nom_etudiant;
        string prenom_etudiant;
        string sexe;
        /*string nationalite;
        string statut_civil;
        string adresse;
        string courriel;
        string telephone;
        string section;*/
        string sujet_pfe;
        uint id_entreprise;
        string maitreStage;
        string date_debut_stage;
        string date_fin_stage;
        uint evaluation;
        address profileAgent; // Agent d'établissement qui peut créer un profil
    }

    struct Etablissement {
        uint id_ees;
        string nom_ees;
        string type_ees;
        string pays_ees;
        string site_web_ees;
        uint id_agent_ees;
        address adminAgent; // Seul cet agent peut créer des comptes d'établissement
    }

    struct Diplome {
        uint id_diplome;
        uint id_titulaire;
        uint id_ees;
        string nom_ees;
        string type_diplome;
        string specialite;
        string mention;
        string date_obtention;
    }

    mapping(address => Etablissement) public etablissements;
    mapping(uint => Etudiant) public etudiants;
    mapping(uint => Diplome) public diplomes;
    mapping(address => uint) public evaluationEtudiants;

    uint public EtudiantId = 1;
    uint public DiplomeId = 1;
    uint public EtablissementId = 1;
    uint public AgentId = 1;

    function CreerEtablissement(string memory _nom_ees, string memory _type_ees, string memory _pays_ees, string memory _site_web_ees) public onlyAdmin {
        //etablissements[msg.sender] = Etablissement(_id_ees, _nom_ees, _type_ees, msg.sender);
        etablissements[msg.sender] = Etablissement(EtablissementId, _nom_ees, _type_ees, _pays_ees, _site_web_ees, AgentId, msg.sender);
        EtablissementId++;
        AgentId++;
    }

    function CreerEtudiant(string memory _nom_etudiant, string memory _prenom_etudiant, string memory _sexe, /*string memory _nationalite, string memory _statut_civil, string memory _adresse, string memory _courriel, string memory _telephone, string memory _section,*/ string memory _sujet_pfe, uint _id_entreprise, string memory _maitreStage, string memory _date_debut_stage, string memory _date_fin_stage) public onlyAdmin {
        Etablissement storage etablissement = etablissements[msg.sender];
        require(etablissement.id_ees > 0, "L'etablissement n'existe pas ou n'a pas le droit de creer un profil");
        //students[_id] = Student(_id, _name, _surname, _gender, 0, msg.sender);

        etudiants[EtudiantId] = Etudiant(EtudiantId, _nom_etudiant, _prenom_etudiant, _sexe, /*_nationalite, _statut_civil, _adresse, _courriel, _telephone, _section,*/ _sujet_pfe, _id_entreprise, _maitreStage, _date_debut_stage, _date_fin_stage, 0, msg.sender);
        EtudiantId++;
    }

    function CreerDiplome(uint _id_titulaire, string memory _type_diplome, string memory _specialite, string memory _mention, string memory _date_obtention) public onlyAdmin {
        Etablissement storage etablissement = etablissements[msg.sender];
        require(etablissement.id_ees > 0, "L'etablissement n'existe pas ou n'a pas le droit d'ajouter un diplome");
        require(etudiants[_id_titulaire].profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut ajouter un diplome");
        diplomes[DiplomeId] = Diplome(DiplomeId, _id_titulaire, etablissement.id_ees, etablissement.nom_ees, _type_diplome, _specialite, _mention, _date_obtention);
        DiplomeId++;
    }

    function VerifierDiplome(uint _id_diplome) external view returns (bool, string memory) {
        return (diplomes[_id_diplome].id_diplome > 0, diplomes[_id_diplome].type_diplome);
    }

    function modifierEtudiant(uint _id_etudiant, string memory _nom_etudiant, string memory _prenom_etudiant, string memory _sexe, /*string memory _nationalite, string memory _statut_civil, string memory _adresse, string memory _courriel, string memory _telephone, string memory _section,*/ string memory _sujet_pfe, uint _id_entreprise, string memory _maitreStage, string memory _date_debut_stage, string memory _date_fin_stage) public onlyAdmin {
        Etudiant storage etudiant = etudiants[_id_etudiant];
        require(etudiant.profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut mettre a jour un etudiant");
        //student.name = _name;
        //etudiant.id_etudiant = etudiants[_id_etudiant];
        etudiant.nom_etudiant = _nom_etudiant;
        etudiant.prenom_etudiant = _prenom_etudiant;
        etudiant.sexe = _sexe;
        /*etudiant.nationalite = _nationalite;
        etudiant.statut_civil = _statut_civil;
        etudiant.adresse = _adresse;
        etudiant.courriel = _courriel;
        etudiant.telephone = _telephone;
        etudiant.section = _section;*/
        etudiant.sujet_pfe = _sujet_pfe;
        etudiant.id_entreprise = _id_entreprise;
        etudiant.maitreStage = _maitreStage;
        etudiant.date_debut_stage = _date_debut_stage;
        etudiant.date_fin_stage = _date_fin_stage;
    }

    function updateStudentEvaluation(uint _studentId, uint _evaluation) external  {
        Etudiant storage etudiant = etudiants[_studentId];
        //require(student.profileAgent == msg.sender, "Seul l'etablissement qui a cree le profil peut mettre a jour l'evaluation");
        etudiant.evaluation = _evaluation;
    }
}
