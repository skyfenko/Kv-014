package edu.softserve.zoo.service;

import edu.softserve.zoo.model.House;
import edu.softserve.zoo.model.Species;
import edu.softserve.zoo.persistence.specification.hibernate.impl.house.composite.HouseField;

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
     * Returns the List of {@link House} by specified {@link edu.softserve.zoo.model.ZooZone} id
     *
     * @param id of {@link edu.softserve.zoo.model.ZooZone}
     * @return List of {@link House}
     */
    List<House> getAllByZooZoneId(Long id);

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
     * Returns capacity of specified {@link House}
     *
     * @param houseId of {@link House}
     * @return current capacity of specified house
     */
    Long getHouseCurrentCapacity(Long houseId);

    /**
     * Returns capacity map for all houses
     *
     * @return current capacity map
     */
    Map<Long,Long> getHouseCapacities();

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
