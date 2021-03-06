package edu.softserve.zoo.service;

import edu.softserve.zoo.model.House;
import edu.softserve.zoo.model.Species;
import edu.softserve.zoo.model.ZooZone;
import edu.softserve.zoo.persistence.specification.hibernate.composite.fields.HouseField;

import java.util.List;
import java.util.Set;
import java.util.Map;

/**
 * House specific methods and business logic for service layer
 *
 * @author Serhii Alekseichenko
 */
public interface HouseService extends Service<House> {

    /**
     * Returns the List of {@link House} by specified {@link ZooZone} id
     *
     * @param id of {@link ZooZone}
     * @return List of {@link House}
     */
    List<House> getAllByZooZoneId(Long id);

    /**
     * Returns the List of {@link House} by specified {@link ZooZone} id.
     * {@link House}s in this list are modified using HouseFields.
     *
     * @param id of {@link ZooZone}
     * @param fields requested fields of House
     * @return List of {@link House}
     */
    List<House> getAllByZooZoneId(Long id, Set<HouseField> fields);

    /**
     * Returns the List of {@link House} by specified {@link Species} id
     *
     * @param speciesId of {@link Species}
     * @return List of {@link House}
     */
    List<House> getAllBySpeciesId(Long speciesId);

    /**
     * Returns the List of {@link House} by specified {@link Species} id
     * acceptable for new animal of that species
     *
     * @param speciesId of {@link Species}
     * @return List of {@link House}
     */
    List<House> getAllAcceptableForNewAnimalBySpeciesId(Long speciesId);

    /**
     * All houses capacities.
     *
     * @return map of all houses capacities
     */
    Map<Long, Long> getHousesCurrentCapacityMap();

    /**
     * Houses's current capacity.
     *
     * @param houseId of {@link House}
     * @return current capacity of specified house
     */
    Long getHouseCurrentCapacity(Long houseId);

    /**
     * Increase capacity of {@link House} to specific value
     *
     * @param houseId        of {@link House}
     * @param animalPerHouse of new animal in house
     */
    void increaseHouseCapacity(Long houseId, Integer animalPerHouse);

    /**
     * Decrease capacity of {@link House} to specific value
     *
     * @param houseId        of {@link House}
     * @param animalPerHouse of ex animal in house
     */
    void decreaseHouseCapacity(Long houseId, Integer animalPerHouse);
}
