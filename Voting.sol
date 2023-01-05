// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.26;
// written for Solidity version 0.4.18 and above that doesn't break functionality
contract Voting {
// an event that is called whenever a Candidate is added so the frontend could
// appropriately display the candidate with the right element id (it is used
// to vote for the candidate, since it is one of arguments for the function
// "vote")
address owner;
constructor () {
owner=msg.sender; }

modifier onlyOwner {
require(msg.sender == owner);
_; }
struct Voter {
uint candidateIDVote;
bool isAuthorized;
bool hasVoted;
}
// this flag will help authorization of voter
// this flag will help to keep track of 1 voter - 1 vote
// describes a Candidate
struct Candidate {
string name;
string party;
uint noOFVotes;
bool doesExist;
}
// "bool doesExist" is to check if this Struct exists
// This is so we can keep track of the candidates

// These state variables are used keep track of the number of Candidates/Voters
// and used to as a way to index them
uint numCandidates; // declares a state variable - number Of Candidates
uint numVoters;
uint numOfVotes ;
// Think of these as a hash table, with the key as a uint and value of
// the struct Candidate/Voter. These mappings will be used in the majority
// of our transactions/calls
// These mappings will hold all the candidates and Voters respectively
mapping (uint => Candidate) candidates;
mapping (address => Voter) voters;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* These functions perform transactions, editing the mappings *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
function addCandidate(string memory name, string memory party) onlyOwner public {
// candidateID is the return variable
uint candidateID = numCandidates++;
// Create new Candidate Struct with name and saves it to storage.
candidates[candidateID] = Candidate(name,party,0,true);
}


function Authorize(address _Voter) onlyOwner public {
//Update the boolean value of voter structure by passing the key as
//voter address to mapping (Voters)
voters[_Voter].isAuthorized = true;
}

function vote(uint candidateID) public {
// checks if the struct exists for that candidate
require(!voters[msg.sender].hasVoted);
// this statement is to check this voter is not already voted
require(voters[msg.sender].isAuthorized);
// check here whether voter is allowed to vote using require and voter structure isAuthorized flag
if (candidates[candidateID].doesExist == true) {
voters[msg.sender] = Voter(candidateID, true, true);
candidates[candidateID].noOFVotes++;
numOfVotes++;
numVoters++;
    }
}

/* * * * * * * * * * * * * * * * * * * * * * * * * *
* Getter Functions, marked by the key word "view" *
* * * * * * * * * * * * * * * * * * * * * * * * * */
// finds the total amount of votes for a specific candidate by looping
//through voters
function totalVotes(uint candidateID) view public returns (uint) {
return candidates[candidateID].noOFVotes;
}

function getNumOfCandidates() public view returns(uint) {
return numCandidates;
}
function getNumOfVoters() public view returns(uint) {
return numVoters;
}

// returns candidate information, including its ID, name, and party
function getCandidate(uint candidateID) public view returns (uint,string
memory,string memory ,uint) { return
(candidateID,candidates[candidateID].name,candidates[candidateID].party,
candidates[candidateID].noOFVotes);
    }
}
