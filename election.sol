// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Election{

    address public immutable admin;
    constructor() {
        admin = msg.sender;
    }
    modifier onlyAdmin{
        require(msg.sender == admin);
        _;
    }

    bool election_declaration = false;
    //candidate and voters can register untill election is not declared
    //voting occurs only when election is declared
    function declareElection() public {
        election_declaration = true;
    }

    //Candidate Registration Process
    uint public tot_candidates;
    struct Candidate{
        uint c_id;
        string c_name;
        string c_party;
        uint c_votes;
    }
    mapping (uint => Candidate) candidateMap;

    function addCandidate(string memory _name,string memory _party) onlyAdmin public {
        require(election_declaration == false);
        Candidate memory cd = Candidate({c_id:tot_candidates,c_name:_name,c_party:_party,c_votes:0});
        candidateMap[tot_candidates] = cd;
        tot_candidates++;
    }

    //Voter Registration Process
    uint public tot_voters;
    struct Voter{
        address v_id;
        string v_name;
        bool voted;
        bool isRegister;
    }
    mapping (address => Voter) voterMap;
    address[] public voters;
    function addVoter(string memory _name) onlyAdmin public{
        require(election_declaration == false);
        Voter memory vt = Voter({v_id:msg.sender,v_name:_name,voted:false,isRegister:true});
        voterMap[msg.sender] = vt;
        voters.push(msg.sender);
        tot_voters++;
    }

    //Voting day
    function voting(uint _cand_id) public {
        require(election_declaration == true);
        require(voterMap[msg.sender].isRegister == true);
        require(voterMap[msg.sender].voted == false);
        candidateMap[_cand_id].c_votes += 1;
        voterMap[msg.sender].voted = true;
    }

    //Result Declaration
    function winner() onlyAdmin public view returns(string memory,string memory,uint){

        uint max_votes = candidateMap[0].c_votes;
        uint winner_id;
        for(uint i = 0; i < tot_candidates; i++){
            if(candidateMap[i].c_votes > max_votes){
                max_votes = candidateMap[i].c_votes;
                winner_id = i;
            }
        }
        return (candidateMap[winner_id].c_name, candidateMap[winner_id].c_party,candidateMap[winner_id].c_votes);
        //It returns name, party and vote count of winning candidate
    }
}