pragma solidity ^0.5.0;

import "./ChoiceType.sol";
import "./MintTokenChoice.sol";
import "../controller/DAO.sol";

contract Choice {

    DAO public dao;
    DAOToken public daoToken;
    ChoiceType public choiceType;

    //votingMachine - Absolute, Asolute Majority, Quarum

    struct ChoiceData {
        address proposedBy;
        string url;
        string status;
        uint256 voteCount;
        uint256 approvalThreshold;
        uint256 expiry;
    }

    struct Voter {
        address voter;
        uint256 vote;
        bool voted;
    }

    ChoiceData choice;
    string[3] validStatus = ["proposed", "approved", "rejected"];

    mapping (address => Voter) voters;

    event voted(address indexed _voter, uint256 _vote);
    event choiceApproved(string _status);

    constructor(DAO _dao, DAOToken _daoToken, uint256 _approvalThreshold, address _choiceType)
    public{
        dao = _dao;
        daoToken = _daoToken;
        choiceType = ChoiceType(_choiceType);
        choice.status = validStatus[0];
        choice.approvalThreshold = _approvalThreshold;
    }

    function getAddress() public view returns(address){
        return address(this);
    }

    function vote(address _voter, uint256 _vote)
    public
    hasNotVoted(_voter)
    validVoter(_voter)
    returns(bool) {
        voters[_voter].voter = _voter;
        voters[_voter].vote = _vote;
        voters[_voter].voted = true;
        choice.voteCount++;
        emit voted (_voter, _vote);
        checkIfVotePassed();
        return true;
    }

    function getVoteCount() public view returns(uint256) {
        return choice.voteCount;
    }

    function getVoteStatus() public view returns(string memory) {
        return choice.status;
    }

    function checkIfVotePassed() private returns(bool){
        if(choice.voteCount==choice.approvalThreshold) {
            choice.status = "approved";
            emit choiceApproved(choice.status);
            choiceType.approveChoice(dao, choice.status);
            return true;
        }
    }

    modifier hasNotVoted(address _voter) {
        require(voters[_voter].voted!=true, "Error: Voter has already voted");
        _;
    }

    modifier validVoter(address _voter) {
        require(daoToken.balanceOf(_voter) > 0, "Error: Voter is not a valid voter");
        _;
    }
}