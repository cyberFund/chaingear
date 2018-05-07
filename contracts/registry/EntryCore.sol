pragma solidity 0.4.19;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./EntryBase.sol";

/**
* @title Entries engine for Chaingear
* @author Cyber•Congress
* @dev not recommend to use before release!
*/
contract EntryCore is EntryBase, Ownable {

    using SafeMath for uint256;

    /*
    * @dev original structure of entry for example
    */
    struct Entry {
        address expensiveAddress;
        uint256 expensiveUint;
        int128 expensiveInt;
        string expensiveString;

        EntryMeta metainformation;
    }

    // @dev initial structure of entries
    Entry[] internal entries;

    modifier onlyEntryOwner(uint256 _entryId) {
        require(entries[_entryId].metainformation.owner == msg.sender);
        _;
    }

    /**
    * @dev entries amount getter
    * @return entries amount
    */
    function entriesAmount()
        public
        view
        returns (uint256 entryID)
    {
        return entries.length;
    }

    /**
    * @dev example of custom variables getters
    */
    function expensiveAddressOf(uint256 _entryId)
        public
        view
        returns (address)
    {
        return entries[_entryId].expensiveAddress;
    }

    function expensiveUintOf(uint256 _entryId)
        public
        view
        returns (uint256)
    {
        return entries[_entryId].expensiveUint;
    }

    function expensiveIntOf(uint256 _entryId)
        public
        view
        returns (int128)
    {
        return entries[_entryId].expensiveInt;
    }

    function expensiveStringOf(uint256 _entryId)
        public
        view
        returns (string)
    {
        return entries[_entryId].expensiveString;
    }

    function entryInfo(uint256 _entryId)
        public
        view
        returns (address, uint256, int128, string)
    {
        return (
            expensiveAddressOf(_entryId),
            expensiveUintOf(_entryId),
            expensiveIntOf(_entryId),
            expensiveStringOf(_entryId)
        );
    }

    /**
    * @dev entry creation method
    * @return entry ID uint256
    */
    function createEntry()
        public
        onlyOwner
        returns (uint256 entryId)
    {
        EntryMeta memory meta = (EntryMeta(
        {
            lastUpdateTime: block.timestamp,
            createdAt: block.timestamp,
            owner: tx.origin,
            creator: tx.origin,
            currentEntryBalanceETH: 0,
            accumulatedOverallEntryETH: 0
        }));

        Entry memory entry = (Entry(
        {
            expensiveAddress: address(0),
            expensiveUint: uint256(0),
            expensiveInt: int128(0),
            expensiveString: "",
            metainformation: meta
        }));

        uint256 newEntryId = entries.push(entry) - 1;

        return newEntryId;
    }

    /**
    * @dev Entry custom information setter
    * @param custom variables
    */
    function updateEntry(uint256 _entryId, address _newAddress, uint256 _newUint, int128 _newInt, string _newString)
        /* onlyEntryOwner(_entryId) */
        public
    {
        entries[_entryId].expensiveAddress = _newAddress;
        entries[_entryId].expensiveUint = _newUint;
        entries[_entryId].expensiveInt = _newInt;
        entries[_entryId].expensiveString = _newString;

        entries[_entryId].metainformation.lastUpdateTime = block.timestamp;
    }

    /**
    * @dev remove entry method
    * @param entry index uint256
    */
    function deleteEntry(uint256 _entryIndex)
        onlyOwner
        public
    {
        uint256 lastEntryIndex = entries.length.sub(1);
        Entry storage lastEntry = entries[lastEntryIndex];

        entries[_entryIndex] = lastEntry;
        delete entries[lastEntryIndex];
        entries.length--;
    }

    /**
    * @dev entry ownership setter
    * @param entry index uint256
    * @param address of new owner
    */
    function updateEntryOwnership(uint256 _entryID, address _newOwner)
        onlyOwner
        public
    {
        entries[_entryID].metainformation.owner = _newOwner;
    }

    /**
    * @dev entry fund setter
    * @param entry index uint256
    * @param fund amount uint256
    */
    function updateEntryFund(uint256 _entryID, uint256 _amount)
        onlyOwner
        public
    {
        entries[_entryID].metainformation.accumulatedOverallEntryETH.add(_amount);
    }

    /**
    * @dev entry fund claim
    * @param entry index uint256
    * @param fund amount uint256
    */
    function claimEntryFund(uint256 _entryID, uint256 _amount)
        onlyOwner
        public
    {
        entries[_entryID].metainformation.currentEntryBalanceETH.sub(_amount);
    }

    /**
    * @dev entry owner getter
    * @param entry index uint256
    * @return owner address
    */
    function entryOwnerOf(uint256 _entryID)
        public
        view
        returns (address)
    {
        entries[_entryID].metainformation.owner;
    }

    /**
    * @dev entry creator getter
    * @param entry index uint256
    * @return creator address
    */
    function creatorOf(uint256 _entryID)
        public
        view
        returns (address)
    {
        entries[_entryID].metainformation.creator;
    }

    /**
    * @dev entry creating timestamp getter
    * @param entry index uint256
    * @return creation timestamp uint
    */
    function createdAtOf(uint256 _entryID)
        public
        view
        returns (uint)
    {
        entries[_entryID].metainformation.createdAt;
    }

    /**
    * @dev entry UPD timestamp getter
    * @param entry index uint256
    * @return UPD timestamp uint
    */
    function lastUpdateTimeOf(uint256 _entryID)
        public
        view
        returns (uint)
    {
        return entries[_entryID].metainformation.lastUpdateTime;
    }

    /**
    * @dev entry current ETH balance getter
    * @param entry index uint256
    * @return current balance of entry ETH
    */
    function currentEntryBalanceETHOf(uint256 _entryID)
        public
        view
        returns (uint)
    {
        return entries[_entryID].metainformation.currentEntryBalanceETH;
    }

    /**
    * @dev entry accumulated ETH balance getter
    * @param entry index uint256
    * @return current balance of entry ETH
    */
    function accumulatedOverallEntryETHOf(uint256 _entryID)
        public
        view
        returns (uint)
    {
        return entries[_entryID].metainformation.accumulatedOverallEntryETH;
    }

}
