// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract ShipmentTracking {

   address immutable owner; //company
   address parcel_person = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;

   struct Location {
        string name; //location name
        uint arrival; //arrived time
        uint departure; //departured time
    }

    event logActivity(
        string desription, // activity : dispatch, arrive, depart, deliver
        string location,
        uint time,
        uint index
    );

    uint packageId;
    string from;
    string to;
    string originName;
    string destinationName;
    uint departureTime;
    uint deliveryTime;

    Location[] parcelLocations;

   constructor() {
      owner = msg.sender;
   }
   
    modifier onlyOwner() {
        if (msg.sender == owner)
        _;
    }

    modifier onlyParcelPerson() {
        if (msg.sender == parcel_person)
        _;
    }

   function parcelDispatched(
        uint _packageId,
        string memory _from,
        string memory _to,
        string memory _originName,
        string memory _destinationName,
        uint _departureTime
    ) onlyOwner public {
        packageId = _packageId;
        from = _from;
        to = _to;
        originName = _originName;
        destinationName = _destinationName;
        departureTime = _departureTime;
        deliveryTime = 0;

        parcelLocations.push(Location({
            name: _originName,
            arrival: 0,
            departure: block.timestamp
        }));

        emit logActivity("Dispatched", _originName, block.timestamp, parcelLocations.length - 1);
    }

    function parcelArrived(
        string memory _name,
        uint _arrival
    )
        onlyOwner
        public
        returns (bool success)
    {
        if (_arrival == 0) {
            _arrival = block.timestamp;
        }

        parcelLocations.push(Location({
            name: _name,
            arrival: _arrival,
            departure: 0
        }));

        emit logActivity("Arrived" ,_name, _arrival, parcelLocations.length - 1);
        return true;
    }

    function depart(
        uint _index,
        uint _departure
    )
        onlyOwner
        public
        returns (bool success)
    {
        if (_departure == 0) {
            _departure = block.timestamp;
        }

        parcelLocations[_index].departure = _departure;

        emit logActivity(
            "Departed",
            parcelLocations[_index].name,
            _departure,
            _index
        );
        return true;
    }

   function deliver(
        string memory _name,
        uint _arrival
    )
        onlyOwner
        public
        returns (bool success)
    {
        if (_arrival == 0) {
            _arrival = block.timestamp;
        }

        parcelLocations.push(Location({
            name: _name,
            arrival: _arrival,
            departure: 0
        }));

        emit logActivity("Arrived", _name, _arrival, parcelLocations.length - 1);
        emit logActivity("Delivered", _name, _arrival, parcelLocations.length - 1);
        return true;
    }

    function getParcelDetails()
        onlyOwner onlyParcelPerson
        public view
        returns (uint, string memory, string memory, string memory, string memory, uint, uint)
    {
        return (
            packageId,
            from,
            to,
            originName,
            destinationName,
            departureTime,
            deliveryTime
        );
    }
    function getShipmentRoute()
        onlyOwner onlyParcelPerson
        public view
        returns (Location[] memory)
    {
        return parcelLocations;
    }
}
