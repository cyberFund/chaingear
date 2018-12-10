
const generateContractCode = (name, fields) => {

  const structBodyStr = fields.map(f => `${f.type} ${f.name};`).join('\n');

  const createArgsStr = fields.map(f => `${f.type} _${f.name}`).join(', ');
    // const createItemStr = fields.map(f => `${f.name}: _${f.name}`).join(',\n');

  const empty = (type) => {
    if (type === 'string') return '""';
    if (type === 'address') return 'address(0)';
    if (type === 'bool') return 'false';
    if (type === 'uint256') return 'uint256(0)';
    if (type === 'int256') return 'int256(0)';

    return '""';
  }

//TODO Entry[] public entries move to internal, change source in ABI for extracting fields;

  return `

import './Dependencies.sol';


contract Schema is ISchema, Ownable, SupportsInterfaceWithLookup {
    
    bytes4 constant internal INTERFACE_SCHEMA_ID = 0x153366ed;

    struct Entry {
        ${structBodyStr}

    }

    Entry[] public entries;
    
    IDatabase internal database;
    
    event EntryUpdated(
        uint256 _entryID,
        ${createArgsStr}
    );
    
    constructor()
        public
    {
        _registerInterface(INTERFACE_SCHEMA_ID);
        database = IDatabase(owner);
    }
    
    function() external {}

    function createEntry()
        external
        onlyOwner
    {
        Entry memory m = (Entry(
        {
            ${fields.map(({ name, type }) => `${name}: ${empty(type)}`).join(',\n')} 
        }));
        entries.push(m);
    }
    
    
    function readEntry(uint256 _entryID)
        external
        view
        returns (${fields.map(({ name, type }) => type).join(', ')})
    {
        uint256 entryIndex = database.getIndexByID(_entryID);
        return (
            ${fields.map(({ name, type }) => `entries[entryIndex].${name}`).join(',\n')}
        );
    }


    function updateEntry(
        uint256 _entryID, 
        ${createArgsStr}
    )
        external
    {
        database.auth(_entryID, msg.sender);
        
        uint256 entryIndex = database.getIndexByID(_entryID);
        
        Entry memory m = (Entry(
        {
            ${fields.map(f => `${f.name}: _${f.name}`).join(',\n')}
        }));    
        entries[entryIndex] = m;
        
        emit EntryUpdated(_entryID, ${fields.map(field => `_${field.name}`).join(', ')});
    }


    function deleteEntry(uint256 _entryIndex)
        external
        onlyOwner
    {    
        uint256 lastEntryIndex = entries.length - 1;
        Entry memory lastEntry = entries[lastEntryIndex];
        
        entries[_entryIndex] = lastEntry;
        delete entries[lastEntryIndex];
        entries.length--;
    }

}

`;
}

module.exports = generateContractCode;
