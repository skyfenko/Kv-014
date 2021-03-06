package edu.softserve.zoo.controller.rest;

import edu.softserve.zoo.annotation.DocsClassDescription;
import edu.softserve.zoo.annotation.DocsParamDescription;
import edu.softserve.zoo.annotation.DocsTest;
import edu.softserve.zoo.dto.AnimalClassDto;
import edu.softserve.zoo.model.AnimalClass;
import edu.softserve.zoo.service.AnimalClassService;
import edu.softserve.zoo.service.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

import static edu.softserve.zoo.controller.rest.Routes.ANIMAL_CLASSES;

/**
 * Rest controller for {@link AnimalClass} domain objects.
 *
 * @author Bohdan Cherniakh
 */
@RestController
@RequestMapping(ANIMAL_CLASSES)
@DocsClassDescription("Class resource")
public class AnimalClassRestController extends AbstractRestController<AnimalClassDto, AnimalClass> {

    @Autowired
    private AnimalClassService service;

    @DocsTest
    @RequestMapping(method = RequestMethod.GET)
    @Override
    public List<AnimalClassDto> getAll() {
        return super.getAll();
    }

    @DocsTest(pathParameters = "1")
    @RequestMapping(path = "/{id}", method = RequestMethod.GET)
    @Override
    public AnimalClassDto getById(@PathVariable @DocsParamDescription("The class id") Long id) {
        return super.getById(id);
    }

    @Override
    protected Service<AnimalClass> getService() {
        return service;
    }
}
