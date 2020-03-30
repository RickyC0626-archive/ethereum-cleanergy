pragma solidity >=0.4.17 < 0.7.0;

contract Cleanergy
{
    // Model a consumer
    struct Consumer
    {
        uint id;
        string name;
        string city;
        uint energyConsumptionRate;
    }
}